%macro stdcall 1-*
  %define procaddr _%1

  %rep %0 - 1
    %rotate 1
    push %1
  %endrep

  %undef procaddr
%endmacro