%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#include "y.tab.h"
#include "tercetos.h"
#include "tercetos.c"
int yystopparser=0;
FILE *yyin;

#define TAM 35
#define VARIABLE_DUPLICADA 2
#define SIN_MEMORIA 3
#define ID_EN_LISTA 4

extern char * yytext;
int yyerror();
int yylex();
int fptr;
int eptr;
int tptr;
int sptr;
char varItoa[30];
char varString[30];
char varReal[30];
char fptrString[3];
char tptrString[3];
char eptrString[3];
char lptrString[3];
char AuxindString[3];
extern int yylineno;

typedef struct
	{
		char nombre[TAM];
		char tipodato[TAM];
		char valor[TAM];
		int longitud;
	}t_info;

	typedef struct s_nodo
	{
		t_info info;
		struct s_nodo *sSig;
	}t_nodo;

	typedef t_nodo *t_lista;
	char tipoDato[20];
	int contadorDeclVar;
	void insertarTipoDato(t_lista *pl, int *cant);
	
	typedef int (*t_cmp)(const void *, const void *);
	int comparar_por_nombre(const void *, const void *);

	void crear_lista(t_lista *p);
	int insertar_lista_orden_sin_duplicados(t_lista *l_ts, t_info *d, t_cmp);
	int buscar_en_lista(t_lista *pl, char* cadena );

	void generar_ts(t_lista *l_ts);
	int insertar_en_ts(t_lista *l_ts, t_info *d);

	void grabar_lista_en_archivo(t_lista *);
	void quitar_blancos_y_comillas(char *);
	void quitar_comillas(char *);

	t_lista lista_ts;
	t_info dato;

%}

%union {
	int int_val;
	float float_val;
	char *string_val;
}

%token DECVAR;
%token ENDDEC;
%token INTEGER;
%token FLOAT;
%token STRING;
%token <string_val>CONST_CADENA;
%token <int_val>CONST_ENTERA;
%token <float_val>CONST_FLOTANTE;
%token <string_val>ID;
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
%start programa
%%

programa:
	sentencias {escribir_tercetos();printf("Regla 0 - Programa es: sentencias\nCOMPILACION EXITOSA\n");};
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
    lista_variables OPERACION_TIPO tipo_variable {
		insertarTipoDato(&lista_ts, &contadorDeclVar);	
		printf("Regla 19 - declaracion es: lista_variables OPERACION_TIPO tipo_variable \n");};  
    ;
lista_variables:
    lista_variables COMA ID  {
								strcpy(dato.nombre, yylval.string_val);
								strcpy(dato.valor, "");
								strcpy(dato.tipodato, "");
								dato.longitud = 0;
								if( VARIABLE_DUPLICADA == insertar_en_ts(&lista_ts, &dato))
								{
									printf("Error semantico en linea %d: variable duplicada %s\n", yylineno, dato.nombre );
									system ("Pause");
									exit (1);
								}
								contadorDeclVar++;
								printf("Declaracion: %s\n",yylval.string_val );
								printf("Regla 20 - lista_variables es: lista_variables COMA ID \n");}
    | ID {
								strcpy(dato.nombre, yylval.string_val);
								strcpy(dato.valor, "");
								strcpy(dato.tipodato, "");
								dato.longitud = 0;
								if( VARIABLE_DUPLICADA == insertar_en_ts(&lista_ts, &dato))
								{
									printf("Error semantico en linea %d: variable duplicada %s\n", yylineno, dato.nombre );
									system ("Pause");
									exit (1);
								}
								contadorDeclVar=1;
								printf("Declaracion: %s\n",yylval.string_val);
								printf("Regla 21 - lista_variables es: ID \n");};
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
    READ ID {
		buscar_en_lista(&lista_ts, yylval.string_val);
		printf("Regla 25 - La entrada es: READ ID\n");}
    ;
salida:
    WRITE constante {
		buscar_en_lista(&lista_ts, yylval.string_val);
		printf("Regla 26 - La salida es: WRITE valor\n");}
    ;
