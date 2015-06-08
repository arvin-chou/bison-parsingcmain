%{
#include "Parser.h"
%}

blanks          [ \t\n]+
int             [0-9]+
identifier    [_a-zA-Z0-9]+
string           \"(\\.|[^\\"])*\"

%%

{blanks}        { /* ignore */ }

"var"   return(VAR);
"{"       return(BLOCK);
"}"       return(ENDBLOCK);
":"         {return COLON;}
","         {return COMMA;}
"="         {return ASSIGN;}
"("       { return LBRACE; }
")"       { return RBRACE; }
";"       { return SEMICOLON; }
"int main()" {return MAIN;}
"printf" {return PRINTF;}


{int}  {
    yylval.ival = atoi(yytext);
    return NUM;
}
{identifier}  {
        yylval.sval = malloc(strlen(yytext));
        strncpy(yylval.sval, yytext, strlen(yytext));
        return(IDENTIFIER);
}
{string}  {
        yylval.sval = malloc(strlen(yytext));
#ifdef DBG
        fprintf(stderr, "string=%s\n", yytext);
#endif
        strncpy(yylval.sval, yytext, strlen(yytext));
        return(STRING);
}
