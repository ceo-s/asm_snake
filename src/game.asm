%include "io.asm"
%include "ansicodes.asm"
%include "sleep.asm"
%include "termcontrol.asm"
%include "memory.asm"
%include "random.asm"

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

section .bss
  mainBasePointer resq 1

section .data
  ; ANSI strings
  redColor db ANSI_TEXT_COLOR_BOLD_RED
  noColor  db ANSI_TEXT_COLOR_NORMAL

  ; String literals
  sl0 db `SNAKE GAME`,0
  sl1 db `BE READY!`,0
  sl2 db `Allocating listnode failed! Exiting!\n`,0
  sl3 db `GAME OVER`,0
  sl4 db `SCORE: `,0
  sl5 db `Record: 0`,0
  sl6 db `Start game`,0
  sl7 db `Difficulty: [###--]`,0
  sl8 db `Exit`,0
  sl9 db `=>`,0
  sl10 db `PAUSE`,0
  sl11 db `Continue game`,0
  sl12 db `Exit to main menu`,0
  sl13 db `Exit game`,0
  sl14 db `Restart`,0

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

  gameSpeedTimespec dq 0, MILISEC_TO_NANOSEC(31)
  gameDifficulty dq 3
  ; Outro

section .text
  global _start

_start:
  callproc set_time_based_srand
  callproc main
  callproc exit, I(rax)

; exit(int exitcode) -> noreturn
_exit:
  callproc clear_screen
  callproc move_cursor, I(0), I(0)
  callproc disable_raw_mode
  mov rax, SYS_EXIT
  syscall


; main() -> long
_main:
  push rbp
  mov rbp, rsp
  
  mov QWORD [mainBasePointer], rbp

  callproc init_winsize
  callproc hide_cursor
  callproc init_termios
  callproc enable_raw_mode

  .game_start:
  mov rbp, QWORD [mainBasePointer]
  callproc clear_screen
  callproc enter_main_menu
  .game_restart:
  callproc init_snake
  callproc generate_fruit
  callproc greet
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
  sub rdi, 5

  mov rax, 0
  mov ax, WORD [rbx + coordinate_s.y]
  mov rdx, 0
  div rcx
  mov [rbp - 0x10], rax
  mov rsi, rax
  callproc move_cursor


  callproc puts, P(redColor)
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
  callproc render_score
  callproc render_fruit

  push 0
  push 0
  mov rax, QWORD [gameSpeedTimespec + 0x8]
  mov rcx, QWORD [gameDifficulty]
  shl rax, cl
  mov QWORD [rsp + 0x8], rax

  .game_loop:
    callproc sleep, P(rsp)
    callproc read_input
    callproc move_snake
    callproc handle_collision

    jmp .game_loop

  add rsp, 0x10

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
  push rax
  push rdi
  push rsi

  mov rax, QWORD [snake + snake_s.tail]

  mov rdi, 0
  mov di, WORD [rax + coordinate_s.x]
  dec di
  cmp di, WORD [fieldSize + coordinate_s.x]
  jge .bumped
  inc di
  cmp di, 0
  jle .bumped

  mov rsi, 0
  mov si, WORD [rax + coordinate_s.y]
  dec si
  cmp si, WORD [fieldSize + coordinate_s.y]
  jge .bumped
  inc si
  cmp si, 2
  jle .bumped

  cmp di, WORD [fruitCoords + coordinate_s.x]
  jne .initfor
  cmp si, WORD [fruitCoords + coordinate_s.y]
  je .ate_fruit


  .initfor:
  mov rax, QWORD [snake + snake_s.tail]
  mov edi, DWORD [rax]
  mov rax, QWORD [snake + snake_s.head]


  .for:
    cmp rax, QWORD [snake + snake_s.tail]
    je .forend
    mov esi, DWORD [rax]
    cmp edi, esi
    je .bumped
    mov rax, QWORD [rax + listnode_s.next]
    jmp .for

  .forend:

  jmp .procend

  .bumped:
    callproc enter_game_over_menu

  .ate_fruit:
    callproc inc_snake
    callproc render_score
    callproc generate_fruit
    callproc render_fruit

  .procend:
  
  pop rsi
  pop rdi
  pop rax

  ret

