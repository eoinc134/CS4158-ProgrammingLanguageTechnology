%{
// Imports    
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

extern int yylex();
extern int yyparse();
extern int yylineno;

// Function declarations
void yyerror(const char* s);
void addVariable(int capacity, char* id);
void varToVar(char* id1, char* id2);
void intToVar(int num, char* id);
void isIdentifier(char* id);
int returnIndex(char* id);

// Variable structure
typedef struct {
   char* identifier;
   int capacity;
} var;

int num_vars = 0;
var identifiers[100];

%}

%union {int num; int capacity; char* identifier;}
%start program
%token <capacity> CAPACITY
%token <num> INTEGER
%token <identifier> IDENTIFIER
%token START       
%token END
%token MAIN
%token MOVE
%token ADD
%token TO
%token INPUT
%token PRINT 
%token TERMINATOR
%token SEMICOLON
%token STRING

%%
program             :   start body end                                      { printf("This program is well-formed.\n"); exit(0) };

// Start section
start               :   START TERMINATOR declarations                  {};

declarations        :   declarations declaration                            {}
                    |                                                       {};

declaration         :   CAPACITY IDENTIFIER TERMINATOR                 { addVariable($1, $2); };


// Body section
body                :   MAIN TERMINATOR operations                     {};

operations          :   operations operation                                {}
                    |                                                       {};

operation           :   move | add | input | print                          {};

// Operations
move                :   MOVE IDENTIFIER TO IDENTIFIER TERMINATOR       { printf("ID1: %s, ID2: %s\n", $2, $4); varToVar($2, $4); }
                    |   MOVE INTEGER TO IDENTIFIER TERMINATOR          { printf("INT: %d, ID: %s\n", $2, $4); intToVar($2, $4); };

add                 :   ADD IDENTIFIER TO IDENTIFIER TERMINATOR        { printf("ID1: %s, ID2: %s\n", $2, $4); varToVar($2, $4); }
                    |   ADD INTEGER TO IDENTIFIER TERMINATOR           { printf("INT: %d, ID: %s\n", $2, $4); intToVar($2, $4); };


input               :   INPUT input_statement                               {};
input_statement     :   IDENTIFIER SEMICOLON input_statement                { isIdentifier($1); }
                    |   IDENTIFIER TERMINATOR                          { isIdentifier($1); };


print               :   PRINT print_statement                               {};
print_statement     :   STRING SEMICOLON print_statement                    {}
                    |   IDENTIFIER SEMICOLON print_statement                { isIdentifier($1); }
                    |   STRING TERMINATOR                              {}
                    |   IDENTIFIER TERMINATOR                          { isIdentifier($1); };

// End section
end                 :   END TERMINATOR                                 {};
%%

// Main Function
extern FILE *yyin;
//int main() {
  //  printf("Enter the program text:\n");
	//printf(">>> \n");
	//yyparse();
//}
void main(int argc, char **argv) {
    yyin = fopen("files/valid.bucol", "r");
    yyparse();
    fclose(yyin);
}


// Return Error
void yyerror(const char *s) {
    printf("\nProgram is invalid.\n");
    fprintf(stderr, "Error on line %d: %s\n", yylineno, s);
}

// Add New Variable
void addVariable(int capacity, char* id) {
    if(returnIndex(id) != -1) {
        printf("\nProgram is invalid.\n");
        fprintf(stderr, "Error on line %d: Variable %s already exists\n", yylineno, id);
        exit(0);
    }

    num_vars++;

    char* temp = (char *) calloc(strlen(id) + 1, sizeof(char));
    strcpy(temp, id);

    var variable;
    variable.identifier = temp;
    variable.capacity = capacity;
    identifiers[num_vars - 1] = variable;
}

// Check var -> var
void varToVar(char* id1, char* id2) {
    int id1Index = returnIndex(id1);
    int id2Index = returnIndex(id2);
    
    if(id1Index == -1 && id2Index != -1){
    	printf("\nProgram is invalid.\n");
        fprintf(stderr, "Error on line %d: Variable %s does not exist\n", yylineno, id1);
        exit(0);
    }
    else if(id1Index != -1 && id2Index == -1){
    	printf("\nProgram is invalid.\n");
        fprintf(stderr, "Error on line %d: Variable %s does not exist\n", yylineno, id2);
        exit(0);
    }
    else if(id1Index == -1 && id2Index == -1){
    	printf("\nProgram is invalid.\n");
        fprintf(stderr, "Error on line %d: Variable %s and Variable %s do not exist\n", yylineno, id1, id2);
        exit(0);
    }
    else{
        int id1Size = identifiers[id1Index].capacity;
        int id2Size = identifiers[id2Index].capacity;
        
        if(id1Size > id2Size){
        	printf("\nProgram is invalid.\n");
            fprintf(stderr, "Warning on line %d: variable %s of capacity %d was too large for variable %s of capacity %d\n", yylineno, id1, id1Size, id2, id2Size);
            exit(0);
        }
    }
}

// Check int -> var
void intToVar(int num, char* id) {
    int idIndex = returnIndex(id);

    if(idIndex == -1){ 
    	printf("\nProgram is invalid.\n");
        fprintf(stderr, "Error on line %d: Variable %s does not exist\n", yylineno, id);
        exit(0);

    } else {
        int maxCap = identifiers[idIndex].capacity;
        int temp = num;
        int numDigits = 0;

        while(temp != 0) {
            temp /= 10;
            numDigits++;
        }

        if(numDigits > maxCap) {
            printf("\nProgram is invalid.\n");
            fprintf(stderr, "Warning on line %d: value %d was too large for variable %s of capacity %d\n", yylineno, num, id, maxCap);
            exit(0);

        }
    }
}

// Check if Identifer Exists
void isIdentifier(char* id) {
    if(returnIndex(id) == -1) {
    	printf("\nProgram is invalid.\n");
        fprintf(stderr, "Error on line %d: Variable %s does not exist\n", yylineno, id);
        exit(0);
    } 
}

// Return Identifier Index
int returnIndex(char *id){ 
    for(int i = 0; i < num_vars; i++) {
        if(identifiers[i].identifier != NULL) {
            if(strcmp(identifiers[i].identifier, id) == 0) {
                return i;
            }
        }
    }    
    return -1;
}