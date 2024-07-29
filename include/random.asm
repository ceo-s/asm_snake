%ifndef RANDOM_ASM
%define RANDOM_ASM

; randint(int minIncluded, int maxIncluded) -> int
_randint:
  push rdx

  rdrand rax
  mov rdx, 0
  sub rsi, rdi
  inc rsi
  div rsi
  mov rax, rdx

  add rax, rdi
  pop rdx
  ret

%endif