; generate_fruit() -> void
_generate_fruit:
  push rax
  push rdi
  push rsi

  mov rdi, 0
  mov rsi, 0
  mov si, WORD [fieldSize + coordinate_s.x]
  inc si
  callproc randint
  mov WORD [fruitCoords + coordinate_s.x], ax

  mov rdi, 3
  mov rsi, 0
  mov si, WORD [fieldSize + coordinate_s.y]
  inc si
  callproc randint
  mov WORD [fruitCoords + coordinate_s.y], ax

  pop rsi
  pop rdi
  pop rax
  
  ret

; render_fruit() -> void
_render_fruit:
  push rdi
  push rsi

  mov rdi, 0
  mov di, WORD [fruitCoords + coordinate_s.x]
  mov rsi, 0
  mov si, WORD [fruitCoords + coordinate_s.y]
  callproc move_cursor
  callproc putc, I(FRUIT_BASE_CHAR)

  pop rsi
  pop rdi

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
    cmp DWORD [snake + snake_s.direction], DIRECTION_DOWN
    je .procend
    jmp .endif

  .isa:
    cmp al, 'a'
    jne .iss
    mov rdx, DIRECTION_LEFT
    cmp DWORD [snake + snake_s.direction], DIRECTION_RIGHT
    je .procend
    jmp .endif
  
  .iss:
    cmp al, 's'
    jne .isd
    mov rdx, DIRECTION_DOWN
    cmp DWORD [snake + snake_s.direction], DIRECTION_UP
    je .procend
    jmp .endif
  
  .isd:
    cmp al, 'd'
    jne .isesc
    mov rdx, DIRECTION_RIGHT
    cmp DWORD [snake + snake_s.direction], DIRECTION_LEFT
    je .procend
    jmp .endif

  .isesc:
    cmp al, 27
    jne .else
    callproc enter_pause_menu
    callproc rerender_game_frame

    jmp .procend

  .else:
    jmp .procend

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

; render_score() -> void
_render_score:
  push rax
  push rdi
  push rsi
  push rdx
  push rcx

  mov rax, 0
  mov ax, WORD [fieldSize + coordinate_s.x]
  mov rdx, 0
  mov rdi, 2
  div rdi


  sub rax, 4
  mov rdi, rax
  
  callproc move_cursor, I(rax), I(1)
  callproc puts, P(sl4)
  mov edi, DWORD [snake + snake_s.size]
  sub rdi, 2
  callproc print_integer
  callproc move_cursor, I(1), I(2)

  mov rcx, 0
  mov cx, WORD [fieldSize + coordinate_s.x]

  .while: ; rcx >= 0
    callproc putc, I(`_`)
    dec rcx
    test rcx, rcx
    jnz .while

  pop rcx
  pop rdx
  pop rsi
  pop rdi
  pop rax
  ret

