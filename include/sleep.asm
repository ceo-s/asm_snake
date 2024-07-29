%ifndef SLEEP
%define SLEEP

%define SECONDS_TO_NANOSEC(x) x %+ 000000000
%define MILISEC_TO_NANOSEC(x) x %+ 000000

section .text

; sleep(struct timespec *delay) -> void
_sleep:
  push rax
  push rsi

  mov rax, SYS_NANOSLEEP
  mov rsi, 0
  syscall

  pop rsi
  pop rax
  ret

%endif