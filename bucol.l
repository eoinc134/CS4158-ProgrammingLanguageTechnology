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
START       |
END         |
MAIN        |
MOVE        |
ADD         |
TO          |
INPUT       |
PRINT       { printf("%s: is a valid keyword\n", yytext); }

[S]+        { printf("%s: is a valid capacity declaration\n", yytext); }
{integer}   { printf("%s: is a valid integer\n", yytext); }
{id}        { printf("%s: is a valid identifier\n", yytext); }
{string}    { printf("%s: is a valid string\n", yytext); }

\.          { printf("%s: is a valid line terminator\n", yytext); }
;           { printf("%s: is a valid symbol\n", yytext); }
.           { printf("%s: is not a valid token\n", yytext);}

%%

main()
{
    
}