; enter_main_menu() -> void
_enter_main_menu:
  ; 1     SNAKE GAME
  ; 2     Record: 0
  ; 3   
  ; 4     Start game          = option 0
  ; 5 Difficulty: [-----]     = option 1
  ; 6        Exit             = option 2

  push rbp
  mov rbp, rsp
  ; rbp - 0x8  = fieldSize.x / 2
  ; rbp - 0x10 = fieldSize.y / 2
  ; rbp - 0x18 = current menu option
  ; rbp - 0x20 = previous menu option
  ; rbp - 0x28 = input read buffer

  mov rax, 0
  mov ax, WORD [fieldSize + coordinate_s.x]
  mov rdx, 0
  mov rdi, 2
  div rdi
  push rax

  mov ax, WORD [fieldSize + coordinate_s.y]
  mov rdx, 0
  div rdi
  push rax

  push 0
  push 0
  push 1488

  ; 1
  mov rdi, QWORD [rbp - 0x8]
  sub rdi, 5
  mov rsi, QWORD [rbp - 0x10]
  sub rsi, 2
  callproc move_cursor
  callproc puts, P(sl0)

  ; 2
  mov rdi, QWORD [rbp - 0x8]
  sub rdi, 5
  mov rsi, QWORD [rbp - 0x10]
  sub rsi, 1
  callproc move_cursor
  callproc puts, P(sl5)

  ; 4
  mov rdi, QWORD [rbp - 0x8]
  sub rdi, 5
  mov rsi, QWORD [rbp - 0x10]
  add rsi, 1
  callproc move_cursor
  callproc puts, P(sl6)

  ; 5
  mov rdi, QWORD [rbp - 0x8]
  sub rdi, 9
  mov rsi, QWORD [rbp - 0x10]
  add rsi, 2
  callproc move_cursor
  callproc puts, P(sl7)


  ; 6
  mov rdi, QWORD [rbp - 0x8]
  sub rdi, 2
  mov rsi, QWORD [rbp - 0x10]
  add rsi, 3
  callproc move_cursor
  callproc puts, P(sl8)

  .unhighlight_previous_option:
    mov rdi, QWORD [rbp - 0x8]
    sub rdi, 12
    mov rsi, QWORD [rbp - 0x10]
    add rsi, QWORD [rbp - 0x20]
    inc rsi
    callproc move_cursor
    callproc putc, I(` `)
    callproc putc, I(` `)
    mov rdi, QWORD [rbp - 0x18]
    mov QWORD [rbp - 0x20], rdi

  .highlight_current_option:
    mov rdi, QWORD [rbp - 0x8]
    sub rdi, 12
    mov rsi, QWORD [rbp - 0x10]
    add rsi, QWORD [rbp - 0x18]
    inc rsi
    callproc move_cursor
    callproc puts, P(sl9)

  jmp .render_difficulty

  .handle_input:
    .while: ; rax == 0
      mov rax, SYS_READ
      mov rdi, STDIN
      mov rsi, rbp
      sub rsi, 0x28
      mov rdx, 1
      syscall
      test rax, rax
      jz .while
    
    mov rax, 0
    mov al, [rbp - 0x28]
    
    .if_enter:
      cmp al, 10
      jne .if_up
      .if_option_is_start:
        cmp QWORD [rbp - 0x18], 0
        je .menu_end

      .if_option_is_exit:
        cmp QWORD [rbp - 0x18], 2
        je _exit

      jmp .handle_input
    
    .if_up:
      cmp al, `w`
      jne .if_down
      dec QWORD [rbp - 0x18]
      cmp QWORD [rbp - 0x18], 0
      jnl .unhighlight_previous_option
      inc QWORD [rbp - 0x18]

      jmp .unhighlight_previous_option

    .if_down:
      cmp al, `s`
      jne .if_option_is_difficulty
      inc QWORD [rbp - 0x18]
      cmp QWORD [rbp - 0x18], 2
      jng .unhighlight_previous_option
      dec QWORD [rbp - 0x18]

      jmp .unhighlight_previous_option

    .if_option_is_difficulty:
      cmp QWORD [rbp - 0x18], 1
      jne .handle_input

      .if_right:
        cmp al, `d`
        jne .if_left
        cmp QWORD [gameDifficulty], 5
        je .render_difficulty
        inc QWORD [gameDifficulty]

        jmp .render_difficulty
        
      .if_left:
        cmp al, `a`
        jne .handle_input
        cmp QWORD [gameDifficulty], 1
        je .render_difficulty
        dec QWORD [gameDifficulty]

        jmp .render_difficulty

      jmp .handle_input

  .render_difficulty:
    mov rdi, QWORD [rbp - 0x8]
    add rdi, 3
    mov rsi, QWORD [rbp - 0x10]
    add rsi, 2
    callproc move_cursor
    callproc putc, I(`[`)
    mov rcx, QWORD [gameDifficulty]

    .for: ; rcx > 0
      callproc putc, I(`#`)
      dec rcx
      test rcx, rcx
      jnz .for
    
    mov rcx, 5
    sub rcx, QWORD [gameDifficulty]
    .for2:
      test rcx, rcx
      je .for2end
      callproc putc, I(`-`)
      dec rcx
      jmp .for2
    .for2end:

    callproc putc, I(`]`)
    jmp .handle_input

  .menu_end:

  mov rsp, rbp
  pop rbp
  ret

