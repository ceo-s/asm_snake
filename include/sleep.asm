%ifndef SLEEP
%define SLEEP

%define SECONDS_TO_NANOSEC(x) x000000000
%define MILISEC_TO_NANOSEC(x) x000000

section .text

; sleep(struct timespec *delay) -> void
_sleep:
  mov rax, SYS_NANOSLEEP
  mov rsi, 0
  syscall
  ret

%endif