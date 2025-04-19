## Compile and Run Syntax Analysis
```bash
bison -d file.y
flex file.l
gcc file.tab.c lex.yy.c -lfl
./a.out input.txt
```
OR
```bash
make
./a.out input.txt
```
-------------

## Compile and Run AST
```bash
bison -d ast.y
flex ast.l
gcc ast.tab.c lex.yy.c ast.c -lfl
./a.out input.txt
```
OR
```bash
make
./a.out input.txt
```
-------------

<br>

## 🔗 Things yet to be completed

1. **Syntax Analysis**
   - Scanf is not working. Kisi bhi testcase m scanf nhi tha isliye pta nhi chala.

2. **AST**
   - **'scanf'** and **'printf'** check nhi kiya, baaki sab hopefully sahi chal rha
   - Heavy Testing krni h
   - AST print krte samay **'\n', '\t' and 'whitespaces'** kab print krne h kab nhi woh last m sahi krna h
   - Unnecessary print statements remove krni h saari