; enter_pause_menu() -> void
_enter_pause_menu:
  ; 1       PAUSE
  ; 2   
  ; 3   Continue game    = option 0
  ; 4 Exit to main menu  = option 1
  ; 5     Exit game      = option 2
  callproc clear_screen
  push rbp
  mov rbp, rsp
  ; rbp - 0x8  = fieldSize.x / 2
  ; rbp - 0x10 = fieldSize.y / 2
  ; rbp - 0x18 = current menu option
  ; rbp - 0x20 = previous menu option
  ; rbp - 0x28 = input read buffer

  mov rax, 0
  mov ax, WORD [fieldSize + coordinate_s.x]
  mov rdx, 0
  mov rdi, 2
  div rdi
  push rax

  mov ax, WORD [fieldSize + coordinate_s.y]
  mov rdx, 0
  div rdi
  push rax

  push 0
  push 0
  push 1488

  ; 1
  mov rdi, QWORD [rbp - 0x8]
  sub rdi, 3
  mov rsi, QWORD [rbp - 0x10]
  sub rsi, 1
  callproc move_cursor
  callproc puts, P(sl10)

  ; 3
  mov rdi, QWORD [rbp - 0x8]
  sub rdi, 7
  mov rsi, QWORD [rbp - 0x10]
  add rsi, 1
  callproc move_cursor
  callproc puts, P(sl11)

  ; 4
  mov rdi, QWORD [rbp - 0x8]
  sub rdi, 9
  mov rsi, QWORD [rbp - 0x10]
  add rsi, 2
  callproc move_cursor
  callproc puts, P(sl12)

  ; 5
  mov rdi, QWORD [rbp - 0x8]
  sub rdi, 5
  mov rsi, QWORD [rbp - 0x10]
  add rsi, 3
  callproc move_cursor
  callproc puts, P(sl13)

  .unhighlight_previous_option:
    mov rdi, QWORD [rbp - 0x8]
    sub rdi, 12
    mov rsi, QWORD [rbp - 0x10]
    add rsi, QWORD [rbp - 0x20]
    inc rsi
    callproc move_cursor
    callproc putc, I(` `)
    callproc putc, I(` `)
    mov rdi, QWORD [rbp - 0x18]
    mov QWORD [rbp - 0x20], rdi

  .highlight_current_option:
    mov rdi, QWORD [rbp - 0x8]
    sub rdi, 12
    mov rsi, QWORD [rbp - 0x10]
    add rsi, QWORD [rbp - 0x18]
    inc rsi
    callproc move_cursor
    callproc puts, P(sl9)


  .handle_input:
    .while: ; rax == 0
      mov rax, SYS_READ
      mov rdi, STDIN
      mov rsi, rbp
      sub rsi, 0x28
      mov rdx, 1
      syscall
      test rax, rax
      jz .while
    
    mov rax, 0
    mov al, [rbp - 0x28]
    
    .if_enter:
      cmp al, 10
      jne .if_up
      .if_option_is_continue:
        cmp QWORD [rbp - 0x18], 0
        je .menu_end

      .if_option_is_exit:
        cmp QWORD [rbp - 0x18], 2
        je _exit

      .if_option_is_exit_to_main_menu:
        cmp QWORD [rbp - 0x18], 1
        callproc destroy_snake
        jmp _main.game_start

      jmp .handle_input
    
    .if_up:
      cmp al, `w`
      jne .if_down
      dec QWORD [rbp - 0x18]
      cmp QWORD [rbp - 0x18], 0
      jnl .unhighlight_previous_option
      inc QWORD [rbp - 0x18]

      jmp .unhighlight_previous_option

    .if_down:
      cmp al, `s`
      jne .handle_input
      inc QWORD [rbp - 0x18]
      cmp QWORD [rbp - 0x18], 2
      jng .unhighlight_previous_option
      dec QWORD [rbp - 0x18]

      jmp .unhighlight_previous_option

    jmp .handle_input

  .menu_end:

  mov rsp, rbp
  pop rbp
  ret

