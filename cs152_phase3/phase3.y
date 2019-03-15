/* calculator. */
%{
    #include <iostream>
    #include <fstream>
    #include <stdio.h>
    #include <stdlib.h>
    #include <string>
    #include <cstring>
    #include <map>
    #include <vector>
    using namespace std;

    void yyerror(const char *msg);
    int yylex();
    ofstream myfile;
    extern int currLine;
    extern int currPos;
    extern FILE * yyin;
    int tempID = 0;
    string newTemp();
%}

%union{
   int num_val;
   char* ident_val;
    struct nonterm {
        char* place;
        char* code;
   } nonterm;
}

%error-verbose
%start program
%token FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE RETURN SUB ADD MULT DIV MOD EQ NEQ LT GT LTE GTE SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN
%token IDENT NUMBER
%type <num_val> NUMBER
%type <ident_val> IDENT
%type <nonterm> program function statements declarations declaration identifiers arrays statement state_b vars bool_exp bool_exp2 and_exp and_exp2 relation relation2 comp expression expression2 mult_exp mult_exp2 term term2 term3 term4 var ident

%% 
program:    function program {
                std::string temp = "";
                //temp.append($1.code);
                //temp.append($2.code);
                //$$.code = &temp[0u];
            }
            | {
                //printf("%s", $$.code);
            }
            ;

function:   FUNCTION ident SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY {
            //    std::string temp = "func ";
            //    temp.append($2.code);
            //    temp += "\n";
            //    temp.append($5.code);
            //    temp.append($8.code);
            //    //temp.append($10.code); //change
            //    $$.code = &temp[0u];
            }
            ;

statements: statement SEMICOLON statements {
                // std::string temp = "";
                // temp.append($1.code);
                // temp.append($3.code);
                // temp += "\n";//might need to remove
                // $$.code = &temp[0u];
            }
            | statement SEMICOLON {
                // std::string temp = "";
                // temp.append($$.code);
                // temp.append($1.code);
                // $$.code = &temp[0u];
            }
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
      | var {}
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

mult_exp:   term mult_exp2 {

            }
            ;

mult_exp2:  MULT term mult_exp2 {
                // std::string temp = "";
                // temp.append($2.code);
                // temp.append($3.code);
                // $$.code = &temp[0u];
                //printf("mult_exp2 -> MULT term mult_exp2\n");
            }
            | DIV term mult_exp2 {
                // std::string temp = "";
                // temp.append($2.code);
                // temp.append($3.code);
                // $$.code = &temp[0u];
                //printf("mult_exp2 -> DIV term mult_exp2\n");
            }
            | MOD term mult_exp2 {
                // std::string temp = "";
                // temp.append($2.code);
                // temp.append($3.code);
                // $$.code = &temp[0u];
                //printf("mult_exp2 -> MOD term mult_exp2\n");
            }
            | {
                strcpy($$.code, "");
            }
            ;

term:    SUB term2 {
            strcpy($$.code, $2.code);
         }
         | term2 {
            strcpy($$.code, $1.code);
            }
         | term3 {
             strcpy($$.code, $1.code);
             }
         ;

term2:  var {
            strcpy($$.code, $1.code);
            //printf("term2 -> var\n");
        }
        | NUMBER {
            string temp = ". ";
            temp.append(std::to_string($1));
            temp += "\n";
            $$.code = &temp[0u];
            //printf("term2 -> NUMBER %d\n", $1);
        }
        | L_PAREN expression R_PAREN {
            string temp = "";
            temp.append($2.code);
            $$.code = &temp[0u];
            //printf("term2 -> L_PAREN expression R_PAREN\n");
        }
        ;

term3:  ident L_PAREN term4 R_PAREN {
            //string nplace = newTemp();
            $$.place = &newTemp()[0u];
            string ncode = "";
            ncode.append($3.code);
            ncode.append(". ");
            ncode.append($$.place);
            ncode.append("/n");
            ncode.append("call ");
            ncode.append($1.place);
            ncode.append($$.place);
            ncode.append("\n");
            
            //printf("term3 -> ident L_PAREN term4 R_PAREN\n");
        }
        ;

term4:  expression {
            string nplace, ncode = "";
            ncode.append($1.code);
            ncode.append("param ");
            ncode.append($1.place);
            ncode.append("\n");
            $$.place = &nplace[0u];
            $$.code = &ncode[0u];
        }
        | expression COMMA term4 {
            string nplace, ncode = "";
            ncode.append($1.code);
            ncode.append("param ");
            ncode.append($1.place);
            ncode.append("\n");
            ncode.append($3.code);
            $$.place = &nplace[0u];
            $$.code = &ncode[0u];
        }
        | {
            strcpy($$.code, "");
            strcpy($$.place, "");
        }
        ;

var:    ident { 
            strcpy($$.place, $1.place);
            strcpy($$.code, $1.code);
            //Check if array?
        }
        | ident L_SQUARE_BRACKET expression R_SQUARE_BRACKET {
            string ncode = "";
            $$.place = &newTemp()[0u];
            
            //temp.append($1.code);
            //temp += ", ";
            nplace.append($3.place);
            $$.code = &ncode[0u];
            $$.place = &newTemp()[0u];
        }
        ;

ident:  IDENT {
            strcpy($$.place, $1);
            strcpy($$.code, "");
        }

%%

string newTemp()
{
    string temp = "__temp__";
    temp += to_string(tempID);
    return temp;
}

int main(int argc, char **argv) {
    myfile.open("output.mil");
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (yyin == NULL){
            printf("syntax: %s filename\n", argv[0]);
        }//end if
    }//end if
    yyparse(); // Calls yylex() for tokens.
    myfile.close();
    return 0;
}

void yyerror(const char *msg) {
   printf("** Line %d, position %d: %s\n", currLine, currPos, msg);
}

