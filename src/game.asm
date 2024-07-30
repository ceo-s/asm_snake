%include "io.asm"
%include "ansicodes.asm"
%include "sleep.asm"
%include "termcontrol.asm"
%include "memory.asm"

; mov loads struc coordinate_s in Little Endian, so directions are like this
DIRECTION_UP    equ 0x0000ffff ; x + 0 , y - 1
DIRECTION_LEFT  equ 0xffff0000 ; x - 1 , y + 0
DIRECTION_DOWN  equ 0x00000001 ; x + 0 , y + 1
DIRECTION_RIGHT equ 0x00010000 ; x + 1 , y + 0

SNAKE_HEAD_CHAR equ 79
SNAKE_BODY_CHAR equ 111
FRUIT_BASE_CHAR equ 64

%define TIOCGWINSZ 0x5413
%define TIOCSWINSZ 0x5414

struc coordinate_s
  .y: resw 1 ; short
  .x: resw 1 ; short
endstruc

struc listnode_s
  .coords: resw 2 ; coordinate_s
  .next:   resq 1 ; listnode *_s
endstruc

struc snake_s
  .head:      resq 1 ; listnode *_s (it is actually a tail)
  .tail:      resq 1 ; listnode *_s (and this is the head ) (i messed up with queue terms)
  .size:      resd 1 ; int
  .direction: resd 1 ; int
endstruc

section .data
  ; ANSI strings
  greenColor db ANSI_TEXT_COLOR_GREEN
  noColor  db ANSI_TEXT_COLOR_NORMAL

  ; String literals
  sl1 db `SNAKE GAME!\n`,0
  sl2 db `Allocating listnode failed! Exiting!\n`,0
  sl3 db `GAME OVER!\nPress :ESC: to quit.\nPress :ENTER: to restart.\n`,0
  ; Intro
  countdownTimespec dq 1,0

  ; Field
  fieldSize:
    istruc coordinate_s
      at coordinate_s.y, dw 20
      at coordinate_s.x, dw 70
    iend

  ; Gameplay
  snake:
    istruc snake_s
      at snake_s.head,      dq 0
      at snake_s.tail,      dq 0
      at snake_s.size,      dd 0
      at snake_s.direction, dd 0
    iend

  fruitCoords:
    istruc coordinate_s
      at coordinate_s.y, dw 0
      at coordinate_s.x, dw 0
    iend

  gameIsOver dq 0
  gameSpeedTimespec dq 0, MILISEC_TO_NANOSEC(250)
  ; Outro

section .text
  global _start

_start:
  callproc main
  callproc exit, I(rax)

; exit(int exitcode) -> noreturn
_exit:
  callproc end_game
  mov rax, SYS_EXIT
  syscall


; main() -> long
_main:
  push rbp
  mov rbp, rsp

  callproc init_winsize
  callproc hide_cursor
  callproc init_termios
  callproc enable_raw_mode


  callproc greet
  callproc init_snake
  callproc start_game

  mov rax, 0

  mov rsp, rbp
  pop rbp
  ret

; init_winsize() ->void
_init_winsize:
  mov rax, SYS_IOCTL
  mov rdi, STDOUT
  mov rsi, TIOCGWINSZ
  mov rdx, fieldSize
  syscall
  ret

; greet() -> void
_greet:
  push rbp
  mov rbp, rsp

  callproc clear_screen
  mov rbx, fieldSize
  sub rsp, 0x18

  mov rax, 0
  mov ax, WORD [rbx + coordinate_s.x]
  mov rdx, 0
  mov rcx, 2
  div rcx
  mov [rbp - 0x8], rax
  mov rdi, rax
  sub rdi, 6

  mov rax, 0
  mov ax, WORD [rbx + coordinate_s.y]
  mov rdx, 0
  div rcx
  mov [rbp - 0x10], rax
  mov rsi, rax
  callproc move_cursor


  callproc puts, P(greenColor)
  callproc puts, P(sl1)
  callproc puts, P(noColor)

  mov rdi, [rbp - 0x8]
  sub rdi, 1
  mov rsi, [rbp - 0x10]
  inc rsi
  callproc move_cursor

  mov QWORD [rbp - 0x18], 3
  
  .countdown_loop:
    callproc print_integer, I([rbp - 0x18])
    callproc putc, I(8)
    callproc sleep, P(countdownTimespec)
    dec QWORD [rbp - 0x18]
    cmp QWORD [rbp - 0x18], 0
    jg .countdown_loop
  
  add rsp, 0x18

  mov rsp, rbp
  pop rbp
  ret

; start_game() -> void
_start_game:
  callproc clear_screen

  .game_loop:
    callproc sleep, P(gameSpeedTimespec)
    callproc read_input
    callproc move_snake
    ; callproc handle_collision

    mov rax, QWORD [gameIsOver]
    test rax, rax
    jz .game_loop

  ret

; end_game() -> void
_end_game:
  callproc clear_screen
  callproc puts, P(sl3)
  callproc show_cursor
  callproc disable_raw_mode
  ret

; init_snake() -> void
_init_snake:
  push rax

  callproc get_list_node, I(6), I(5), P(0)
  mov QWORD [snake + snake_s.tail], rax
  callproc get_list_node, I(5), I(5), P(rax)
  mov QWORD [snake + snake_s.head], rax
  mov DWORD [snake + snake_s.size], 2
  mov DWORD [snake + snake_s.direction], DIRECTION_RIGHT

  pop rax
  ret

