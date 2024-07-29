%line 0+1 src/game.asm
NULL equ 0
%line 0+0 src/game.asm

STDIN_FILENO equ 0
STDOUT_FILENO equ 1
STDERR_FILENO equ 2

STDIN equ 0
STDOUT equ 1
STDERR equ 2

O_RDONLY equ 0
O_WRONLY equ 1
O_RDWR equ 2

O_CREAT equ 64
O_EXCL equ 128
O_NOCTTY equ 256
O_TRUNC equ 512
O_APPEND equ 1024
O_NONBLOCK equ 2048
O_NDELAY equ 2048
O_DSYNC equ 4096
O_ASYNC equ 8192
O_DIRECT equ 16384
O_DIRECTORY equ 65536
O_NOFOLLOW equ 131072
O_NOATIME equ 262144
O_CLOEXEC equ 524288
O_SYNC equ 1052672
O_PATH equ 2097152
O_TMPFILE equ 4259840

O_LARGEFILE equ 0

SYS_READ equ 0
SYS_WRITE equ 1
SYS_OPEN equ 2
SYS_CLOSE equ 3
SYS_STAT equ 4
SYS_FSTAT equ 5
SYS_LSTAT equ 6
SYS_POLL equ 7
SYS_LSEEK equ 8
SYS_MMAP equ 9
SYS_MPROTECT equ 10
SYS_MUNMAP equ 11
SYS_BRK equ 12
SYS_RT_SIGACTION equ 13
SYS_RT_SIGPROCMASK equ 14
SYS_RT_SIGRETURN equ 15
SYS_IOCTL equ 16
SYS_PREAD64 equ 17
SYS_PWRITE64 equ 18
SYS_READV equ 19
SYS_WRITEV equ 20
SYS_ACCESS equ 21
SYS_PIPE equ 22
SYS_SELECT equ 23
SYS_SCHED_YIELD equ 24
SYS_MREMAP equ 25
SYS_MSYNC equ 26
SYS_MINCORE equ 27
SYS_MADVISE equ 28
SYS_SHMGET equ 29
SYS_SHMAT equ 30
SYS_SHMCTL equ 31
SYS_DUP equ 32
SYS_DUP2 equ 33
SYS_PAUSE equ 34
SYS_NANOSLEEP equ 35
SYS_GETITIMER equ 36
SYS_ALARM equ 37
SYS_SETITIMER equ 38
SYS_GETPID equ 39
SYS_SENDFILE equ 40
SYS_SOCKET equ 41
SYS_CONNECT equ 42
SYS_ACCEPT equ 43
SYS_SENDTO equ 44
SYS_RECVFROM equ 45
SYS_SENDMSG equ 46
SYS_RECVMSG equ 47
SYS_SHUTDOWN equ 48
SYS_BIND equ 49
SYS_LISTEN equ 50
SYS_GETSOCKNAME equ 51
SYS_GETPEERNAME equ 52
SYS_SOCKETPAIR equ 53
SYS_SETSOCKOPT equ 54
SYS_GETSOCKOPT equ 55
SYS_CLONE equ 56
SYS_FORK equ 57
SYS_VFORK equ 58
SYS_EXECVE equ 59
SYS_EXIT equ 60
SYS_WAIT4 equ 61
SYS_KILL equ 62
SYS_UNAME equ 63
SYS_SEMGET equ 64
SYS_SEMOP equ 65
SYS_SEMCTL equ 66
SYS_SHMDT equ 67
SYS_MSGGET equ 68
SYS_MSGSND equ 69
SYS_MSGRCV equ 70
SYS_MSGCTL equ 71
SYS_FCNTL equ 72
SYS_FLOCK equ 73
SYS_FSYNC equ 74
SYS_FDATASYNC equ 75
SYS_TRUNCATE equ 76
SYS_FTRUNCATE equ 77
SYS_GETDENTS equ 78
SYS_GETCWD equ 79
SYS_CHDIR equ 80
SYS_FCHDIR equ 81
SYS_RENAME equ 82
SYS_MKDIR equ 83
SYS_RMDIR equ 84
SYS_CREAT equ 85
SYS_LINK equ 86
SYS_UNLINK equ 87
SYS_SYMLINK equ 88
SYS_READLINK equ 89
SYS_CHMOD equ 90
SYS_FCHMOD equ 91
SYS_CHOWN equ 92
SYS_FCHOWN equ 93
SYS_LCHOWN equ 94
SYS_UMASK equ 95
SYS_GETTIMEOFDAY equ 96
SYS_GETRLIMIT equ 97
SYS_GETRUSAGE equ 98
SYS_SYSINFO equ 99
SYS_TIMES equ 100
SYS_PTRACE equ 101
SYS_GETUID equ 102
SYS_SYSLOG equ 103
SYS_GETGID equ 104
SYS_SETUID equ 105
SYS_SETGID equ 106
SYS_GETEUID equ 107
SYS_GETEGID equ 108
SYS_SETPGID equ 109
SYS_GETPPID equ 110
SYS_GETPGRP equ 111
SYS_SETSID equ 112
SYS_SETREUID equ 113
SYS_SETREGID equ 114
SYS_GETGROUPS equ 115
SYS_SETGROUPS equ 116
SYS_SETRESUID equ 117
SYS_GETRESUID equ 118
SYS_SETRESGID equ 119
SYS_GETRESGID equ 120
SYS_GETPGID equ 121
SYS_SETFSUID equ 122
SYS_SETFSGID equ 123
SYS_GETSID equ 124
SYS_CAPGET equ 125
SYS_CAPSET equ 126
SYS_RT_SIGPENDING equ 127
SYS_RT_SIGTIMEDWAIT equ 128
SYS_RT_SIGQUEUEINFO equ 129
SYS_RT_SIGSUSPEND equ 130
SYS_SIGALTSTACK equ 131
SYS_UTIME equ 132
SYS_MKNOD equ 133
SYS_USELIB equ 134
SYS_PERSONALITY equ 135
SYS_USTAT equ 136
SYS_STATFS equ 137
SYS_FSTATFS equ 138
SYS_SYSFS equ 139
SYS_GETPRIORITY equ 140
SYS_SETPRIORITY equ 141
SYS_SCHED_SETPARAM equ 142
SYS_SCHED_GETPARAM equ 143
SYS_SCHED_SETSCHEDULER equ 144
SYS_SCHED_GETSCHEDULER equ 145
SYS_SCHED_GET_PRIORITY_MAX equ 146
SYS_SCHED_GET_PRIORITY_MIN equ 147
SYS_SCHED_RR_GET_INTERVAL equ 148
SYS_MLOCK equ 149
SYS_MUNLOCK equ 150
SYS_MLOCKALL equ 151
SYS_MUNLOCKALL equ 152
SYS_VHANGUP equ 153
SYS_MODIFY_LDT equ 154
SYS_PIVOT_ROOT equ 155
SYS__SYSCTL equ 156
SYS_PRCTL equ 157
SYS_ARCH_PRCTL equ 158
SYS_ADJTIMEX equ 159
SYS_SETRLIMIT equ 160
SYS_CHROOT equ 161
SYS_SYNC equ 162
SYS_ACCT equ 163
SYS_SETTIMEOFDAY equ 164
SYS_MOUNT equ 165
SYS_UMOUNT2 equ 166
SYS_SWAPON equ 167
SYS_SWAPOFF equ 168
SYS_REBOOT equ 169
SYS_SETHOSTNAME equ 170
SYS_SETDOMAINNAME equ 171
SYS_IOPL equ 172
SYS_IOPERM equ 173
SYS_CREATE_MODULE equ 174
SYS_INIT_MODULE equ 175
SYS_DELETE_MODULE equ 176
SYS_GET_KERNEL_SYMS equ 177
SYS_QUERY_MODULE equ 178
SYS_QUOTACTL equ 179
SYS_NFSSERVCTL equ 180
SYS_GETPMSG equ 181
SYS_PUTPMSG equ 182
SYS_AFS_SYSCALL equ 183
SYS_TUXCALL equ 184
SYS_SECURITY equ 185
SYS_GETTID equ 186
SYS_READAHEAD equ 187
SYS_SETXATTR equ 188
SYS_LSETXATTR equ 189
SYS_FSETXATTR equ 190
SYS_GETXATTR equ 191
SYS_LGETXATTR equ 192
SYS_FGETXATTR equ 193
SYS_LISTXATTR equ 194
SYS_LLISTXATTR equ 195
SYS_FLISTXATTR equ 196
SYS_REMOVEXATTR equ 197
SYS_LREMOVEXATTR equ 198
SYS_FREMOVEXATTR equ 199
SYS_TKILL equ 200
SYS_TIME equ 201
SYS_FUTEX equ 202
SYS_SCHED_SETAFFINITY equ 203
SYS_SCHED_GETAFFINITY equ 204
SYS_SET_THREAD_AREA equ 205
SYS_IO_SETUP equ 206
SYS_IO_DESTROY equ 207
SYS_IO_GETEVENTS equ 208
SYS_IO_SUBMIT equ 209
SYS_IO_CANCEL equ 210
SYS_GET_THREAD_AREA equ 211
SYS_LOOKUP_DCOOKIE equ 212
SYS_EPOLL_CREATE equ 213
SYS_EPOLL_CTL_OLD equ 214
SYS_EPOLL_WAIT_OLD equ 215
SYS_REMAP_FILE_PAGES equ 216
SYS_GETDENTS64 equ 217
SYS_SET_TID_ADDRESS equ 218
SYS_RESTART_SYSCALL equ 219
SYS_SEMTIMEDOP equ 220
SYS_FADVISE64 equ 221
SYS_TIMER_CREATE equ 222
SYS_TIMER_SETTIME equ 223
SYS_TIMER_GETTIME equ 224
SYS_TIMER_GETOVERRUN equ 225
SYS_TIMER_DELETE equ 226
SYS_CLOCK_SETTIME equ 227
SYS_CLOCK_GETTIME equ 228
SYS_CLOCK_GETRES equ 229
SYS_CLOCK_NANOSLEEP equ 230
SYS_EXIT_GROUP equ 231
SYS_EPOLL_WAIT equ 232
SYS_EPOLL_CTL equ 233
SYS_TGKILL equ 234
SYS_UTIMES equ 235
SYS_VSERVER equ 236
SYS_MBIND equ 237
SYS_SET_MEMPOLICY equ 238
SYS_GET_MEMPOLICY equ 239
SYS_MQ_OPEN equ 240
SYS_MQ_UNLINK equ 241
SYS_MQ_TIMEDSEND equ 242
SYS_MQ_TIMEDRECEIVE equ 243
SYS_MQ_NOTIFY equ 244
SYS_MQ_GETSETATTR equ 245
SYS_KEXEC_LOAD equ 246
SYS_WAITID equ 247
SYS_ADD_KEY equ 248
SYS_REQUEST_KEY equ 249
SYS_KEYCTL equ 250
SYS_IOPRIO_SET equ 251
SYS_IOPRIO_GET equ 252
SYS_INOTIFY_INIT equ 253
SYS_INOTIFY_ADD_WATCH equ 254
SYS_INOTIFY_RM_WATCH equ 255
SYS_MIGRATE_PAGES equ 256
SYS_OPENAT equ 257
SYS_MKDIRAT equ 258
SYS_MKNODAT equ 259
SYS_FCHOWNAT equ 260
SYS_FUTIMESAT equ 261
SYS_NEWFSTATAT equ 262
SYS_UNLINKAT equ 263
SYS_RENAMEAT equ 264
SYS_LINKAT equ 265
SYS_SYMLINKAT equ 266
SYS_READLINKAT equ 267
SYS_FCHMODAT equ 268
SYS_FACCESSAT equ 269
SYS_PSELECT6 equ 270
SYS_PPOLL equ 271
SYS_UNSHARE equ 272
SYS_SET_ROBUST_LIST equ 273
SYS_GET_ROBUST_LIST equ 274
SYS_SPLICE equ 275
SYS_TEE equ 276
SYS_SYNC_FILE_RANGE equ 277
SYS_VMSPLICE equ 278
SYS_MOVE_PAGES equ 279
SYS_UTIMENSAT equ 280
SYS_EPOLL_PWAIT equ 281
SYS_SIGNALFD equ 282
SYS_TIMERFD_CREATE equ 283
SYS_EVENTFD equ 284
SYS_FALLOCATE equ 285
SYS_TIMERFD_SETTIME equ 286
SYS_TIMERFD_GETTIME equ 287
SYS_ACCEPT4 equ 288
SYS_SIGNALFD4 equ 289
SYS_EVENTFD2 equ 290
SYS_EPOLL_CREATE1 equ 291
SYS_DUP3 equ 292
SYS_PIPE2 equ 293
SYS_INOTIFY_INIT1 equ 294
SYS_PREADV equ 295
SYS_PWRITEV equ 296
SYS_RT_TGSIGQUEUEINFO equ 297
SYS_PERF_EVENT_OPEN equ 298
SYS_RECVMMSG equ 299
SYS_FANOTIFY_INIT equ 300
SYS_FANOTIFY_MARK equ 301
SYS_PRLIMIT64 equ 302
SYS_NAME_TO_HANDLE_AT equ 303
SYS_OPEN_BY_HANDLE_AT equ 304
SYS_CLOCK_ADJTIME equ 305
SYS_SYNCFS equ 306
SYS_SENDMMSG equ 307
SYS_SETNS equ 308
SYS_GETCPU equ 309
SYS_PROCESS_VM_READV equ 310
SYS_PROCESS_VM_WRITEV equ 311
SYS_KCMP equ 312
SYS_FINIT_MODULE equ 313
SYS_SCHED_SETATTR equ 314
SYS_SCHED_GETATTR equ 315
SYS_RENAMEAT2 equ 316
SYS_SECCOMP equ 317
SYS_GETRANDOM equ 318
SYS_MEMFD_CREATE equ 319
SYS_KEXEC_FILE_LOAD equ 320
SYS_BPF equ 321
STUB_EXECVEAT equ 322
USERFAULTFD equ 323
MEMBARRIER equ 324
MLOCK2 equ 325
COPY_FILE_RANGE equ 326
PREADV2 equ 327
PWRITEV2 equ 328