condiciones:
    condicion operador_logico condicion  {printf("Regla 27 - condicion operador_logico condicion \n");};
    | condicion {printf("Regla 28 - CONDICION\n");};
	| NOT condicion {printf("Regla 29 - NOT CONDICION\n");};	
    ;
condicion:
    ID comparador constante {printf("Regla 30 - condicion es: ID comparador constante \n");};
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
    termino {
		eptr=tptr;
		printf("Regla 40 - expresion es: termino \n");
			};
    | expresion SUMA termino {
				itoa(eptr,eptrString,10);
				itoa(tptr,tptrString,10);
				tptr=crear_terceto("+",eptrString,tptrString);
				printf("Regla 41 - expresion es: expresion SUMA termino \n");
							};
    | expresion RESTA termino {
				itoa(eptr,eptrString,10);
				itoa(tptr,tptrString,10);
				tptr=crear_terceto("-",eptrString,tptrString);
				printf("Regla 42 - expresion es: expresion RESTA termino \n");
							};
    ;
termino:
    factor {
				tptr=fptr;
				printf("Regla 43 - termino es: factor \n");
			};
    | termino MULTI factor {
				itoa(tptr,tptrString,10);
				itoa(fptr,fptrString,10);
				tptr=crear_terceto("*",tptrString,fptrString);
				printf("Regla 44 - termino es: termino MULTI factor \n");
							};
    | termino DIVI factor {
				itoa(tptr,tptrString,10);
				itoa(fptr,fptrString,10);
				tptr=crear_terceto("/",tptrString,fptrString);
				printf("Regla 45 - termino es: termino DIVI factor \n");
							};
    ;
factor:
    ID  {
		char ultimoCaracter =$1[strlen($1)-1];
            if(ultimoCaracter == '+' || ultimoCaracter == '-' || ultimoCaracter == '*' || ultimoCaracter == '/'){
                $1[strlen($1)-1] = '\0'; //Remuevo el ultimo caracter que se lee de mas
            }
		buscar_en_lista(&lista_ts, yylval.string_val);
		fptr=crear_terceto(dato.valor,"_","_");
		printf("Regla 46 - factor es: ID \n");};
    | constante {printf("Regla 47 - factor es: constante \n");};
    | PAREN_ABIERTO expresion PAREN_CERRADO {printf("Regla 48 - factor es: PAREN_ABIERTO expresion PAREN_CERRADO  \n");};
    ;
constante:
    CONST_ENTERA  {	            
					strcpy(dato.nombre, yytext);
					strcpy(dato.valor, yytext);
					strcpy(dato.tipodato, "CONST_ENTERA");
					dato.longitud = 0;
					insertar_en_ts(&lista_ts, &dato);
					fptr=crear_terceto(dato.valor,"_","_");
					printf("Regla 49 - constante es: CONST_ENTERA \n");};
    | CONST_FLOTANTE {					
					strcpy(dato.nombre, yytext);
					strcpy(dato.valor, yytext);
					strcpy(dato.tipodato, "CONST_FLOTANTE");
					dato.longitud = 0;
					insertar_en_ts(&lista_ts, &dato);
					fptr=crear_terceto(dato.valor,"_","_");
					printf("Regla 50 - constante es: CONST_FLOTANTE \n");};
    | CONST_CADENA {
					
					dato.longitud = strlen(yytext)-2;
					strcpy(dato.nombre, yytext);
					quitar_blancos_y_comillas(yytext);
					strcpy(dato.valor, yytext);												
					strcpy(dato.tipodato, "CONST_CADENA");
					fptr=crear_terceto(dato.valor,"_","_");												
					insertar_en_ts(&lista_ts, &dato);															
					printf("Regla 51 - constante es: CONST_CADENA \n");};
    ;
