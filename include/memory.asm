%ifndef MEMORY_ASM
%define MEMORY_ASM

; alloc(long size) -> void *
; return pointer to allocated memmory on success and -1 on failure
_alloc:
  push rsi
  push rdx

  mov rax, SYS_MMAP
  mov rsi, rdi
  mov rdi, NULL
  mov rdx, 3
  mov r10, 2 | 0x20
  mov r8, -1
  mov r9, 0
  syscall

  pop rdx
  pop rsi

  ret

; free(void *ptr, long size) -> int
; return 0 on success and -1 on failure
_free:
  mov rax, SYS_MUNMAP
  syscall

  ret

%endif