%line 4+1 ./include/string.asm
[section .text]


_strnlen:
 push rcx
 mov rcx, 0
 mov rax, 0

 .while:
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

 .while:
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


%line 0+0 ""
 mov rdi, rdi




 mov rsi, rbx




 mov rdx, rcx

 call _memcpy
%line 56+1 ./include/string.asm
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


_memcpy:
 push rax
 push rcx
 mov rax, 0
 mov rcx, rdx

 .while:
 dec rcx
 mov al, BYTE [rsi + rcx]
 mov BYTE [rdi + rcx], al
 test rcx, rcx
 jnz .while

 pop rcx
 pop rax
 ret

%line 5+1 ./include/io.asm
[section .text]


_putc:
 push rsi
 push rdi
 mov rax, SYS_WRITE
 mov rsi, rsp
 mov rdi, STDOUT
 mov rdx, 1
 syscall
 pop rdi
 pop rsi
 ret


_puts:
 push rax
 push rsi


%line 0+0 ""
 mov rdi, rdi




 mov rsi, 10000

 call _strnlen
%line 25+1 ./include/io.asm
 mov rdx, rax
 mov rax, SYS_WRITE
 mov rsi, rdi
 mov rdi, STDOUT
 syscall
 pop rsi
 pop rax
 ret


