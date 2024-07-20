%ifndef ESC_CONTROL
%define ESC_CONTROL
%include "io.asm"
%include "string.asm"

section .bss
  mv_buf        resb 80
  mv_ints_buf   resb 24

section .data
  mv_cursor_begin    db `\033[`,0
  mv_cursor_delimetr db 59
  mv_cursor_end      db `H`

  clr_screen         db ANSI_CLEAR_SCREEN

section .text

; move_cursor(int x, int y)
_move_cursor:
  push rbp
  mov rbp, rsp
  push rax
  push rdx
  push rdi
  push rsi
  mov rdx, mv_buf

  callproc memcpy, P(rdx), P(mv_cursor_begin), I(2)

  add rdx, 2
  callproc int_to_str, I([rsp + 0x10]), P(mv_ints_buf)
  callproc memcpy, P(rdx), P(mv_ints_buf), I(rax)
  add rdx, rax
  mov al, BYTE [mv_cursor_delimetr]
  mov BYTE [rdx], al
  inc rdx
  callproc int_to_str, I([rsp + 0x8]), P(mv_ints_buf)
  callproc memcpy, P(rdx), P(mv_ints_buf), I(rax)
  add rdx, rax
  mov al, BYTE [mv_cursor_end]
  mov BYTE [rdx], al
  inc rdx
  mov BYTE [rdx], 0

  pop rsi
  pop rdi
  pop rdx
  pop rax
  mov rsp, rbp
  pop rbp
  ret

; clear_screen
_clear_screen:
  callproc puts, P(clr_screen)
  ret

%endif