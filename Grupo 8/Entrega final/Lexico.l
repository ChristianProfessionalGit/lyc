%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"
FILE *yyin;
char *yyltext;

int yyerror1(void);

%}

%option noyywrap
%option yylineno

DIGITO [0-9]
LETRA [a-zA-Z]
COMEN_I "-/" 
COMEN_F "/-"

COMENTARIO {COMEN_I}.*{COMEN_F}
ID {LETRA}({DIGITO}|{LETRA})*
CONST_CADENA \"([^\"\\\\]|\\\\.)*\"
CONST_ENTERA {DIGITO}+
CONST_FLOTANTE {DIGITO}*\.({DIGITO}*|\.{DIGITO}+)
ASIGNACION "="
COMA ","
PUNTO_COMA ";"
OPERACION_TIPO ":"
SUMA "+"
RESTA "-"
MULTI "*"
DIVI "/"
PAREN_ABIERTO "("
PAREN_CERRADO ")"
CORCH_ABIERTO "["
CORCH_CERRADO "]"
LLAVE_ABIERTA "{"
LLAVE_CERRADA "}"
MENOR_IG "<="
MENOR "<"
MAYOR_IG ">="
MAYOR ">"
IGUAL "=="
DISTINTO "!="

%%

"DECVAR" {return DECVAR;}
"ENDDEC" {return ENDDEC;}

"WRITE" {return WRITE;}
"READ" {return READ;}

"AND" {return AND;}
"OR" {return OR;}
"NOT" {return NOT;}



"INTEGER"   		{               
                        return INTEGER;
                    }


"FLOAT"             {               
                        return FLOAT;
                    }

"STRING"  			{               
                        return STRING;
                    }

"IF" {return IF;}
"ENDIF" {return ENDIF;}

"WHILE" {return WHILE;}
"IN" {return IN;}
"ELSE" {return ELSE;}

"BETWEEN" {return BETWEEN;}
"TAKE"  {return TAKE;}

{CONST_CADENA}    {
                    if(strlen(yytext)>32){
                        printf("**ERROR LEXICO - La cadena %s supera la cota de 30 caracteres en la linea %d.\n",yytext, yylineno);
						exit(1);
                    }else{
						yylval.string_val = strdup(yytext);
                        return CONST_CADENA;
                    }
                    
                }
{CONST_ENTERA}    {
                    if(atoll(yytext)>2147483647){
						printf("**ERROR LEXICO - La constante entera %s supera su valor maximo en la linea %d.\n",yytext, yylineno);
						exit(1);
					}else{
						yylval.int_val = atoi(yytext);
						return CONST_ENTERA;
                    }
                    
                }

{CONST_FLOTANTE}  {
					if(atof(yytext)>3.40282347e+38F){
						printf("**ERROR LEXICO - La constante flotante %s supera su valor maximo en la linea %d.\n",yytext, yylineno);
						exit(1);
					}else{
						yylval.float_val = atof(yytext);
						return CONST_FLOTANTE;
					}
                }

{ID}            {
					if(strlen(yytext) > 30){
						printf("**ERROR LEXICO - La longitud variable %s supera su valor maximo (30) en la linea %d.\n",yytext, yylineno);
						exit(1);
					}else{
						yylval.string_val = strdup(yytext);
						return ID;
					}
                }
{ASIGNACION} {return ASIGNACION;}

{COMA} {
            return COMA;
        }
{PUNTO_COMA} {
            return PUNTO_COMA;
        }

{OPERACION_TIPO} {return OPERACION_TIPO;}
{COMENTARIO}
{SUMA} {return SUMA;}
{RESTA} {return RESTA;}
{DIVI} {return DIVI;}
{MULTI} {return MULTI;}
{PAREN_ABIERTO} {return PAREN_ABIERTO;}
{PAREN_CERRADO} {return PAREN_CERRADO;}
{CORCH_ABIERTO} {return CORCH_ABIERTO;}
{CORCH_CERRADO} {return CORCH_CERRADO;}
{LLAVE_ABIERTA} {return LLAVE_ABIERTA;}
{LLAVE_CERRADA} {return LLAVE_CERRADA;}
{MENOR_IG} {return MENOR_IG;}
{MENOR} {return MENOR;}
{MAYOR_IG} {return MAYOR_IG;}
{MAYOR} {return MAYOR;}
{IGUAL} {return IGUAL;}
{DISTINTO} {return DISTINTO;}


"\n"
"\t"
"\n\t"
"\r\n"
" "
. yyerrorl();
%%

int yyerrorl(void) {
    printf("Error lexico: Caracter invalido: %s", yytext);
    exit(1);
}
