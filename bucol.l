%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
%}

%option noyywrap
%option caseless
%option yylineno

space       [\n\t ]+
integer     (\-|\+)?[0-9]+
id          [a-zA-Z\_][a-zA-Z][a-zA-Z0-9\-]*
string      \"(\\.|[^\\"])*\"

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

[S]+        { yylval.size = strlen(yytext); return CAPACITY; }
{integer}   { yylval.value = atoi(yytext); return INTEGER; }
{id}        { yylval.id = yytext; return IDENTIFIER; }
{string}    { return STRING; }

\.          { return LINE_TERMINATOR; }
;           { return SEMICOLON; }
.           { return UNKNOWN; }

%%