_print_integer:
 push rbp
 mov rbp, rsp
 sub rsp, 24

 mov rax, rdi
 mov rsi, 10
 mov rcx, 1

 .while:
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

%line 7+1 ./include/sleep.asm
[section .text]


_sleep:
 push rax
 push rsi

 mov rax, SYS_NANOSLEEP
 mov rsi, 0
 syscall

 pop rsi
 pop rax
 ret

%line 6+1 ./include/esccontrol.asm
[section .bss]
 mv_buf resb 80
 mv_ints_buf resb 24

[section .data]
 mv_cursor_begin db `\033[`,0
 mv_cursor_delimetr db 59
 mv_cursor_end db `H`

 clr_screen db `\x1B[2J`

[section .text]


_move_cursor:
 push rbp
 push rax
 push rcx
 mov rbp, rsp
 push rdi
 push rsi
 mov rcx, mv_buf



%line 0+0 ""
 mov rdi, rcx




 mov rsi, mv_cursor_begin




 mov rdx, 2

 call _memcpy
%line 31+1 ./include/esccontrol.asm
 add rcx, 2


%line 0+0 ""
 mov rdi, [rbp - 0x10]




 mov rsi, mv_ints_buf

 call _int_to_str



 mov rdi, rcx




 mov rsi, mv_ints_buf




 mov rdx, rax

 call _memcpy