; enter_game_over_menu() -> void
_enter_game_over_menu:
  ; 1     GAME OVER
  ; 2   
  ; 3      Restart       = option 0
  ; 4 Exit to main menu  = option 1
  ; 5     Exit game      = option 2
  callproc clear_screen
  push rbp
  mov rbp, rsp
  ; rbp - 0x8  = fieldSize.x / 2
  ; rbp - 0x10 = fieldSize.y / 2
  ; rbp - 0x18 = current menu option
  ; rbp - 0x20 = previous menu option
  ; rbp - 0x28 = input read buffer

  mov rax, 0
  mov ax, WORD [fieldSize + coordinate_s.x]
  mov rdx, 0
  mov rdi, 2
  div rdi
  push rax

  mov ax, WORD [fieldSize + coordinate_s.y]
  mov rdx, 0
  div rdi
  push rax

  push 0
  push 0
  push 1488

  ; 1
  mov rdi, QWORD [rbp - 0x8]
  sub rdi, 5
  mov rsi, QWORD [rbp - 0x10]
  sub rsi, 1
  callproc move_cursor
  callproc puts, P(sl3)

  ; 3
  mov rdi, QWORD [rbp - 0x8]
  sub rdi, 4
  mov rsi, QWORD [rbp - 0x10]
  add rsi, 1
  callproc move_cursor
  callproc puts, P(sl14)

  ; 4
  mov rdi, QWORD [rbp - 0x8]
  sub rdi, 9
  mov rsi, QWORD [rbp - 0x10]
  add rsi, 2
  callproc move_cursor
  callproc puts, P(sl12)

  ; 5
  mov rdi, QWORD [rbp - 0x8]
  sub rdi, 5
  mov rsi, QWORD [rbp - 0x10]
  add rsi, 3
  callproc move_cursor
  callproc puts, P(sl13)

  .unhighlight_previous_option:
    mov rdi, QWORD [rbp - 0x8]
    sub rdi, 12
    mov rsi, QWORD [rbp - 0x10]
    add rsi, QWORD [rbp - 0x20]
    inc rsi
    callproc move_cursor
    callproc putc, I(` `)
    callproc putc, I(` `)
    mov rdi, QWORD [rbp - 0x18]
    mov QWORD [rbp - 0x20], rdi

  .highlight_current_option:
    mov rdi, QWORD [rbp - 0x8]
    sub rdi, 12
    mov rsi, QWORD [rbp - 0x10]
    add rsi, QWORD [rbp - 0x18]
    inc rsi
    callproc move_cursor
    callproc puts, P(sl9)


  .handle_input:
    .while: ; rax == 0
      mov rax, SYS_READ
      mov rdi, STDIN
      mov rsi, rbp
      sub rsi, 0x28
      mov rdx, 1
      syscall
      test rax, rax
      jz .while
    
    mov rax, 0
    mov al, [rbp - 0x28]
    
    .if_enter:
      cmp al, 10
      jne .if_up
      .if_option_is_restart:
        cmp QWORD [rbp - 0x18], 0
        je _main.game_restart

      .if_option_is_exit:
        cmp QWORD [rbp - 0x18], 2
        je _exit

      .if_option_is_exit_to_main_menu:
        cmp QWORD [rbp - 0x18], 1
        callproc destroy_snake
        jmp _main.game_start

      jmp .handle_input
    
    .if_up:
      cmp al, `w`
      jne .if_down
      dec QWORD [rbp - 0x18]
      cmp QWORD [rbp - 0x18], 0
      jnl .unhighlight_previous_option
      inc QWORD [rbp - 0x18]

      jmp .unhighlight_previous_option

    .if_down:
      cmp al, `s`
      jne .handle_input
      inc QWORD [rbp - 0x18]
      cmp QWORD [rbp - 0x18], 2
      jng .unhighlight_previous_option
      dec QWORD [rbp - 0x18]

      jmp .unhighlight_previous_option

    jmp .handle_input

  .menu_end:

  mov rsp, rbp
  pop rbp
  ret

; render_full_snake() -> void
_render_full_snake:
  push rax
  push rdi
  push rsi

  mov rax, QWORD [snake + snake_s.head]
  .while:
    cmp rax, 0
    je .endwhile
    mov rsi, 0
    mov si,  [rax + listnode_s.coords + coordinate_s.y]
    mov rdi, 0
    mov di,  [rax + listnode_s.coords + coordinate_s.x]
    callproc move_cursor
    callproc putc, I(SNAKE_BODY_CHAR)
    mov rax, [rax + listnode_s.next]
    jmp .while
  .endwhile:
  
  mov rax, QWORD [snake + snake_s.tail]
  mov rsi, 0
  mov si,  [rax + listnode_s.coords + coordinate_s.y]
  mov rdi, 0
  mov di,  [rax + listnode_s.coords + coordinate_s.x]
  callproc move_cursor
  callproc putc, I(SNAKE_HEAD_CHAR)
  

  pop rsi
  pop rdi
  pop rax

  ret


; rerender_game_frame() -> void
_rerender_game_frame:
  callproc clear_screen
  callproc render_score
  callproc render_fruit
  callproc render_full_snake
  
  ret

; destroy_snake() -> void
_destroy_snake:
  push rax
  push rdi
  push rsi
  push rdx

  mov rdi, QWORD [snake + snake_s.head]
  mov rsi, 12
  .while:
    cmp rdi, 0
    je .endwhile
    mov rdx, QWORD [rdi + listnode_s.next]
    callproc free
    mov rdi, rdx
    jmp .while
  .endwhile:

  pop rdx
  pop rsi
  pop rdi
  pop rax

  ret