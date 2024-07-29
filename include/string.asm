%ifndef STRING_ASM
%define STRING_ASM

section .text

; strnlen(char *string, long size) -> long
_strnlen:
  push rcx
  mov rcx, 0
  mov rax, 0

  .while: ; rcx < size || char[rcx] != 0
    inc rcx
    cmp rcx, rsi
    je .endwhile

    mov al, BYTE [rdi + rcx - 1]
    cmp al, 0
    jne .while

  .endwhile:
  mov rax, rcx
  pop rcx
  ret

; int_to_str(long val, char *buf) -> long
; returns length of new string
_int_to_str:
  push rbp
  push rdx
  push rcx
  push rbx
  mov rbp, rsp
  sub rsp, 0x18
  
  mov rax, rdi
  mov rdi, rsi
  mov rsi, 10
  mov rcx, 0

  .while: ; rax != 0
    mov rdx, 0
    div rsi
    add rdx, '0'
    mov rbx, rbp
    sub rbx, rcx
    mov BYTE [rbx], dl
    inc rcx

    test rax, rax
    jnz .while

  push rdi
  push rsi
  callproc memcpy, P(rdi), P(rbx), I(rcx)
  pop rsi
  pop rdi
  mov BYTE [rdi + rcx], 0

  mov rax, rcx

  add rsp, 0x18
  mov rsp, rbp
  pop rbx
  pop rcx
  pop rdx
  pop rbp
  ret
  
; memcpy(char *dst, char *src, long nChars) -> void
_memcpy:
  push rax
  push rcx
  mov rax, 0
  mov rcx, rdx

  .while: ; rcx >= 0
    dec rcx
    mov al, BYTE [rsi + rcx]
    mov BYTE [rdi + rcx], al
    test rcx, rcx
    jnz .while
  
  pop rcx
  pop rax
  ret

%endif