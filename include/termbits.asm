%ifndef TERMBITS_ASM
%define TERMBITS_ASM

; /* c_cc characters */
%define VINTR		0
%define VQUIT		1
%define VERASE		2
%define VKILL		3
%define VEOF		4
%define VTIME		5
%define VMIN		6
%define VSWTC		7
%define VSTART		8
%define VSTOP		9
%define VSUSP		10
%define VEOL		11
%define VREPRINT	12
%define VDISCARD	13
%define VWERASE		14
%define VLNEXT		15
%define VEOL2		16

; /* c_iflag bits */
%define IUCLC	0x0200
%define IXON	0x0400
%define IXOFF	0x1000
%define IMAXBEL	0x2000
%define IUTF8	0x4000

; /* c_oflag bits */
%define OLCUC	0x00002
%define ONLCR	0x00004
%define NLDLY	0x00100
%define   NL0	0x00000
%define   NL1	0x00100
%define CRDLY	0x00600
%define   CR0	0x00000
%define   CR1	0x00200
%define   CR2	0x00400
%define   CR3	0x00600
%define TABDLY	0x01800
%define   TAB0	0x00000
%define   TAB1	0x00800
%define   TAB2	0x01000
%define   TAB3	0x01800
%define   XTABS	0x01800
%define BSDLY	0x02000
%define   BS0	0x00000
%define   BS1	0x02000
%define VTDLY	0x04000
%define   VT0	0x00000
%define   VT1	0x04000
%define FFDLY	0x08000
%define   FF0	0x00000
%define   FF1	0x08000

; /* c_cflag bit meaning */
%define CBAUD		0x0000100f
%define CSIZE		0x00000030
%define   CS5		0x00000000
%define   CS6		0x00000010
%define   CS7		0x00000020
%define   CS8		0x00000030
%define CSTOPB		0x00000040
%define CREAD		0x00000080
%define PARENB		0x00000100
%define PARODD		0x00000200
%define HUPCL		0x00000400
%define CLOCAL		0x00000800
%define CBAUDEX		0x00001000
%define BOTHER		0x00001000
%define     B57600	0x00001001
%define    B115200	0x00001002
%define    B230400	0x00001003
%define    B460800	0x00001004
%define    B500000	0x00001005
%define    B576000	0x00001006
%define    B921600	0x00001007
%define   B1000000	0x00001008
%define   B1152000	0x00001009
%define   B1500000	0x0000100a
%define   B2000000	0x0000100b
%define   B2500000	0x0000100c
%define   B3000000	0x0000100d
%define   B3500000	0x0000100e
%define   B4000000	0x0000100f
%define   CIBAUD		0x100f0000	; /* input baud rate */

; /* c_lflag bits */
%define ISIG	0x00001
%define ICANON	0x00002
%define XCASE	0x00004
%define ECHO	0x00008
%define ECHOE	0x00010
%define ECHOK	0x00020
%define ECHONL	0x00040
%define NOFLSH	0x00080
%define TOSTOP	0x00100
%define ECHOCTL	0x00200
%define ECHOPRT	0x00400
%define ECHOKE	0x00800
%define FLUSHO	0x01000
%define PENDIN	0x04000
%define IEXTEN	0x08000
%define EXTPROC	0x10000

; /* tcsetattr uses these */
%define	TCSANOW		0
%define	TCSADRAIN	1
%define	TCSAFLUSH	2