; get_list_node(int x, int y, listnode *next) -> listnode *
_get_list_node:
  push rdi
  callproc alloc, I(12)
  pop rdi
  cmp rax, -1
  jne .noerror
  callproc puts, P(sl2)
  callproc exit, I(12)

  .noerror:
  
  mov WORD  [rax + coordinate_s.y],  si
  mov WORD  [rax + coordinate_s.x],  di
  mov QWORD [rax + listnode_s.next], rdx

  ret

; inc_snake() -> void
_inc_snake:
  push rax
  push rdi
  push rsi
  push rdx

  mov rdx, QWORD [snake + snake_s.head]
  mov rdi, 0
  mov di, WORD [rdx + coordinate_s.x]
  mov rsi, 0
  mov si, WORD [rdx + coordinate_s.y]
  callproc get_list_node

  mov QWORD [snake + snake_s.head], rax

  mov eax, DWORD [snake + snake_s.size]
  inc eax
  mov DWORD [snake + snake_s.size], eax

  pop rdx
  pop rsi
  pop rdi
  pop rax
  ret

; move_snake() -> void
_move_snake:
  push rax
  push rdi
  push rsi
  push rdx
  push rbx

  mov rdx, snake

  mov rax, QWORD [rdx]
  mov rbx, QWORD [rax + listnode_s.next]
  mov QWORD [rdx], rbx
  mov QWORD [rax + listnode_s.next], 0

  ; erasing old snake end
  mov rdi, 0
  mov di, WORD [rax + coordinate_s.x]
  mov rsi, 0
  mov si, WORD [rax + coordinate_s.y]
  callproc move_cursor
  callproc putc, I(32)
  ; enderasing

  add rdx, 0x8 ; snake->tail
  mov rbx, [rdx]

  ; redraw old snake start to snake body
  mov rdi, 0
  mov di, WORD [rbx + coordinate_s.x]
  mov rsi, 0
  mov si, WORD [rbx + coordinate_s.y]
  callproc move_cursor
  callproc putc, I(SNAKE_BODY_CHAR)
  ; endredraw

  mov rbx, [rdx]
  mov QWORD [rbx + listnode_s.next], rax
  mov esi, DWORD [rbx]
  mov DWORD [rax], esi
  mov QWORD [rdx], rax

  mov rdx, rax
  callproc calculate_move
  mov DWORD [rdx + listnode_s.coords], eax

  ; draw new snake start
  mov rdi, 0
  mov di, WORD [rdx + coordinate_s.x]
  mov rsi, 0
  mov si, WORD [rdx + coordinate_s.y]
  callproc move_cursor
  callproc putc, I(SNAKE_HEAD_CHAR)
  ; enddraw

  pop rbx
  pop rdx
  pop rsi
  pop rdi
  pop rax
  ret

; calculate_move() -> coordinate_s
; returns coordinate struc in eax
_calculate_move:
  push rdi
  push rdx
  
  mov rdi, QWORD [snake + snake_s.tail]
  mov eax, DWORD [rdi + listnode_s.coords]
  mov edx, DWORD [snake + snake_s.direction]

  add ax, dx
  xor dx, dx
  add eax, edx

  pop rdx
  pop rdi
  ret

; handle_collision()
_handle_collision:
  mov rax, [snake + snake_s.tail]
  mov dx, [rax + coordinate_s.x]
  cmp dx, 0
  jl .bumped
  cmp dx, WORD [fieldSize + coordinate_s.x]
  jg .bumped

  cmp dx, WORD [fruitCoords + coordinate_s.x]

  ; TODO bruh i ended here. Want to handle fruit collision
  ; Update. I'll handle it after render mechanism
  

  mov dx, [rax + coordinate_s.y]
  cmp dx, 0
  jl .bumped
  cmp dx, WORD [fieldSize + coordinate_s.y]
  jg .bumped

  cmp dx, WORD [fruitCoords + coordinate_s.y]


  ret

  .ate_fuit:
  callproc update_fruit
  callproc inc_snake
  ret

  .bumped:
  mov QWORD [gameIsOver], 1
  ret

; init_fruit() -> void
_init_fruit:

  ret

; update_fruit() -> void
_update_fruit:
  
  ret

; read_input() -> void
_read_input:
  push rax
  push rdi
  push rsi
  push rdx

  push rbp
  mov rbp, rsp
  sub rsp, 8
  mov QWORD [rsp], 0

  .while: ; rax != 0
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, rsp
    mov rdx, 1
    syscall
    test rax, rax
    jnz .while

  mov rax, 0
  mov al, BYTE [rsp]

  .if:
  .isw:
    cmp al, 'w'
    jne .isa
    mov rdx, DIRECTION_UP
    jmp .endif

  .isa:
    cmp al, 'a'
    jne .iss
    mov rdx, DIRECTION_LEFT
    jmp .endif
  
  .iss:
    cmp al, 's'
    jne .isd
    mov rdx, DIRECTION_DOWN
    jmp .endif
  
  .isd:
    cmp al, 'd'
    jne .else
    mov rdx, DIRECTION_RIGHT
    jmp .endif

  .else:
    mov rdx, 0  

  .endif:

  cmp rdx, 0
  je .procend

  mov DWORD [snake + snake_s.direction], edx

  .procend:

  mov rsp, rbp
  pop rbp

  pop rdx
  pop rsi
  pop rdi
  pop rax
  ret