%line 34+1 ./include/esccontrol.asm
 add rcx, rax
 mov al, BYTE [mv_cursor_delimetr]
 mov BYTE [rcx], al
 inc rcx


%line 0+0 ""
 mov rdi, [rbp - 0x8]




 mov rsi, mv_ints_buf

 call _int_to_str



 mov rdi, rcx




 mov rsi, mv_ints_buf




 mov rdx, rax

 call _memcpy
%line 40+1 ./include/esccontrol.asm
 add rcx, rax
 mov al, BYTE [mv_cursor_end]
 mov BYTE [rcx], al
 inc rcx
 mov BYTE [rcx], 0



%line 0+0 ""
 mov rdi, mv_buf

 call _puts
%line 48+1 ./include/esccontrol.asm
 sub rsp, 0x10
 mov rsp, rbp
 pop rcx
 pop rax
 pop rbp
 ret


_clear_screen:


%line 0+0 ""
 mov rdi, clr_screen

 call _puts
%line 58+1 ./include/esccontrol.asm
 ret

%line 6+1 ./include/memory.asm
_alloc:
 push rsi
 push rdx

 mov rax, SYS_MMAP
 mov rsi, rdi
 mov rdi, NULL
 mov rdx, 3
 mov r10, 0x20
 mov r8, 0
 mov r9, 0
 syscall

 pop rdx
 pop rsi

 ret



