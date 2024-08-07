%ifndef RANDOM_ASM
%define RANDOM_ASM

section .data
  nextRand       dq 1
  randMultiplier dq 1103515245
  randAddendum   dq 12345

section .text

; randint(int minIncluded, int maxExcluded) -> int
_randint:
  push rdx
  push rbx

  callproc rand
  mov rbx, rsi
  sub rbx, rdi
  
  mov rdx, 0
  div rbx
  add rdx, rdi
  mov rax, rdx

  pop rbx
  pop rdx

  ret

%endif

; rand() -> long
_rand:
  mov rax, QWORD [nextRand]
  mul QWORD [randMultiplier]
  add rax, randAddendum
  mov QWORD [nextRand], rax
  ret

; srand(long seed) -> void
_srand:
  mov QWORD [nextRand], rdi
  ret

; set_time_based_srand() -> void
_set_time_based_srand:
  push rax
  push rdi

  mov rax, SYS_TIME
  mov rdi, 0
  syscall

  callproc srand, I(rax)

  pop rdi
  pop rax
  ret