%define TCGETS		0x5401
%define TCSETS		0x5402
%define TCSETSW		0x5403
%define TCSETSF		0x5404
%define TCGETA		0x5405
%define TCSETA		0x5406
%define TCSETAW		0x5407
%define TCSETAF		0x5408
%define TCSBRK		0x5409
%define TCXONC		0x540A
%define TCFLSH		0x540B
%define TIOCEXCL	0x540C
%define TIOCNXCL	0x540D
%define TIOCSCTTY	0x540E
%define TIOCGPGRP	0x540F
%define TIOCSPGRP	0x5410
%define TIOCOUTQ	0x5411
%define TIOCSTI		0x5412
%define TIOCGWINSZ	0x5413
%define TIOCSWINSZ	0x5414
%define TIOCMGET	0x5415
%define TIOCMBIS	0x5416
%define TIOCMBIC	0x5417
%define TIOCMSET	0x5418
%define TIOCGSOFTCAR	0x5419
%define TIOCSSOFTCAR	0x541A
%define FIONREAD	0x541B
%define TIOCINQ		FIONREAD
%define TIOCLINUX	0x541C
%define TIOCCONS	0x541D
%define TIOCGSERIAL	0x541E
%define TIOCSSERIAL	0x541F
%define TIOCPKT		0x5420
%define FIONBIO		0x5421
%define TIOCNOTTY	0x5422
%define TIOCSETD	0x5423
%define TIOCGETD	0x5424
%define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
%define TIOCSBRK	0x5427  /* BSD compatibility */
%define TIOCCBRK	0x5428  /* BSD compatibility */
%define TIOCGSID	0x5429  /* Return the session ID of FD */
%define TCGETS2		_IOR('T', 0x2A, struct termios2)
%define TCSETS2		_IOW('T', 0x2B, struct termios2)
%define TCSETSW2	_IOW('T', 0x2C, struct termios2)
%define TCSETSF2	_IOW('T', 0x2D, struct termios2)
%define TIOCGRS485	0x542E
%ifndef TIOCSRS485
%define TIOCSRS485	0x542F
%endif
%define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
%define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
%define TIOCGDEV	_IOR('T', 0x32, unsigned int) /* Get primary device node of /dev/console */
%define TCGETX		0x5432 /* SYS5 TCGETX compatibility */
%define TCSETX		0x5433
%define TCSETXF		0x5434
%define TCSETXW		0x5435
%define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
%define TIOCVHANGUP	0x5437
%define TIOCGPKT	_IOR('T', 0x38, int) /* Get packet mode state */
%define TIOCGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
%define TIOCGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */
%define TIOCGPTPEER	_IO('T', 0x41) /* Safely open the slave */
%define TIOCGISO7816	_IOR('T', 0x42, struct serial_iso7816)
%define TIOCSISO7816	_IOWR('T', 0x43, struct serial_iso7816)

%define FIONCLEX	0x5450
%define FIOCLEX		0x5451
%define FIOASYNC	0x5452
%define TIOCSERCONFIG	0x5453
%define TIOCSERGWILD	0x5454
%define TIOCSERSWILD	0x5455
%define TIOCGLCKTRMIOS	0x5456
%define TIOCSLCKTRMIOS	0x5457
%define TIOCSERGSTRUCT	0x5458 ; /* For debugging only */
%define TIOCSERGETLSR   0x5459 ; /* Get line status register */
%define TIOCSERGETMULTI 0x545A ; /* Get multiport config  */
%define TIOCSERSETMULTI 0x545B ; /* Set multiport config */

%define TIOCMIWAIT	0x545C	; /* wait for a change on serial input line(s) */
%define TIOCGICOUNT	0x545D	; /* read serial port __inline__ interrupt counts */

; /*
; * Some arches already define FIOQSIZE due to a historical
; * conflict with a Hayes modem-specific ioctl value.
; */
%ifndef FIOQSIZE
%define FIOQSIZE	0x5460
%endif

; /* Used for packet mode */
%define TIOCPKT_DATA		 0
%define TIOCPKT_FLUSHREAD	 1
%define TIOCPKT_FLUSHWRITE	 2
%define TIOCPKT_STOP		 4
%define TIOCPKT_START		 8
%define TIOCPKT_NOSTOP		16
%define TIOCPKT_DOSTOP		32
%define TIOCPKT_IOCTL		64

%define TIOCSER_TEMT	0x01	; /* Transmitter physically empty */

%endif