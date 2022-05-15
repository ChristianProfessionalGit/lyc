%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
int yystopparser=0;
FILE *yyin;

int yyerror();
int yylex();
void generar_tabla_simbolos();
void cerrar_tabla_simbolos();

%}

%token DECVAR;
%token ENDDEC;
%token INTEGER;
%token FLOAT;
%token STRING;
%token CONST_CADENA;
%token CONST_ENTERA;
%token CONST_FLOTANTE;
%token ID;
%token VAR_NUMERICA;
%token ASIGNACION;
%token COMA;
%token PUNTO_COMA;
%token WRITE;
%token READ;
%token AND;
%token OR;
%token NOT;
%token OPERACION_TIPO;
%token PAREN_ABIERTO;
%token CORCH_ABIERTO;
%token PAREN_CERRADO;
%token CORCH_CERRADO;
%token MENOR_IG;
%token MENOR;
%token MAYOR_IG;
%token MAYOR;
%token DISTINTO;
%token LLAVE_ABIERTA;
%token LLAVE_CERRADA;
%token IGUAL;
%token IF;
%token SUMA;
%token RESTA;
%token DIVI;
%token MULTI;
%token WHILE;
%token IN;
%token ELSE;
%token ENDIF;
%token BETWEEN;
%token TAKE;

%%

programa:
	sentencias {printf("Regla 0 - Programa es: sentencias\nCOMPILACION EXITOSA\n");};
sentencias:
    sentencias declaracion_tipos {printf("Regla 1 - Sentencia es: sentencias declaracion_tipos \n");};
    | declaracion_tipos  {printf("Regla 2 - Sentencia es: declaracion_tipos \n");};
    | sentencias asignacion {printf("Regla 3 - Sentencia es: sentencias asignacion \n");};
    | asignacion {printf("Regla 4 - Sentencia es: asignacion\n");};
    | sentencias if {printf("Regla 5 - Sentencia es: sentencias if\n");};
    | if {printf("Regla 6 - Sentencia es: if \n");};
    | sentencias while {printf("Regla 7 - Sentencia es: sentencias while \n");};
    | while {printf("Regla 8 - Sentencia es: while\n");};
    | sentencias entrada {printf("Regla 9 - Sentencia es: sentencias entrada \n");};
    | entrada  {printf("Regla 10 - Sentencia es: entrada\n");};
    | sentencias salida {printf("Regla 11 - Sentencia es: sentencias salida\n");};
    | salida {printf("Regla 12 - Sentencia es: salida\n");};
    | sentencias take {printf("Regla 13 - Sentencia es: sentencias take\n");};
    | take {printf("Regla 14 - Sentencia es: take\n");};    
    ;
declaracion_tipos:
    DECVAR lista_declaracion_tipos ENDDEC {printf("Regla 15 - Declaracion tipos es: DECVAR Lista_declaracion_tipos ENDDEC\n");};
lista_declaracion_tipos:
    lista_declaraciones {printf("Regla 16 - Lista_declaracion_tipos es: lista_declaraciones\n");};     
lista_declaraciones:
    lista_declaraciones declaracion {printf("Regla 17 - lista_declaraciones es: lista_declaraciones declaracion\n");};  
    | declaracion  {printf("Regla 18 - lista_declaraciones es: declaracion\n");};  
    ;
declaracion:
    lista_variables OPERACION_TIPO tipo_variable {printf("Regla 19 - declaracion es: lista_variables OPERACION_TIPO tipo_variable \n");};  
    ;
lista_variables:
    lista_variables COMA ID  {printf("Regla 20 - lista_variables es: lista_variables COMA ID \n");};
    | ID {printf("Regla 21 - lista_variables es: ID \n");};
    ;
if:
    IF PAREN_ABIERTO condiciones PAREN_CERRADO LLAVE_ABIERTA sentencias LLAVE_CERRADA {printf("Regla 22 - IF es: IF PAREN_ABIERTO condiciones PAREN_CERRADO LLAVE_ABIERTA sentencias LLAVE_CERRADA \n");};
    ;
while:
    WHILE PAREN_ABIERTO condiciones PAREN_CERRADO LLAVE_ABIERTA sentencias LLAVE_CERRADA {printf("Regla 23 - While es: WHILE PAREN_ABIERTO condiciones PAREN_CERRADO LLAVE_ABIERTA sentencias LLAVE_CERRADA \n");};
    ;
asignacion:
    ID ASIGNACION expresion {printf("Regla 24 - ASIGNACION: ID = expresion\n");}    
    ;
entrada:
    READ ID {printf("Regla 25 - La entrada es: READ ID\n");}
    ;
salida:
    WRITE constante {printf("Regla 26 - La salida es: WRITE valor\n");}
    ;
condiciones:
    condicion operador_logico condicion  {printf("Regla 27 - condicion operador_logico condicion \n");};
    | condicion {printf("Regla 28 - CONDICION\n");};
    ;
condicion:
    ID comparador constante {printf("Regla 29 - condicion es: ID comparador constante \n");};
    | NOT ID {printf("Regla 30 - condicion es: NOT ID comparador constante \n");};
    | between {printf("Regla 31 - condicion es: between comparador constante \n");};
    ;
