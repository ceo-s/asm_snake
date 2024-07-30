%ifndef TERM_CONTROL
%define TERM_CONTROL
%include "io.asm"
%include "string.asm"
%include "ansicodes.asm"
%include "termbits.asm"

TERMIOS_STRUCT_SIZE           equ 60
TERMIOS_STRUCT_C_IFLAG_OFFSET equ 0x0
TERMIOS_STRUCT_C_OFLAG_OFFSET equ 0x4
TERMIOS_STRUCT_C_CFLAG_OFFSET equ 0x8
TERMIOS_STRUCT_C_LFLAG_OFFSET equ 0xc
TERMIOS_STRUCT_C_CC_OFFSET    equ 0x11

section .bss
  mv_buf        resb 80
  mv_ints_buf   resb 24

  initial_termios_struct resb TERMIOS_STRUCT_SIZE
  current_termios_struct resb TERMIOS_STRUCT_SIZE

section .data
  mv_cursor_begin    db `\033[`,0
  mv_cursor_delimetr db 59
  mv_cursor_end      db `H`

  hide_cursor        db ANSI_HIDE_CURSOR,0
  show_cursor        db ANSI_SHOW_CURSOR,0

  clr_screen         db ANSI_CLEAR_SCREEN,0

section .text

; move_cursor(int x, int y) -> void
_move_cursor:
  push rbp
  push rax
  push rcx
  push rdx
  mov rbp, rsp
  push rdi
  push rsi
  mov rcx, mv_buf

  callproc memcpy, P(rcx), P(mv_cursor_begin), I(2)

  add rcx, 2
  callproc int_to_str, I([rbp - 0x10]), P(mv_ints_buf)
  callproc memcpy, P(rcx), P(mv_ints_buf), I(rax)
  add rcx, rax
  mov al, BYTE [mv_cursor_delimetr]
  mov BYTE [rcx], al
  inc rcx
  callproc int_to_str, I([rbp - 0x8]), P(mv_ints_buf)
  callproc memcpy, P(rcx), P(mv_ints_buf), I(rax)
  add rcx, rax
  mov al, BYTE [mv_cursor_end]
  mov BYTE [rcx], al
  inc rcx
  mov BYTE [rcx], 0

  callproc puts, P(mv_buf)
  
  sub rsp, 0x10
  mov rsp, rbp
  pop rdx
  pop rcx
  pop rax
  pop rbp
  ret

; hide_cursor() -> void
_hide_cursor:
  push rdi
  callproc puts, P(hide_cursor)
  pop rdi
  ret

; show_cursor() -> void
_show_cursor:
  push rdi
  callproc puts, P(show_cursor)
  pop rdi
  ret

; clear_screen() -> void
_clear_screen:
  push rdi
  callproc puts, P(clr_screen)
  pop rdi
  ret

; init_termios() ->void
_init_termios:
  push rax
  push rdi
  push rsi
  push rdx

  mov rax, SYS_IOCTL
  mov rdi, STDIN
  mov rsi, TCGETS
  mov rdx, initial_termios_struct
  syscall

  callproc memcpy, P(current_termios_struct), P(initial_termios_struct), I(TERMIOS_STRUCT_SIZE)

  pop rdx
  pop rsi
  pop rdi
  pop rax

  ret

; enable_raw_mode() -> void
_enable_raw_mode:
  push rax
  push rdi
  push rsi
  push rdx

  mov eax, DWORD [current_termios_struct + TERMIOS_STRUCT_C_LFLAG_OFFSET]
  mov rdi, ECHO | ICANON
  not rdi
  and eax, edi
  mov DWORD [current_termios_struct + TERMIOS_STRUCT_C_LFLAG_OFFSET], eax

  mov BYTE [current_termios_struct + TERMIOS_STRUCT_C_CC_OFFSET + VMIN], 0
  mov BYTE [current_termios_struct + TERMIOS_STRUCT_C_CC_OFFSET + VTIME], 0

  mov rax, SYS_IOCTL
  mov rdi, STDIN
  mov rsi, TCSETSF
  mov rdx, current_termios_struct
  syscall

  pop rdx
  pop rsi
  pop rdi
  pop rax

  ret

; disable_raw_mode() -> void
_disable_raw_mode:
  push rax
  push rdi
  push rsi
  push rdx

  mov rax, SYS_IOCTL
  mov rdi, STDIN
  mov rsi, TCSETSF
  mov rdx, initial_termios_struct
  syscall

  pop rdx
  pop rsi
  pop rdi
  pop rax

  ret


%endif