BISON_FILE = ast.y
FLEX_FILE  = ast.l
C_FILE     = ast.c

BISON_C = ast.tab.c
BISON_H = ast.tab.h
FLEX_C  = lex.yy.c

TARGET = a.out

all: $(TARGET)

$(TARGET): $(BISON_C) $(FLEX_C) $(C_FILE)
	gcc $(BISON_C) $(FLEX_C) $(C_FILE) -lfl

$(BISON_C) $(BISON_H): $(BISON_FILE)
	bison -d $(BISON_FILE)

$(FLEX_C): $(FLEX_FILE)
	flex $(FLEX_FILE)

clean:
	rm -f $(TARGET) $(BISON_C) $(BISON_H) $(FLEX_C)