operador_logico:
    AND {printf("Regla 32 - operador_logico es: AND \n");};
    | OR {printf("Regla 33 - operador_logico es: OR \n");};
    ;
comparador:
    MENOR_IG {printf("Regla 34 - comparador es: MENOR_IG \n");};
    | MENOR {printf("Regla 35 - comparador es: MENOR \n");};
    | MAYOR_IG {printf("Regla 36 - comparador es: MAYOR_IG \n");};
    | MAYOR {printf("Regla 37 - comparador es: MAYOR \n");};
    | IGUAL {printf("Regla 38 - comparador es: IGUAL \n");};
    | DISTINTO {printf("Regla 39 - comparador es: DISTINTO \n");};
    ;
expresion:
    termino {printf("Regla 40 - expresion es: termino \n");};
    | expresion SUMA termino {printf("Regla 41 - expresion es: expresion SUMA termino \n");};
    | expresion RESTA termino {printf("Regla 42 - expresion es: expresion RESTA termino \n");};
    ;
termino:
    factor {printf("Regla 43 - termino es: factor \n");};
    | termino MULTI factor {printf("Regla 44 - termino es: termino MULTI factor \n");};
    | termino DIVI factor {printf("Regla 45 - termino es: termino DIVI factor \n");};
    ;
factor:
    ID  {printf("Regla 46 - factor es: ID \n");};
    | constante {printf("Regla 47 - factor es: constante \n");};
    | PAREN_ABIERTO expresion PAREN_CERRADO {printf("Regla 48 - factor es: PAREN_ABIERTO expresion PAREN_CERRADO  \n");};
    ;
constante:
    CONST_ENTERA  {printf("Regla 49 - constante es: CONST_ENTERA \n");};
    | CONST_FLOTANTE {printf("Regla 50 - constante es: CONST_FLOTANTE \n");};
    | CONST_CADENA {printf("Regla 51 - constante es: CONST_CADENA \n");};
    ;
tipo_variable:
    INTEGER {printf("Regla 52 - tipo_variable es: INTEGER \n");};
    | FLOAT {printf("Regla 53 - tipo_variable es: FLOAT \n");};
    | STRING {printf("Regla 54 - tipo_variable es: STRING \n");};
    ;
valor:
    ID STRING {printf("Regla 55 - valor es: ID STRING \n");};
    | CONST_CADENA STRING {printf("Regla 56 - valor es: CONST_CADENA STRING \n");};
    ;
between:
    BETWEEN PAREN_ABIERTO factor COMA CORCH_ABIERTO expresion PUNTO_COMA expresion CORCH_CERRADO PAREN_CERRADO {printf("Regla 57 - BETWEEN es: BETWEEN PAREN_ABIERTO factor COMA CORCH_ABIERTO expresion PUNTO_COMA expresion CORCH_CERRADO PAREN_CERRADO \n");}
    ;
lista_constantes:
    lista_constantes PUNTO_COMA CONST_ENTERA {printf("Regla 58 - lista_constantes es: lista_constantes PUNTO_COMA CONST_ENTERA \n");};
    | CONST_ENTERA {printf("Regla 58 - lista_constantes es:CONST_ENTERA \n");};
    ;
operadores:
    SUMA {printf("Regla 59 - operadores es:SUMA \n");};
    | RESTA {printf("Regla 60 - operadores es:RESTA \n");};
    | MULTI {printf("Regla 61 - operadores es:MULTI \n");};
    | DIVI {printf("Regla 62 - operadores es:DIVI \n");};
    ;
take:
    TAKE PAREN_ABIERTO operadores PUNTO_COMA factor PUNTO_COMA CORCH_ABIERTO lista_constantes CORCH_CERRADO PAREN_CERRADO {printf("Regla 63 - TAKE es:PAREN_ABIERTO operadores PUNTO_COMA factor PUNTO_COMA CORCH_ABIERTO lista_constantes CORCH_CERRADO PAREN_CERRADO \n");}
    ;

%%

int main(int argc, char *argv[])
{
    if((yyin = fopen(argv[1], "rt"))==NULL)
    {
        printf("\nNo se pudo abrir el archivo de prueba: %s\n",argv[1]);
    }
    else
    {
        generar_tabla_simbolos();
        yyparse();
        cerrar_tabla_simbolos();
    }
    fclose(yyin);
    return 0;
}

int yyerror(void)
{
   printf("Error sintactico.\n");
    exit(1);
}

void generar_tabla_simbolos(){
    FILE *f = fopen("ts.txt", "w");
    if (f == NULL)
    {
        printf("Error opening file!\n");
        exit(1);
    }

    /* print some text */
    fprintf(f, "Nombre    Tipo Dato    Valor    Longitud\n");
}

void cerrar_tabla_simbolos(){
    FILE *f = fopen("ts.txt", "a");
    if (f == NULL)
    {
        printf("Error opening file!\n");
        exit(1);
    }

    fclose(f);
}