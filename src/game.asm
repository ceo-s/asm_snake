%include "io.asm"
%include "ansicodes.asm"
%include "sleep.asm"
%include "esccontrol.asm"

%define DIRECTION_LEFT 1
%define DIRECTION_UP 2
%define DIRECTION_RIGHT 3
%define DIRECTION_DOWN 4


%define TIOCGWINSZ 0x5413
%define TIOCSWINSZ 0x5414

struc winsize
  .height: resw 1
  .width:  resw 1
endstruc

section .data
  ; ANSI strings
  red_color db ANSI_TEXT_COLOR_GREEN
  no_color  db ANSI_TEXT_COLOR_NORMAL

  ; String literals
  greetings db `SNAKE GAME!!!\n`,0
  toLineStart db `\r`,0
  toNewLine   db `\n`,0
  theHeightIs db `The height is: `,0
  theWidthIs  db `The width is: ` ,0

  ; Intro
  countdown dd 3
  countdownTimespec dq 1,0

  ; Field
  field:
    istruc winsize
      at winsize.height, dw 20
      at winsize.width,  dw 70
    iend

  ; Gameplay
  snakeSize dw 1
  currentDirection db 3

  ; Outro

section .text
  global _start

_start:
  callproc main
  mov rdi, rax
  mov rax, SYS_EXIT
  syscall


; main() -> long
_main:
  push rbp
  mov rbp, rsp

  callproc init_winsize
  callproc clear_screen
  mov rbx, field
  mov rdi, 0
  mov di, WORD [rbx + winsize.width]
  sub rdi, 10
  mov rsi, 0
  mov si, WORD [rbx + winsize.height]
  sub rsi, 10
  callproc move_cursor


  callproc puts, P(red_color)
  callproc puts, P(greetings)
  callproc puts, P(no_color)

  mov rcx, 3
  push QWORD rcx
  
  .countdown_loop:
    callproc print_integer, I([rbp - 8])
    callproc puts, P(toLineStart)
    callproc sleep, P(countdownTimespec)
    mov rcx, [rbp - 8]
    dec rcx
    mov [rbp - 8], rcx
    test rcx, rcx
    jnz .countdown_loop

  pop rcx



  mov rax, 0

  mov rsp, rbp
  pop rbp
  ret

; init_winsize()
_init_winsize:
  mov rax, SYS_IOCTL
  mov rdi, STDOUT
  mov rsi, TIOCGWINSZ
  mov rdx, field
  syscall
  ret