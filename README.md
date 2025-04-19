## Compile and Run Syntax Analysis
1. For Us
```bash
bison -d file.y
flex file.l
gcc file.tab.c lex.yy.c -lfl
./a.out input.txt
```
2. For Professor
```bash
make
./a.out input.txt
```
-------------

## Compile and Run AST
1. For Us
```bash
bison -d ast.y
flex ast.l
gcc ast.tab.c lex.yy.c ast.c -lfl
./a.out input.txt
```
2. For Professor
```bash
make
./a.out input.txt
```
-------------

<br>

## 🔗 Things yet to be completed

1. **Syntax Analysis**
   - **'scanf'** is not working, kisi bhi testcase m scanf nhi tha isliye pta nhi chala

2. **AST**
   - **'scanf'** and **'printf'** check nhi kiya, baaki sab hopefully sahi chal rha
   - Heavy Testing krni h
   - AST print krte samay **'\n', '\t' and 'whitespaces'** kab print krne h kab nhi woh last m sahi krna h
   - Unnecessary print statements remove krni h saari
