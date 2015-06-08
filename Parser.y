%{
#include <stdio.h>
%}

// Symbols.
%union
{
  char  *sval;
  int    ival;
};
%token <ival> NUM
%token <sval> IDENTIFIER
%token <sval> STRING
%token PRINTF
%token VAR
%token BLOCK ENDBLOCK
%token COLON COMMA ASSIGN LBRACE RBRACE SEMICOLON
%token MAIN

%start START_BLOCK
%%

START_BLOCK:
  MAIN BLOCK CONTENT ENDBLOCK /* int main() { ... } */
  ;

CONTENT:
  /* empty */
  | CONTENT STATEMENT SEMICOLON /* multi-line */
  ;

STATEMENT:
  | VAR IDENTIFIER ASSIGN OBJECT
  | F_PRINTF  /* multi-line */
  | STRING { printf("PASS STRING=%s\n", $1); }
  ;

F_PRINTF:
  PRINTF LBRACE STRING COMMA STRING RBRACE { printf($3, $5); }
  | PRINTF LBRACE RBRACE  { printf("empty print!\n"); }
  ;

Pairs:
  /* empty */
  | Pairs COMMA Pair
  | Pair
  ;

Pair:
  IDENTIFIER COLON VALUE { printf("\t\tPair Key: %s\n", $1); }
  ;

OBJECT:
  BLOCK Pairs ENDBLOCK
  | BLOCK ENDBLOCK
  ;

VALUE:
  IDENTIFIER { printf("\t\tvalue: %s\n", $1); }
  | NUM { printf("\t\tvalue: %d\n", $1); }
  | OBJECT
  ;

%%

int yyerror(char *s) {
  printf("yyerror : %s\n",s);
}

int main(void) {
  yyparse();
}
