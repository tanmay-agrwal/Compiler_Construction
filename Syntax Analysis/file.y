%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char* s);
int yylex(void);
extern FILE* yyin;

int scan_count=0;
int print_count=0;
%}

%token INT BEGIN_VARDECL END_VARDECL ID CHAR SC BGN END OB CB COMMA CHARACTER AT
%token IF ASSIGNMENT ELSE PLUS MINUS MUL DIV MOD EQUAL GREATER LESSER GREATER_EQUAL LESSER_EQUAL NOT_EQUAL
%token FOR DO TO INC DEC WHILE BEGIN_PROGRAM END_PROGRAM PRINT 
%token ARY DECIMAL OCTAL BINARY TEN EIGHT TWO QUOTES PLUS_ASSIGN MINUS_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN STRING_LETTER SCAN

%right ASSIGNMENT PLUS_ASSIGN MINUS_ASSIGN DIV_ASSIGN MUL_ASSIGN MOD_ASSIGN
%left EQUAL NOT_EQUAL
%left LESSER_EQUAL LESSER GREATER GREATER_EQUAL
%left PLUS MINUS
%left MUL DIV MOD
%nonassoc IF
%nonassoc IFX
%nonassoc ELSE


%%

assignment : BEGIN_PROGRAM var_dec statements END_PROGRAM {printf("Successfully parsed!\n"); return 0;}
    ;
    
var_dec : BEGIN_VARDECL decl END_VARDECL {}
    ;

decl : OB data COMMA type CB SC decl {}
    | {}
    ;

data : ID {}
    | ARY {}
    ;
    
type : INT {}
    | CHAR {}
    ;

statements : statement statements {}
    | {}
    ;
    
statement : assign {}
    | if_stmt {}
    | for_stmt {}
    | while_stmt {}
    | blck_stmt {}
    | print_stmt {}
    | scan_stmt {}
    ;

blck_stmt : BGN statements_1 END {}
    ;
    
statements_1 : stmt_1 statements_1 {}
    | {}
    ;
    
stmt_1 : assign {}
    | print_stmt {}
    | scan_stmt {}
    ;

if_stmt : IF OB relational CB BGN statements_1 END SC {}
    | IF OB relational CB BGN statements_1 END ELSE BGN statements_1 END SC %prec IFX {}
    ;
    
for_stmt : FOR ID ASSIGNMENT expr to_part update expr DO BGN statements_1 END SC {}
    ;
    
to_part : TO expr {}
    | {}
    ;
    
update : INC {}
    | DEC {}
    ;
    
while_stmt : WHILE OB relational CB DO BGN statements_1 END SC {}
    ;

print_stmt : PRINT QUOTES str QUOTES additional CB SC {if (print_count!=0) yyerror("PRINT STATEMENT ERROR\n");}
    | PRINT CB SC {} 
    ;
    
str : STRING_LETTER str {}
    | AT str {print_count+=1;}
    |  {}
    ;
    
additional : COMMA xyz additional {print_count--;}
    |  {}
    ;

xyz : ID {}
    | int_const {}
    | CHARACTER {}
    ;
    
scan_stmt: SCAN OB QUOTES pqr QUOTES additional_1 CB SC {if (scan_count!=0) yyerror("Invalid scan stmt");}
    ;

pqr : AT tuv {scan_count+=1;}
    ;

tuv : COMMA AT tuv {scan_count+=1;}
    |  {}
    ;

additional_1 : COMMA ID additional_1 {scan_count-=1;}
    |  {}
    ;
        
assign : ID assignment_op expr SC {}
    ;

assignment_op : ASSIGNMENT {}
    | PLUS_ASSIGN {}
    | MINUS_ASSIGN {}
    | MUL_ASSIGN {}
    | DIV_ASSIGN {}
    | MOD_ASSIGN {}
    ;
    
expr : arith {}
    ;
    
arith : arith PLUS arith {}
    | arith MINUS arith {}
    | arith MUL arith {}
    | arith DIV arith {}
    | arith MOD arith {}
    | ID {}
    | int_const {}
    ;

int_const : OB DECIMAL COMMA TEN CB {}
   | OB OCTAL COMMA EIGHT CB {}
   | OB BINARY COMMA TWO CB {}
   | OB BINARY COMMA EIGHT CB {}
   | OB BINARY COMMA TEN CB {}
   | OB OCTAL COMMA TEN CB {}
   ;
    
relational : relational EQUAL relational {}
    | relational NOT_EQUAL relational {} 
    | relational GREATER relational {}
    | relational LESSER relational {}
    | relational GREATER_EQUAL relational {}
    | relational LESSER_EQUAL relational {}
    | arith {}
    ;

%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Error opening file");
        return 1;
    }

    yyparse();
    fclose(yyin);
    return 0;
}

void yyerror(const char* s){
    printf("Syntax Error !!!\n");
    exit(1);
}
