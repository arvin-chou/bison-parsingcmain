CC := gcc
OBJS := Parser.lex.o Parser.y.o
DEFAULT_CLEAN := Parser.lex.c Parser.y.c Parser.h
MODULES   := $(shell /bin/pwd)
SRC_DIR   := $(addprefix src/,$(MODULES))
SRC       := $(foreach sdir,$(SRC_DIR),$(wildcard $(sdir)/Parser*.c))
OBJ       := $(patsubst src/%.o,build/%.o,$(SRC))
CFLAGS := -DDBG
CFLAGS := -g
OUTPUT := Parser

define cc-command
	$(CC) $(CFLAGS) -c $< -o $@
endef

vpath %.c $(SRC_DIR)

.PHONY: all clean
.SECONDARY: pre-build main-build

all: pre-build main-build

pre-build: BISON FLEX

BISON:
	bison -d Parser.y
	mv Parser.tab.h Parser.h
	mv Parser.tab.c Parser.y.c

FLEX:
	flex Parser.lex
	mv lex.yy.c Parser.lex.c

main-build: $(OUTPUT)

$(OBJS): %.o: %.c
	$(cc-command)
	#@echo "Compiled "$<" successfully!"

$(OUTPUT): $(OBJS)
	#$(CC) $(CFLAGS) -c Parser.lex.c -o Parser.lex.o
	#$(CC) $(CFLAGS) -c Parser.y.c -o Parser.y.o
	$(CC) $(CFLAGS) -o $@ $(OBJS) -lfl

clean:
	-rm $(OUTPUT) $(OBJS) $(DEFAULT_CLEAN)
