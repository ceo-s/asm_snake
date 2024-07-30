%ifndef ANSI_CODES
%define ANSI_CODES

; Actions
%define ANSI_MOVE_CURSOR  `\033[%d;%dH`
%define ANSI_HIDE_CURSOR  `\033[?25l`
%define ANSI_SHOW_CURSOR  `\033[?25h`
%define ANSI_CLEAR_SCREEN `\x1B[2J`

; Colors
%define ANSI_TEXT_COLOR_NORMAL              `\x1B[0m`,0
%define ANSI_TEXT_COLOR_RED                 `\x1B[0;31m`,0
%define ANSI_TEXT_COLOR_GREEN               `\x1B[0;32m`,0
%define ANSI_TEXT_COLOR_YELLOW              `\x1B[0;33m`,0
%define ANSI_TEXT_COLOR_BLUE                `\x1B[0;34m`,0
%define ANSI_TEXT_COLOR_MAGENTA             `\x1B[0;35m`,0
%define ANSI_TEXT_COLOR_CYAN                `\x1B[0;36m`,0
%define ANSI_TEXT_COLOR_WHITE               `\x1B[0;37m`,0

%define ANSI_TEXT_COLOR_BOLD_NORMAL         `\x1B[0m`,0
%define ANSI_TEXT_COLOR_BOLD_RED            `\x1B[1;31m`,0
%define ANSI_TEXT_COLOR_BOLD_GREEN          `\x1B[1;32m`,0
%define ANSI_TEXT_COLOR_BOLD_YELLOW         `\x1B[1;33m`,0
%define ANSI_TEXT_COLOR_BOLD_BLUE           `\x1B[1;34m`,0
%define ANSI_TEXT_COLOR_BOLD_MAGENTA        `\x1B[1;35m`,0
%define ANSI_TEXT_COLOR_BOLD_CYAN           `\x1B[1;36m`,0
%define ANSI_TEXT_COLOR_BOLD_WHITE          `\x1B[1;37m`,0


%define ANSI_BACKGROUND_COLOR_NORMAL          `\x1B[40m`,0
%define ANSI_BACKGROUND_COLOR_RED             `\x1B[41m`,0
%define ANSI_BACKGROUND_COLOR_GREEN           `\x1B[42m`,0
%define ANSI_BACKGROUND_COLOR_YELLOW          `\x1B[43m`,0
%define ANSI_BACKGROUND_COLOR_BLUE            `\x1B[44m`,0
%define ANSI_BACKGROUND_COLOR_MAGENTA         `\x1B[45m`,0
%define ANSI_BACKGROUND_COLOR_CYAN            `\x1B[46m`,0
%define ANSI_BACKGROUND_COLOR_WHITE           `\x1B[47m`,0

%endif