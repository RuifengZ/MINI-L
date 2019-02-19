/* calculator. */
%{
 #include <stdio.h>
 #include <stdlib.h>
 void yyerror(const char *msg);
 extern int currLine;
 extern int currPos;
 FILE * yyin;
%}

%union{
  int int_val;
  string* op_val;
}

%error-verbose
%start program
%token FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE RETURN SUB ADD MULT DIV MOD EQ NEQ LT GT LTE GTE SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN
%token <int_val> NUMBER
%type <op_val> IDENT

%% 
program:    program function {}
            | {}
            ;

function:   FUNCTION IDENT SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY {}
            ;

declarations:  declarations declaration SEMICOLON {}
               | {}
               ;

statements: statements statement SEMICOLON {}
            | statement SEMICOLON {}
            ;

declaration:   identifiers arrays INTEGER
               ;

identifiers:   IDENT COMMA identifiers{}
               | identifiers COLON {}
               ;

arrays:  ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF {}
         | {}
         ;

statement:  var ASSIGN expression {}
            | IF bool_exp THEN statements state_b ENDIF {}
            | WHILE bool_exp BEGINLOOP statements ENDLOOP {}
            | DO BEGINLOOP statements ENDLOOP WHILE bool_exp {}
            | READ vars {}
            | WRITE vars {}
            | CONTINUE {}
            | RETURN expression {}
            ;

state_b: ELSE statements {}
         | {}
         ;

vars: var COMMA vars {}
      | var {}
      ;

bool_exp:   and_exp {}
            | and_exp OR and_exp {}
            ;

and_exp:    relation {}
            | relation AND relation {}
            ;

relation:   relation2 {}
            | NOT relation2 {}
            ;

relation2:  expression comp expression {}
            | TRUE {}
            | FALSE {}
            | L_PAREN bool_exp R_PAREN {}
            ;

comp: EQ {}
      | LT GT {}
      | LT {}
      | GT {}
      | LTE {}
      | GTE {}
      ;

expression: mult_exp {}
            | mult_exp ADD mult_exp {}
            | mult_exp SUB mult_exp {}
            ;

mult_exp:   term {}
            | term MULT term {}
            | term DIV term {}
            | term MOD term {}
            ;

term: 

%%

int main(int argc, char **argv) {
   if (argc > 1) {
      yyin = fopen(argv[1], "r");
      if (yyin == NULL){
         printf("syntax: %s filename\n", argv[0]);
      }//end if
   }//end if
   yyparse(); // Calls yylex() for tokens.
   return 0;
}

void yyerror(const char *msg) {
   printf("** Line %d, position %d: %s\n", currLine, currPos, msg);
}

