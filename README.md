# CS4158-ProgrammingLanguageTechnology

Lexer and Syntactical Validation for 'BUCOL' programs using Flex & Bison

RUN COMMANDS:
flex bucol.l
bison –d bucol.y
cc –c lex.yy.c bucol.tab.c
cc –o bucol lex.yy.o bucol.tab.o –ll
bucol
