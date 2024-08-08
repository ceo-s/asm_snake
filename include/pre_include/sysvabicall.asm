%ifndef SYSVABICALL_ASM
%define SYSVABICALL_ASM

%assign POINTER 0
%assign INTEGER 1
%assign FLOAT   2
%define P(x) 0::x
%define I(x) 1::x
%define F(x) 2::x

%define BASIC_ARG_1_REGISTER rdi
%define BASIC_ARG_2_REGISTER rsi
%define BASIC_ARG_3_REGISTER rdx
%define BASIC_ARG_4_REGISTER rcx
%define BASIC_ARG_5_REGISTER r8
%define BASIC_ARG_6_REGISTER r9
%define FLOAT_ARG_1_REGISTER xmm0
%define FLOAT_ARG_2_REGISTER xmm1
%define FLOAT_ARG_3_REGISTER xmm2
%define FLOAT_ARG_4_REGISTER xmm3
%define FLOAT_ARG_5_REGISTER xmm4
%define FLOAT_ARG_6_REGISTER xmm5
%define FLOAT_ARG_7_REGISTER xmm6
%define FLOAT_ARG_8_REGISTER xmm7

%macro callproc 1-9
  %define procaddr _%1
  %assign i 1
  %assign j 1
  %rep %0 - 1
    %rotate 1
    %assign type %tok(%substr(%str(%1),1,1))
    
    ; %warning %tok(%substr(%str(%1),2,2))
    %ifidn %tok(%substr(%str(%1),2,2)),::
    %else
      %error `\n\n!!!\nYou forgot to specify type, while passing parameters to 'callproc'\n!!!\n`
    %endif

    %if type = INTEGER || type = POINTER
      mov BASIC_ARG_%[i]_REGISTER, %tok(%substr(%str(%1),4))
      %assign i i+1
    %elif type = FLOAT
      mov FLOAT_ARG_%[j]_REGISTER, %tok(%substr(%str(%1),4))
      %assign j j+1
    %else
      %error `\n\n!!!\nDon't know how, but the type in 'callproc' is invalid\n!!!\n`
    %endif

  %endrep
  call procaddr
  %undef procaddr
%endmacro

%endif