_free:
 mov rax, SYS_MUNMAP
 syscall

 ret

%line 7+1 src/game.asm
DIRECTION_LEFT equ 0x0000ffff
DIRECTION_UP equ 0xffff0000
DIRECTION_RIGHT equ 0x00000001
DIRECTION_DOWN equ 0x00010000

SNAKE_HEAD_CHAR equ 79
SNAKE_BODY_CHAR equ 111
FRUIT_BASE_CHAR equ 64

%line 18+1 src/game.asm

[absolute 0]
%line 19+0 src/game.asm
coordinate_s:
%line 20+1 src/game.asm
 .y: resw 1
 .x: resw 1
coordinate_s_size equ ($-coordinate_s)
%line 22+0 src/game.asm
[section .text]
%line 23+1 src/game.asm

[absolute 0]
%line 24+0 src/game.asm
listnode_s:
%line 25+1 src/game.asm
 .coords: resw 2
 .next: resq 1
listnode_s_size equ ($-listnode_s)
%line 27+0 src/game.asm
[section .text]
%line 28+1 src/game.asm

[absolute 0]
%line 29+0 src/game.asm
snake_s:
%line 30+1 src/game.asm
 .head: resq 1
 .tail: resq 1
 .size: resd 1
 .direction: resd 1
snake_s_size equ ($-snake_s)
%line 34+0 src/game.asm
[section .text]
%line 35+1 src/game.asm

[section .data]

 greenColor db `\x1B[0;32m`,0
 noColor db `\x1B[0m`,0


 sl1 db `SNAKE GAME!\n`,0
 sl2 db `Allocating listnode failed! Exiting!\n`,0
 sl3 db `GAME OVER!\nPress :ESC: to quit.\nPress :ENTER: to restart.\n`,0

 countdownTimespec dq 1,0


 fieldSize:
..@26.strucstart:
times (coordinate_s.y-coordinate_s)-($-..@26.strucstart) db 0
%line 51+0 src/game.asm
dw 20
%line 52+1 src/game.asm
times (coordinate_s.x-coordinate_s)-($-..@26.strucstart) db 0
%line 52+0 src/game.asm
dw 70
%line 53+1 src/game.asm
times coordinate_s_size-($-..@26.strucstart) db 0


 snake:
