%ifndef IO_ASM
%define IO_ASM
%include "string.asm"

section .data
  iosl0 db `Error opening file`,10,0
  iosl1 db `Error closing file`,10,0

section .text

; putc(char ch) -> void
_putc:
  push rax
  push rsi
  push rdx
  push rcx

  push rdi

  mov rax, SYS_WRITE
  mov rsi, rsp
  mov rdi, STDOUT
  mov rdx, 1
  syscall

  pop rdi

  pop rcx
  pop rdx
  pop rsi
  pop rax
  ret

; puts(char *string) -> void
_puts:
  push rax
  push rdi
  push rsi
  callproc strnlen, P(rdi), I(10000)
  mov rdx, rax
  mov rax, SYS_WRITE
  mov rsi, rdi
  mov rdi, STDOUT
  syscall
  pop rsi
  pop rdi
  pop rax
  ret

; print_integer(long val) -> void
_print_integer:
  push rbp
  mov rbp, rsp
  sub rsp, 24

  mov rax, rdi
  mov rsi, 10
  mov rcx, 1

  .while: ; rax != 0
    mov rdx, 0
    div rsi
    mov rbx, rbp
    sub rbx, rcx
    add rdx, '0'
    mov BYTE [rbx], dl
    inc rcx

    test rax, rax
    jnz .while


  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, rbx
  mov rdx, rcx
  dec rdx
  syscall

  mov rsp, rbp
  pop rbp
  ret

; open(char *path, int mode) -> int
_open:
  push rdx
  mov rax, SYS_OPEN
  mov rdx, 0644o
  syscall
  pop rdx

  cmp rax, 0
  jge .endproc
  callproc puts, P(iosl0)
  mov rax, SYS_EXIT
  mov rdi, 1
  syscall

  .endproc:
  ret

; close(int fd) -> void
_close:
  mov rax, SYS_CLOSE
  syscall
  cmp rax, 0
  jge .endproc
  callproc puts, P(iosl1)
  mov rax, SYS_EXIT
  mov rdi, 1
  syscall

  .endproc:
  ret

%endif