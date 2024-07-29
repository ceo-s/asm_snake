SRCDIR = src
BLDDIR = build
BINDIR = bin

SOURCE = $(SRCDIR)/game.asm
OBJECT = $(BLDDIR)/main.o
TARGET = $(BINDIR)/main

INCPATHS = include
INC = $(patsubst %, -i./%, $(INCPATHS))

OPTIONS = -f elf64 -p include/pre_include/unixconsts.asm -p include/pre_include/sysvabicall.asm
PROD_OPTIONS =  $(OPTIONS)
DEBUG_OPTIONS = $(OPTIONS) -g

run: compile link
	./$(TARGET)

debug: compileDebug link
	gdb $(TARGET)

link:
	ld $(OBJECT) -o $(TARGET)

compile: $(SOURCE)
	nasm $(INC) $(PROD_OPTIONS) $(SOURCE) -o $(OBJECT)

compileDebug: $(SOURCE)
	nasm $(INC) $(DEBUG_OPTIONS) $(SOURCE) -o $(OBJECT)

preprocess:
	nasm $(OPTIONS) $(INC) -e src/game.asm > preprocessor_output/$(patsubst $(SRCDIR)/%,preprocessed_%, $(SOURCE))