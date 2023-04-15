# CS4158-ProgrammingLanguageTechnology

Lexer and Syntactical Validation for 'BUCOL' programs using Flex & Bison

RUN COMMANDS [LEXER]:

- flex bucol.l
- gcc lex.yy.c
- ./a.exe

RUN COMMANDS [PARSER]:

- flex bucol.l
- bison –d bucol.y
- cc –c lex.yy.c bucol.tab.c
- cc –o bucol lex.yy.o bucol.tab.o –ll
- ./bucol.exe
