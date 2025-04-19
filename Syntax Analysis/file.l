%{
#include "file.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char* s);
int m_comment=0;
static char *ary[50];
int ary_count=0;
void check(const char *str);
%}

%x COMMENT
%x VAR_1
%x VAR_COMMENT
%x BI
%x STRINGS

lowercase [a-z]
digits [0-9]
space [ ]
keywords (int)|(char)|(if)|(else)|(while)|(for)|(main)|(begin)|(end)|(print)|(scan)|(VarDecl)|(program)|(inc)|(dec)
identifier {lowercase}({lowercase}|{digits})*[_]?({lowercase}|{digits})*
inv_identifier ({lowercase}|{digits}|_)*
oct_inv_const \({space}*{digits}*(9){digits}*{space}*,{space}*8{space}*\)
bin_inv_const \({space}*{digits}*[3-9]{digits}*{space}*,{space}*2{space}*\)
invalid_const \({space}*{digits}*{space}*,{space}*(((0|2-9){digits}*)|((1){digits}{digits}+)|((1)[1-9])){space}*\)


%%
"to" {return TO;}
"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"for" {return FOR;}
"inc" {return INC;}
"dec" {return DEC;}
"int" {return INT;}
"char" {return CHAR;}
"begin"{space}*"program:" { return BEGIN_PROGRAM;}
"end"{space}*"program" {return END_PROGRAM;}
"begin" {return BGN;}
"end" {return END;}
"do" {return DO;}
[0-1]+/"," {BEGIN (BI); return BINARY;}
[0-7]+/"," {BEGIN (BI); return OCTAL;}
{digits}+/"," {BEGIN (BI); return DECIMAL;}
<BI>"2" {BEGIN(0); return TWO;}
<BI>{space}* {}
<BI>"8" {BEGIN(0); return EIGHT;}
<BI>"10" {BEGIN(0); return TEN;}
<BI>"," {return COMMA;}
<BI>. {yyerror(yytext);}
"+" {return PLUS;}
"-" {return MINUS;}
"*" {return MUL;}
"/" {return DIV;}
"%" {return MOD;}
"=" {return EQUAL;}
">" {return GREATER;}
"<" {return LESSER;}
">=" {return GREATER_EQUAL;}
"<=" {return LESSER_EQUAL;}
"<>" {return NOT_EQUAL;}
";" {return SC;}
"," {return COMMA;}
"(" {return OB;}
")" {return CB;}
":=" {return ASSIGNMENT;}
"\+=" {return PLUS_ASSIGN;}
"-=" {return MINUS_ASSIGN;}
"\*=" {return MUL_ASSIGN;}
"\/=" {return DIV_ASSIGN;}
"%=" {return MOD_ASSIGN;}
{oct_inv_const} {yyerror(yytext);}
{bin_inv_const} {yyerror(yytext);}
{invalid_const} {yyerror(yytext);}
\({space}*{keywords}\[{digits}*\]{space}*,{space}*int{space}*\) {yyerror(yytext);}
\({space}*{keywords}\[{digits}*\]{space}*,{space}*char{space}*\) {yyerror(yytext);}
\({space}*{identifier}\[{digits}*\]{space}*,{space}*int{space}*\) {return ARY;}
\({space}*{identifier}\[{digits}*\]{space}*,{space}*char{space}*\) {return ARY;}
print\( {return PRINT;}
[\"] {BEGIN(STRINGS); return QUOTES;}
<STRINGS>"@" {return AT;}
<STRINGS>[\"] {BEGIN(0); return QUOTES;}
<STRINGS>. {return STRING_LETTER;}
scan\( {return SCAN;}
"//"(.)*\n {}
"/*" {BEGIN(COMMENT); m_comment++; yymore();}
<COMMENT>"/*" {m_comment++; yymore();}
<COMMENT>. {yymore();}
<COMMENT>\n {yymore();}
<COMMENT>"*/" {m_comment--; if(m_comment==0) BEGIN(0); else yymore();}
"begin"{space}*"VarDecl:" {BEGIN(VAR_1); return BEGIN_VARDECL;}
<VAR_1>"end"{space}*"VarDecl" {BEGIN(0); return END_VARDECL;}
<VAR_1>"//"(.)*\n {}
<VAR_1>"/*" {BEGIN(VAR_COMMENT); m_comment++; yymore();}
<VAR_COMMENT>"/*" {m_comment++; yymore();}
<VAR_COMMENT>. {yymore();}
<VAR_COMMENT>\n {yymore();}
<VAR_COMMENT>"*/" {m_comment--; if(m_comment==0) {BEGIN(VAR_1);} else {yymore();} }
<VAR_1>";" {return SC;}
<VAR_1>"," {return COMMA;}
<VAR_1>"(" {return OB;}
<VAR_1>")" {return CB;}
<VAR_1>{space}*{identifier}\[{digits}*\]{space}* {return ARY;}
<VAR_1>{identifier}/"," {check(yytext); return ID;}
<VAR_1>{inv_identifier}/"," {yyerror(yytext);}
<VAR_1>"int" {return INT;}
<VAR_1>"char" {return CHAR;}
<VAR_1>'\\n' {return CHARACTER;}
<VAR_1>'\\t' {return CHARACTER;}
<VAR_1>{space}|\n {}
<VAR_1>'.' {return CHARACTER;}
<VAR_1>EOF {return EOF;}
<VAR_1>. {yyerror(yytext);}
{keywords} {yyerror(yytext);}
{identifier} {return ID;}
{inv_identifier} {yyerror(yytext);}
'\\n' {return CHARACTER;}
'\\t' {return CHARACTER;}
'.' {return CHARACTER;}
{space}|\n {}
EOF {return EOF;}
. {yyerror(yytext);}
%%

void check(const char *str){
    const char *keywords[]={"int", "char", "if", "else", "while", "for", "main", "begin", "end", "print", "scan", "program", "VarDecl", "inc", "dec", "then", "to", "do"};
    int num=sizeof(keywords)/sizeof(keywords[0]);

    for(int i=0; i<num; i++){
        if(strcmp(str, keywords[i])==0){
            yyerror("Keyword is used as an identifier");
        }
    }

    for(int i=0; i<ary_count; i++) {
        if(strcmp(ary[i], str)==0) {
            yyerror("Identifier already declared");
        }
    }
    if (ary_count==50) {
        yyerror("Maximum number of identifiers reached");
    }

    ary[ary_count]=(char *)malloc(strlen(str) + 1);
    strcpy(ary[ary_count], str);
    ary_count++;
}

int yywrap(void){
    return 1;
}
