%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"
ASTNode* root = NULL;
void yyerror(const char* s);
int yylex(void);
extern FILE* yyin;
extern FILE* yyout;

int scan_count=0;
int print_count=0;
%}

%union {
    int ival;
    char* str;
    ASTNode* ast;
}

%token <str> ID STRING_LETTER BINARY OCTAL DECIMAL ARY
%token <ival> CHARACTER
%token INT BEGIN_VARDECL END_VARDECL CHAR SC BGN END OB CB COMMA AT
%token IF ASSIGNMENT ELSE PLUS MINUS MUL DIV MOD EQUAL GREATER LESSER GREATER_EQUAL LESSER_EQUAL NOT_EQUAL
%token FOR DO TO INC DEC WHILE BEGIN_PROGRAM END_PROGRAM PRINT 
%token TEN EIGHT TWO QUOTES PLUS_ASSIGN MINUS_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN SCAN

%type <ast> program var_dec decl statements statement assign expr int_const relational arith
%type <ast> str xyz tuv pqr to_part update if_stmt for_stmt while_stmt blck_stmt print_stmt scan_stmt
%type <ast> statements_1 stmt_1 additional additional_1 type data

%right ASSIGNMENT PLUS_ASSIGN MINUS_ASSIGN DIV_ASSIGN MUL_ASSIGN MOD_ASSIGN
%left EQUAL NOT_EQUAL
%left LESSER_EQUAL LESSER GREATER GREATER_EQUAL
%left PLUS MINUS
%left MUL DIV MOD
%nonassoc IF
%nonassoc IFX
%nonassoc ELSE

%%

program : BEGIN_PROGRAM var_dec statements END_PROGRAM {
    root = createProgramNode($2, $3);
    $$ = root;
    printf("Successfully parsed!\n");
}
;

var_dec : BEGIN_VARDECL decl END_VARDECL { $$ = $2; }
;

decl : OB data COMMA type CB SC decl { 
    $$ = createStatementListNode(
        createVarDeclNode($2->data.str_value, $4),
        $7
    );
}
| { $$ = NULL; }
;

data : ID { $$ = createIDNode($1); }
| ARY { $$ = createIDNode($1);}
;

type : INT { $$ = createTypeNode("int"); }
| CHAR { $$ = createTypeNode("char"); }
;

statements : statement statements { 
    $$ = createStatementListNode($1, $2); 
}
| { $$ = NULL; }
;

statement : assign { $$ = $1; }
| if_stmt { $$ = $1; }
| for_stmt { $$ = $1; }
| while_stmt { $$ = $1; }
| blck_stmt { $$ = $1; }
| print_stmt { $$ = $1; }
| scan_stmt { $$ = $1; }
;

blck_stmt : BGN statements_1 END { $$ = $2; }
;

statements_1 : stmt_1 statements_1 { $$ = createStatementListNode($1, $2); }
| { $$ = NULL; }
;

stmt_1 : assign { $$ = $1; }
| print_stmt { $$ = $1; }
| scan_stmt { $$ = $1; }
;

if_stmt : IF OB relational CB BGN statements_1 END SC {
    $$ = createIfNode($3, $6, NULL);
}
| IF OB relational CB BGN statements_1 END ELSE BGN statements_1 END SC %prec IFX {
    $$ = createIfNode($3, $6, $10);
}
;

for_stmt : FOR ID ASSIGNMENT expr to_part update expr DO BGN statements_1 END SC {
    $$ = createForNode(
        createAssignNode(createIDNode($2), NODE_ASSIGN, $4),
        $5,
        $6,
        $7,
        $10
    );
}
;

to_part : TO expr { $$ = $2; }
| { $$ = NULL; }
;

update : INC { $$ = createIDNode("inc"); }
| DEC { $$ = createIDNode("dec"); }
;

while_stmt : WHILE OB relational CB DO BGN statements_1 END SC {
    $$ = createWhileNode($3, $7);
}
;

print_stmt : PRINT QUOTES str QUOTES additional CB SC { 
    $$ = createPrintNode($3, $5);
    if (print_count != 0) yyerror("PRINT STATEMENT ERROR\n");
}
| PRINT CB SC { $$ = createPrintNode(NULL, NULL); } 
;

str : STRING_LETTER str { 
    $$ = createStringConcatNode($1, $2); 
}
| AT str { 
    $$ = createFormatNode($2); 
    print_count += 1;
}
| { $$ = createStringNode(""); }
;

