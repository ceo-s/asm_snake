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

; clear_screen
_clear_screen:
  callproc puts, P(clr_screen)
  ret

%endif