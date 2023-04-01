%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include "bucol.tab.h"
%}

%option caseless
%option yylineno

space       [\n\t ]+
integer     (\-|\+)?[0-9]+
id          [a-zA-Z\_][a-zA-Z0-9\-]*
string      \"([^\\"])*\"

%%
{space}     /* Ignore */;
START       { return START; }
END         { return END; }
MAIN        { return MAIN; }
MOVE        { return MOVE; }
ADD         { return ADD; }
TO          { return TO; }
INPUT       { return INPUT; }
PRINT       { return PRINT; }

[Ss]+       { yylval.capacity = strlen(yytext); return CAPACITY; }
{integer}   { yylval.num = atoi(yytext); return INTEGER; }
{id}        { yylval.id = yytext; printf("TOKEN: %s\n", yytext); return IDENTIFIER; }
{string}    { return STRING; }

\.          { return LINE_TERMINATOR; }
;           { return SEMICOLON; }
.           { return 0; }

%%

int yywrap(){
    return 1;
}