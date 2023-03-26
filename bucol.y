%{
    #include <stdio.h>
%}

%union
%token <capacity> CAPACITY
%token <number> INTEGER
%token <name> IDENTIFIER
%token START       
%token END
%token MAIN
%token MOVE
%token ADD
%token TO
%token INPUT
%token PRINT 
%token LINE_TERMINATOR
%token SEMICOLON
%token STRING