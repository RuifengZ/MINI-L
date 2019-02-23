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
  int num_val;
  char* ident_val;
}

%error-verbose
%start program
%token FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE RETURN SUB ADD MULT DIV MOD EQ NEQ LT GT LTE GTE SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN
%token IDENT NUMBER
%type <num_val> NUMBER
%type <ident_val> IDENT

%% 
program:    function program {printf("program -> program function\n");}
            | {printf("program -> epsilon\n");}
            ;

function:   FUNCTION ident SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY {printf("function -> FUNCTION ident SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY\n");}
            ;

statements: statement SEMICOLON statements {printf("statements -> statement SEMICOLON statements\n");}
            | statement SEMICOLON {printf("statements -> statement SEMICOLON\n");}
            ;

declarations:  declaration SEMICOLON declarations {printf("declarations -> declaration SEMICOLON declarations\n");}
               | {printf("declarations -> epsilon\n");}
               ;

declaration:   identifiers COLON arrays INTEGER {printf("declarations -> identifiers COLON arrays INTEGER\n");}
               ;


identifiers:   ident COMMA identifiers {printf("identifiers -> ident COMMA identifiers\n");}
               | ident {printf("identifiers -> ident\n");}
               ;

arrays:  ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF {printf("arrays -> ARRAY L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET OF\n", $3);}
         | {printf("arrays -> epsilon\n");}
         ;

statement:  var ASSIGN expression {printf("statement -> var ASSIGN expression\n");}
            | IF bool_exp THEN statements state_b ENDIF {printf("statement -> IF bool_exp THEN statements state_b ENDIF\n");}
            | WHILE bool_exp BEGINLOOP statements ENDLOOP {printf("statement -> WHILE bool_exp BEGINLOOP statements ENDLOOP\n");}
            | DO BEGINLOOP statements ENDLOOP WHILE bool_exp {printf("statement -> DO BEGINLOOP statements ENDLOOP WHILE bool_exp\n");}
            | READ vars {printf("statement -> READ vars\n");}
            | WRITE vars {printf("statement -> WRITE vars\n");}
            | CONTINUE {printf("statement -> CONTINUE\n");}
            | RETURN expression {printf("statement -> RETURN expression\n");}
            ;

state_b: ELSE statements {printf("state_b -> ELSE statements\n");}
         | {printf("state_b -> epsilon\n");}
         ;

vars: var COMMA vars {printf("vars -> var COMMA vars\n");}
      | var {printf("vars -> var\n");}
      ;

bool_exp:   and_exp bool_exp2 {printf("and_exp -> and_exp bool_exp2\n");} 
            ;

bool_exp2:  OR and_exp bool_exp2 {printf("bool_exp2 -> OR and_exp bool_exp2\n");}
            | {printf("bool_exp2 -> OR and_exp bool_exp2");}
            ;

and_exp:    relation and_exp2 {printf("and_exp -> relation and_exp2\n");}
            ;

and_exp2:   AND relation and_exp2 {printf("and_exp2 -> AND relation and_exp2");}
            | {printf("and_exp2 -> epsilon");}
            ;

relation:   relation2 {printf("relation -> relation2\n");}
            | NOT relation2 {printf("relation -> NOT relation2\n");}
            ;

relation2:  expression comp expression {printf("relation2 -> expression comp expression\n");}
            | TRUE {printf("relation2 -> TRUE\n");}
            | FALSE {printf("relation2 -> FALSE\n");}
            | L_PAREN bool_exp R_PAREN {printf("relation2 -> L_PAREN bool_exp R_PAREN\n");}
            ;

comp: EQ {printf("comp -> EQ\n");}
      | NEQ {printf("comp -> NEQ\n");}
      | LT {printf("comp -> LT\n");}
      | GT {printf("comp -> GT\n");}
      | LTE {printf("comp -> LTE\n");}
      | GTE {printf("comp -> GTE\n");}
      ;

expression: mult_exp expression2 {printf("expression -> mult_exp expression2\n");}
            ;

expression2:   SUB mult_exp expression2 {printf("expression2 -> SUB mult_exp expression2\n");}
               | ADD mult_exp expression2 {printf("expression2 -> ADD mult_exp expression2\n");}
               | {printf("expression2 -> epsilon\n");}
               ;

mult_exp:   term mult_exp2 {printf("mult_exp -> term\n");}
            ;

mult_exp2:  MULT term mult_exp2 {printf("mult_exp2 -> MULT term mult_exp2\n");}
            | DIV term mult_exp2 {printf("mult_exp2 -> DIV term mult_exp2\n");}
            | MOD term mult_exp2 {printf("mult_exp2 -> MOD term mult_exp2\n");}
            | {printf("mult_exp2 -> epsilon\n");}
            ;

term:    SUB term2 {printf("term -> SUB term2\n");}
         | term2 {printf("term -> term2\n");}
         | term3 {printf("term -> term3\n");}
         ;

term2:   var {printf("term2 -> var\n");}
         | NUMBER {printf("term2 -> NUMBER %d\n", $1);}
         | L_PAREN expression R_PAREN {printf("term2 -> L_PAREN expression R_PAREN\n");}
         ;

term3:   ident L_PAREN term4 R_PAREN {printf("term3 -> ident L_PAREN term4 R_PAREN\n");}
         ;

term4:   expression {printf("expression -> expression\n");}
         | expression COMMA term4 {printf("expression -> expression COMMA term4\n");}
         | {printf("expression -> epsilon\n");}
         ;

var:  ident {printf("var -> ident\n");}
      | ident L_SQUARE_BRACKET expression R_SQUARE_BRACKET {printf("var -> ident L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n" );}
      ;

ident: IDENT {printf("ident -> IDENT %s\n", $1);}

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

