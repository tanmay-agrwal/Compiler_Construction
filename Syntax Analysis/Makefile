BISON_FILE = file.y
FLEX_FILE  = file.l

BISON_C = file.tab.c
BISON_H = file.tab.h
FLEX_C  = lex.yy.c

TARGET = a.out

all: $(TARGET)

$(TARGET): $(BISON_C) $(FLEX_C)
	gcc $(BISON_C) $(FLEX_C) -lfl

$(BISON_C) $(BISON_H): $(BISON_FILE)
	bison -d $(BISON_FILE)

$(FLEX_C): $(FLEX_FILE)
	flex $(FLEX_FILE)

clean:
	rm -f $(TARGET) $(BISON_C) $(BISON_H) $(FLEX_C)