..@31.strucstart:
times (snake_s.head-snake_s)-($-..@31.strucstart) db 0
%line 58+0 src/game.asm
dq 0
%line 59+1 src/game.asm
times (snake_s.tail-snake_s)-($-..@31.strucstart) db 0
%line 59+0 src/game.asm
dq 0
%line 60+1 src/game.asm
times (snake_s.size-snake_s)-($-..@31.strucstart) db 0
%line 60+0 src/game.asm
dd 0
%line 61+1 src/game.asm
times (snake_s.direction-snake_s)-($-..@31.strucstart) db 0
%line 61+0 src/game.asm
dd 0
%line 62+1 src/game.asm
times snake_s_size-($-..@31.strucstart) db 0

 fruitCoords:
..@38.strucstart:
times (coordinate_s.y-coordinate_s)-($-..@38.strucstart) db 0
%line 66+0 src/game.asm
dw 0
%line 67+1 src/game.asm
times (coordinate_s.x-coordinate_s)-($-..@38.strucstart) db 0
%line 67+0 src/game.asm
dw 0
%line 68+1 src/game.asm
times coordinate_s_size-($-..@38.strucstart) db 0

 gameIsOver dq 0
 gameSpeedTimespec dq 0, 500000000


[section .text]
[global _start]

_start:
%line 0+0 ""
 call _main



 mov rdi, rax

 call _exit
%line 82+1 src/game.asm
_exit:
 mov rax, SYS_EXIT
 syscall



_main:
 push rbp
 mov rbp, rsp

%line 0+0 ""
 call _init_winsize
 call _greet
 call _init_snake
 call _start_game
%line 97+1 src/game.asm
 mov rax, 0

 mov rsp, rbp
 pop rbp
 ret


_init_winsize:
 mov rax, SYS_IOCTL
 mov rdi, STDOUT
 mov rsi, 0x5413
 mov rdx, fieldSize
 syscall
 ret


_greet:
 push rbp
 mov rbp, rsp

%line 0+0 ""
 call _clear_screen
%line 118+1 src/game.asm
 mov rbx, fieldSize
 sub rsp, 0x18

 mov rax, 0
 mov ax, WORD [rbx + coordinate_s.x]
 mov rdx, 0
 mov rcx, 2
 div rcx
 mov [rbp - 0x8], rax
 mov rdi, rax
 sub rdi, 6

 mov rax, 0
 mov ax, WORD [rbx + coordinate_s.y]
 mov rdx, 0
 div rcx
 mov [rbp - 0x10], rax
 mov rsi, rax
%line 0+0 ""
 call _move_cursor


%line 0+0 ""
 mov rdi, greenColor

 call _puts



 mov rdi, sl1

 call _puts



 mov rdi, noColor

 call _puts
%line 143+1 src/game.asm
 mov rdi, [rbp - 0x8]
 sub rdi, 1
 mov rsi, [rbp - 0x10]
 inc rsi
%line 0+0 ""
 call _move_cursor
%line 149+1 src/game.asm
 mov QWORD [rbp - 0x18], 3

 .countdown_loop:


%line 0+0 ""
 mov rdi, [rbp - 0x18]

 call _print_integer



 mov rdi, 8

 call _putc



 mov rdi, countdownTimespec

 call _sleep
%line 155+1 src/game.asm
 dec QWORD [rbp - 0x18]
 cmp QWORD [rbp - 0x18], 0
 jg .countdown_loop

 add rsp, 0x18

 mov rsp, rbp
 pop rbp
 ret


_start_game:
%line 0+0 ""
 call _clear_screen
%line 169+1 src/game.asm
 .game_loop:


%line 0+0 ""
 mov rdi, gameSpeedTimespec

 call _sleep
 call _move_snake
 call _handle_collision
%line 174+1 src/game.asm
 mov rax, QWORD [gameIsOver]
 test rax, rax
 jz .game_loop

 ret


_end_game:
%line 0+0 ""
 call _clear_screen



 mov rdi, sl3

 call _puts
%line 184+1 src/game.asm
 ret


_init_snake:
 push rax



%line 0+0 ""
 mov rdi, 5




 mov rsi, 5




 mov rdx, 0

 call _get_list_node
%line 191+1 src/game.asm
 mov QWORD [snake + snake_s.tail], rax


%line 0+0 ""
 mov rdi, 6




 mov rsi, 5




 mov rdx, rax

 call _get_list_node