tipo_variable:
    INTEGER {
		strcpy(tipoDato,"INTEGER");
		printf("Regla 52 - tipo_variable es: INTEGER \n");};
    | FLOAT {
		strcpy(tipoDato,"FLOAT");
		printf("Regla 53 - tipo_variable es: FLOAT \n");};
    | STRING {
		strcpy(tipoDato,"STRING");
		printf("Regla 54 - tipo_variable es: STRING \n");};
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
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
	generar_ts(&lista_ts);

	yyparse();

	grabar_lista_en_archivo(&lista_ts);
  	fclose(yyin);
  }
  return 0;
}

int yyerror(void)
{
   printf("Error sintactico.\n");
    exit(1);
}

void generar_ts(t_lista *l_ts){
    crear_lista(l_ts);

	printf("\n");
	printf("Creando la tabla de simbolos...\n");	
	printf("Tabla de simbolos creada\n");
}

void crear_lista(t_lista *p) {
    *p=NULL;
}

int insertar_en_ts(t_lista *l_ts, t_info *d) {
	insertar_lista_orden_sin_duplicados(l_ts, d, comparar_por_nombre);
}


int insertar_lista_orden_sin_duplicados(t_lista *pl, t_info *d, t_cmp comparar)
{
    int cmp;
    t_nodo *nuevo;
    while(*pl && (cmp=comparar(d, &(*pl)->info))!=0)
        pl=&(*pl)->sSig;
    if(*pl && cmp==0){
        return VARIABLE_DUPLICADA;
	}
    nuevo=(t_nodo*)malloc(sizeof(t_nodo));
    if(!nuevo)
        return SIN_MEMORIA;
    nuevo->info=*d;
    nuevo->sSig=*pl;
    *pl=nuevo;
    return 1;
}

// Inserta el tipo de dato de las variables declaradas, usa una variable global "char* tipoDato", para pasar el tipo de dato que corresponde.
void insertarTipoDato(t_lista *pl, int *cant)
{
	if( (*pl)->sSig != NULL )
        insertarTipoDato( &(*pl)->sSig , cant);
	if( (*cant) > 0)
	strcpy((*pl)->info.tipodato,tipoDato);
	(*cant)--;
}

int buscar_en_lista(t_lista *pl, char* cadena )
{
    int cmp;

    while(*pl && (cmp=strcmp(cadena,(*pl)->info.nombre))!=0)
        pl=&(*pl)->sSig;
    if(cmp==0)
	{
        return ID_EN_LISTA;
	}
	printf("\nVariable sin declarar: %s \n",cadena);
    exit(1);
}

int comparar_por_nombre(const void *d1, const void *d2)
{
    t_info *dato1=(t_info*)d1;
    t_info *dato2=(t_info*)d2;

    return strcmp(dato1->nombre, dato2->nombre);
}

void grabar_lista_en_archivo(t_lista *pl){
	FILE *pf;

	pf = fopen("ts.txt", "wt");

	// Cabecera
	fprintf(pf,"%-35s %-16s %-35s %-35s", "NOMBRE", "TIPO DE DATO", "VALOR", "LONGITUD");

	// Datos
	while(*pl) {
		fprintf(pf,"\n%-35s %-16s %-35s %-35d", (*pl)->info.nombre, (*pl)->info.tipodato, (*pl)->info.valor, (*pl)->info.longitud);
		pl=&(*pl)->sSig;
	}

	fclose(pf);
}

//quita los blancos por guiones bajos y elimina las comillas
void quitar_blancos_y_comillas(char *pc){

	quitar_comillas(pc);

	char *aux = pc;
	
	while(*aux != '\0'){
		if(*aux == ' '){
			*aux= '_';
		}
		aux++;
	}
}

void quitar_comillas(char *pc){

	// Cadena del tipo "" (sin nada)
	if(strlen(pc) == 2){
		*pc='\0';
	}
	else{
		*pc = *(pc+1);
		pc++;
		while(*(pc+1) != '"'){
			*pc = *(pc+1);		
			pc++;
		}
		*pc='\0';
	}	
}
