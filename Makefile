SRCDIR = src
BLDDIR = build
BINDIR = bin
DBDIR  = db

SOURCE = $(SRCDIR)/game.asm
OBJECT = $(BLDDIR)/main.o
TARGET = $(BINDIR)/main
DB     = $(DBDIR)/record

INCPATHS = include
INC = $(patsubst %, -i./%, $(INCPATHS))

OPTIONS = -f elf64 -p include/pre_include/unixconsts.asm -p include/pre_include/sysvabicall.asm
PROD_OPTIONS =  $(OPTIONS)
DEBUG_OPTIONS = $(OPTIONS) -g

run: compile link initDb
	./$(TARGET)

debug: compileDebug link
	gdb $(TARGET)

link:
	ld $(OBJECT) -o $(TARGET)

compile: $(SOURCE)
	nasm $(INC) $(PROD_OPTIONS) $(SOURCE) -o $(OBJECT)

compileDebug: $(SOURCE)
	nasm $(INC) $(DEBUG_OPTIONS) $(SOURCE) -o $(OBJECT)

preprocess: $(SOURCE)
	nasm $(OPTIONS) $(INC) -e src/game.asm > preprocessor_output/$(patsubst $(SRCDIR)/%,preprocessed_%, $(SOURCE))

initDb: 
	if ! [ -e $(DB) ]; then mkdir $(DBDIR) && (printf "\x00\x00\x00\x00" > $(DB)); fi