%line 193+1 src/game.asm
 mov QWORD [snake + snake_s.head], rax
 mov DWORD [snake + snake_s.size], 2
 mov DWORD [snake + snake_s.direction], DIRECTION_LEFT

 pop rax
 ret


_get_list_node:
 push rdi


%line 0+0 ""
 mov rdi, 12

 call _alloc
%line 204+1 src/game.asm
 pop rdi
 cmp rax, -1
 jne .noerror


%line 0+0 ""
 mov rdi, sl2

 call _puts



 mov rdi, 12

 call _exit
%line 210+1 src/game.asm
 .noerror:

 mov WORD [rax + coordinate_s.y], si
 mov WORD [rax + coordinate_s.x], di
 mov QWORD [rax + listnode_s.next], rdx

 ret


_inc_snake:
 push rax
 push rdi
 push rsi
 push rdx

 mov rdx, QWORD [snake + snake_s.head]
 mov rdi, 0
 mov di, WORD [rdx + coordinate_s.x]
 mov rsi, 0
 mov si, WORD [rdx + coordinate_s.y]
%line 0+0 ""
 call _get_list_node
%line 232+1 src/game.asm
 mov QWORD [snake + snake_s.head], rax

 mov eax, DWORD [snake + snake_s.size]
 inc eax
 mov DWORD [snake + snake_s.size], eax

 pop rdx
 pop rsi
 pop rdi
 pop rax
 ret


_move_snake:
 push rax
 push rdi
 push rsi
 push rdx
 push rbx

 mov rdx, snake

 add rdx, 0x8
 mov rax, QWORD [rdx]

 mov QWORD [rdx], QWORD [rax + listnode_s.next]
 mov QWORD [rax + listnode_s.next], 0


 mov rdi, 0
 mov di, WORD [rax + coordinate_s.x]
 mov rsi, 0
 mov si, WORD [rax + coordinate_s.y]
%line 0+0 ""
 call _move_cursor



 mov rdi, 32

 call _putc
%line 269+1 src/game.asm
 add rdx, 0x8
 mov rbx, [rdx]


 mov di, WORD [rbx + coordinate_s.x]
 mov si, WORD [rbx + coordinate_s.y]


%line 0+0 ""
 mov rdi, SNAKE_BODY_CHAR

 call _putc
%line 278+1 src/game.asm
 mov QWORD [rbx + listnode_s.next], rax
 mov QWORD [rdx], rax

 mov rdx, rax
%line 0+0 ""
 call _calculate_move
%line 283+1 src/game.asm
 mov DWORD [rdx + listnode_s.coords], eax


 mov di, WORD [rdx + coordinate_s.x]
 mov si, WORD [rdx + coordinate_s.y]


%line 0+0 ""
 mov rdi, SNAKE_HEAD_CHAR

 call _putc
%line 291+1 src/game.asm
 pop rbx
 pop rdx
 pop rsi
 pop rdi
 pop rax
 ret



_calculate_move:
 push rax
 push rdi
 push rdx

 mov rdi, QWORD [snake + snake_s.tail]
 mov eax, DWORD [rdi + listnode_s.coords]
 mov edx, DWORD [snake + snake_s.direction]

 add ax, dx
 xor dx, dx
 add eax, edx

 pop rdx
 pop rdi
 pop rax
 ret


_handle_collision:
 mov rax, [snake + snake_s.tail]
 mov dx, [rax + coordinate_s.x]
 cmp dx, 0
 jl .bumped
 cmp dx, WORD [fieldSize + coordinate_s.x]
 jg .bumped

 cmp dx, WORD [fruitCoords + coordinate_s.x]





 mov dx, [rax + coordinate_s.y]
 cmp dx, 0
 jl .bumped
 cmp dx, WORD [fieldSize + coordinate_s.y]
 jg .bumped

 cmp dx, WORD [fruitCoords + coordinate_s.y]
 mov rd


 ret

 .ate_fuit:
%line 0+0 ""
 call _update_fruit
 call _inc_snake
%line 348+1 src/game.asm
 ret

 .bumped:
 mov QWORD [gameIsOver], 1
 ret


_init_fruit:

 ret


_update_fruit:

 ret