additional : COMMA xyz additional { 
    $$ = createStatementListNode($2, $3); 
    print_count--;
}
| { $$ = NULL; }
;

xyz : ID { $$ = createIDNode($1); }
| int_const { $$ = $1; }
| CHARACTER { $$ = createCharNode($1); }
;

scan_stmt: SCAN OB QUOTES pqr QUOTES additional_1 CB SC {
    $$ = createScanNode($4, $6);
    if (scan_count != 0) yyerror("Invalid scan stmt");
}
;

pqr : AT tuv { 
    $$ = createStatementListNode(createIDNode("var"), $2); 
    scan_count += 1;
}
|  {}
;

tuv : COMMA AT tuv { 
    $$ = createStatementListNode(createIDNode("var"), $3); 
    scan_count += 1;
}
| { $$ = NULL; }
;

additional_1 : COMMA ID additional_1 { 
    $$ = createStatementListNode(createIDNode($2), $3); 
    scan_count -= 1;
}
| { $$ = NULL; }
;

assign : ID ASSIGNMENT expr SC {$$ = createAssignNode(createIDNode($1), NODE_ASSIGN, $3);}
| ID PLUS_ASSIGN expr SC {$$ = createAssignNode(createIDNode($1), NODE_ADD_ASSIGN, $3);}
| ID MINUS_ASSIGN expr SC {$$ = createAssignNode(createIDNode($1), NODE_SUB_ASSIGN, $3);}
| ID MUL_ASSIGN expr SC {$$ = createAssignNode(createIDNode($1), NODE_MUL_ASSIGN, $3);}
| ID DIV_ASSIGN expr SC {$$ = createAssignNode(createIDNode($1), NODE_DIV_ASSIGN, $3);}
| ID MOD_ASSIGN expr SC {$$ = createAssignNode(createIDNode($1), NODE_MOD_ASSIGN, $3);}
;

expr : arith { $$ = $1; }
;

arith : arith PLUS arith { $$ = createOperatorNode(NODE_ADD, $1, $3); }
| arith MINUS arith { $$ = createOperatorNode(NODE_SUB, $1, $3); }
| arith MUL arith { $$ = createOperatorNode(NODE_MUL, $1, $3); }
| arith DIV arith { $$ = createOperatorNode(NODE_DIV, $1, $3); }
| arith MOD arith { $$ = createOperatorNode(NODE_MOD, $1, $3); }
| ID { $$ = createIDNode($1); }
| int_const { $$ = $1; }
;

int_const : OB DECIMAL COMMA TEN CB { $$ = createNumberNode(atoi($2)); $$ = createNumberNode(atoi($2)); $$->base = 10; }
| OB OCTAL COMMA EIGHT CB {  $$ = createNumberNode(strtol($2, NULL, 8)); $$->base = 8; }
| OB BINARY COMMA TWO CB { $$ = createNumberNode(strtol($2, NULL, 2)); $$->base = 2;}
| OB BINARY COMMA EIGHT CB { $$ = createNumberNode(strtol($2, NULL, 8)); $$->base = 8;}
| OB BINARY COMMA TEN CB { $$ = createNumberNode(strtol($2, NULL, 10));$$->base = 10; }
| OB OCTAL COMMA TEN CB { $$ = createNumberNode(strtol($2, NULL, 8)); $$->base = 10;}
;

relational : relational EQUAL relational { $$ = createOperatorNode(NODE_EQ, $1, $3); }
| relational NOT_EQUAL relational { $$ = createOperatorNode(NODE_NEQ, $1, $3); }
| relational GREATER relational { $$ = createOperatorNode(NODE_GT, $1, $3); }
| relational LESSER relational { $$ = createOperatorNode(NODE_LT, $1, $3); }
| relational GREATER_EQUAL relational { $$ = createOperatorNode(NODE_GTE, $1, $3); }
| relational LESSER_EQUAL relational { $$ = createOperatorNode(NODE_LTE, $1, $3); }
| arith { $$ = $1; }
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
    if(root) {
        printf("\nGenerated AST:\n");
        printAST(root);
        freeAST(root);
    }
    fclose(yyin);
    return 0;
}

void yyerror(const char* s){
    printf("Syntax Error !!!\n");
    exit(1);
}

