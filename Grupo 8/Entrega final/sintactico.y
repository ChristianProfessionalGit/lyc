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
#include "assembler.h"
#include "assembler.c"
#include "PilaPrimitivaDinamica.h"
#include "PilaPrimitivaDinamica.c"
int yystopparser=0;
FILE *yyin;



extern char * yytext;
int yyerror();
int yylex();
int find;
int eind;
int tind;
int aind;
int sind;
int lind;
int bind;
int auxEind;
int auxTind;
int auxCont = 0;
int auxExp1;
int auxExp2;
char varItoa[30];
char varString[30];
char varReal[30];
char varComparador[4];
char varOperador[4];
char opindString[3];
char findString[3];
char tindString[3];
char eindString[3];
char lindString[3];
char bindString[3];
char auxEindString[3];
char aux[4];
extern int yylineno;


	typedef struct {
		char valor[4];
	}t_contantes;
	
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
	t_pilaD pilaIf;
	t_pilaD pilaWhile;
	t_pilaD pilaTake;
	t_pilaD pilaBetween;
	t_datoS datoPilaIf;
	t_datoS datoPilaWhile;
	t_datoS datoPilaTake;
	t_datoS datoPilaBetween;

	t_contantes contantes[100];

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
	sentencias {escribir_tercetos();generarAssembler(&lista_ts);printf("Regla 0 - Programa es: sentencias\nCOMPILACION EXITOSA\n");};
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
    IF PAREN_ABIERTO condiciones PAREN_CERRADO LLAVE_ABIERTA
		{
			t_datoS aux;
			if(strcmp(varOperador,"OR")==0){
				desapilarD(&pilaIf,&aux);
				desapilarD(&pilaIf,&datoPilaIf);
				if(apilarD(&pilaIf,&aux)==NO_HAY_MEMORIA){
					printf("No hay memoria para insertar un elemento en la pila\n");
					exit(1);
				}
				char valorActual[4];
				char varAux[10];
				int num;
				itoa( obtenerIndiceTercetos(),valorActual,10);
				strcpy(varAux,"ETIQ_");
				strcat(varAux,valorActual);
				num=crear_terceto(varAux,"_","_");
				strcpy(varAux,"[");
				itoa(num,valorActual,10);
				strcat(varAux,valorActual);
				strcat(varAux,"]");
				strcpy(vector_tercetos[datoPilaIf.nro_terceto].atr2,varAux);
				strcpy(varComparador,vector_tercetos[datoPilaIf.nro_terceto].atr1);
				 /*Reescribo el terceto cambiando el comparador por su opuesto*/
                                    
                char contrarioDelComparador[4];
				
                if (strcmp(varComparador, "BLT") == 0) 
                {
                    strcpy(contrarioDelComparador,"BGE");
                } 
                else if (strcmp(varComparador, "BLE") == 0)
                {
                    strcpy(contrarioDelComparador,"BGT");
                }
                else if (strcmp(varComparador, "BGT") == 0)
                {
                    strcpy(contrarioDelComparador,"BLE");
                }
                else if (strcmp(varComparador, "BGE") == 0)
                {
                    strcpy(contrarioDelComparador,"BLT");
                }
				else if (strcmp(varComparador, "BNE") == 0)
                {
                    strcpy(contrarioDelComparador,"BEQ");
                }
                else if (strcmp(varComparador, "BEQ") == 0)
                {
                	strcpy(contrarioDelComparador,"BNE");
                }
                
                strcpy(vector_tercetos[datoPilaIf.nro_terceto].atr1,contrarioDelComparador);
                                    
			}
		}
	 sentencias LLAVE_CERRADA {
		while(!pilaVacia(&pilaIf)){
			desapilarD(&pilaIf,&datoPilaIf);		
			char valorActual[3];
			char varAux[10];
			int num;
			itoa( obtenerIndiceTercetos(),valorActual,10);
			strcpy(varAux,"ETIQ_");
			strcat(varAux,valorActual);
			num=crear_terceto(varAux,"_","_");
			strcpy(varAux,"[");
			itoa(num,valorActual,10);
			strcat(varAux,valorActual);
			strcat(varAux,"]");			
			strcpy(vector_tercetos[datoPilaIf.nro_terceto].atr2,varAux);
		}
		printf("Regla 22 - IF es: IF PAREN_ABIERTO condiciones PAREN_CERRADO LLAVE_ABIERTA sentencias LLAVE_CERRADA \n");
		};
    ;
while:
    WHILE PAREN_ABIERTO {
		int num_terceto=crear_terceto("While","_","_");
		datoPilaWhile.nro_terceto=num_terceto;
		if(apilarD(&pilaWhile,&datoPilaWhile)==NO_HAY_MEMORIA){
					printf("No hay memoria para insertar un elemento en la pila\n");
					exit(1);
		}
	}
	 condiciones PAREN_CERRADO LLAVE_ABIERTA
	  {
			t_datoS aux;
			if(strcmp(varOperador,"OR")==0){
				desapilarD(&pilaIf,&aux);
				desapilarD(&pilaIf,&datoPilaIf);
				if(apilarD(&pilaIf,&aux)==NO_HAY_MEMORIA){
					printf("No hay memoria para insertar un elemento en la pila\n");
					exit(1);
				}
				char valorActual[3];
				char varAux[10];
				int num;
				itoa( obtenerIndiceTercetos(),valorActual,10);
				strcpy(varAux,"ETIQ_");
				strcat(varAux,valorActual);
				num=crear_terceto(varAux,"_","_");
				strcpy(varAux,"[");
				itoa(num,valorActual,10);
				strcat(varAux,valorActual);
				strcat(varAux,"]");				
				strcpy(vector_tercetos[datoPilaIf.nro_terceto].atr2,varAux);
				strcpy(varComparador,vector_tercetos[datoPilaIf.nro_terceto].atr1);
				 /*Reescribo el terceto cambiando el comparador por su opuesto*/
                                    
                char contrarioDelComparador[4];
				
                if (strcmp(varComparador, "BLT") == 0) 
                {
                    strcpy(contrarioDelComparador,"BGE");
                } 
                else if (strcmp(varComparador, "BLE") == 0)
                {
                    strcpy(contrarioDelComparador,"BGT");
                }
                else if (strcmp(varComparador, "BGT") == 0)
                {
                    strcpy(contrarioDelComparador,"BLE");
                }
                else if (strcmp(varComparador, "BGE") == 0)
                {
                    strcpy(contrarioDelComparador,"BLT");
                }
				else if (strcmp(varComparador, "BNE") == 0)
                {
                    strcpy(contrarioDelComparador,"BEQ");
                }
                else if (strcmp(varComparador, "BEQ") == 0)
                {
                	strcpy(contrarioDelComparador,"BNE");
                }
                
                strcpy(vector_tercetos[datoPilaIf.nro_terceto].atr1,contrarioDelComparador);
                                    
			}
		}
	  sentencias LLAVE_CERRADA {
		int num_terceto=crear_terceto("BI","_","_");
		char valorActual[3];
		char varAux[10];
		int num;
		while(!pilaVacia(&pilaIf)){
			desapilarD(&pilaIf,&datoPilaIf);
			itoa( obtenerIndiceTercetos(),valorActual,10);
			strcpy(varAux,"ETIQ_");
			strcat(varAux,valorActual);
			num=crear_terceto(varAux,"_","_");
			strcpy(varAux,"[");
			itoa(num,valorActual,10);
			strcat(varAux,valorActual);
			strcat(varAux,"]");				
			strcpy(vector_tercetos[datoPilaIf.nro_terceto].atr2,varAux);
		}
		if(desapilarD(&pilaWhile,&datoPilaWhile)==PILA_VACIA){
			printf("No hay elementos en la pila\n");
			exit(1);
		}
	    strcpy(varAux,"[");
		itoa(datoPilaWhile.nro_terceto,valorActual,10);
		strcat(varAux,valorActual);
		strcat(varAux,"]");		
		strcpy(vector_tercetos[num_terceto].atr2,varAux);
		 printf("Regla 23 - While es: WHILE PAREN_ABIERTO condiciones PAREN_CERRADO LLAVE_ABIERTA sentencias LLAVE_CERRADA \n");
		 };
    ;
asignacion:
    ID ASIGNACION expresion {
		buscar_en_lista(&lista_ts, $1);
		itoa(eind,eindString,10);
		char varAux[10];
		strcpy(varAux,"[");				
		strcat(varAux,eindString);
		strcat(varAux,"]");
		aind=crear_terceto("=",$1,varAux);
		printf("Regla 24 - ASIGNACION: ID = expresion\n");
							}    
    ;
entrada:
    READ ID {
		buscar_en_lista(&lista_ts, yylval.string_val);
		crear_terceto("READ",yylval.string_val,"_");
		printf("Regla 25 - La entrada es: READ ID\n");}
    ;
salida:
    WRITE CONST_CADENA {
		dato.longitud = strlen(yytext)-2;
		strcpy(dato.valor, yytext);
		quitar_blancos_y_comillas(yytext);
		strcpy(dato.nombre, yytext);												
		strcpy(dato.tipodato, "CONST_CADENA");
		crear_terceto("WRITE",dato.nombre,"_");
		insertar_en_ts(&lista_ts, &dato);
		printf("Regla 26 - La salida es: WRITE CONST_CADENA\n");};
	| WRITE ID {
		buscar_en_lista(&lista_ts, yylval.string_val);
		crear_terceto("WRITE",yylval.string_val,"_");
		printf("Regla 26 - La salida es: WRITE ID\n");
	}
    ;
condiciones:
    condicion operador_logico condicion  {printf("Regla 27 - condicion operador_logico condicion \n");};
    | condicion {printf("Regla 28 - CONDICION\n");};
	| NOT condicion {
		if(desapilarD(&pilaIf,&datoPilaIf)==PILA_VACIA){
			printf("No hay elementos en la pila\n");
			exit(1);
		}
		strcpy(varComparador,vector_tercetos[datoPilaIf.nro_terceto].atr1);
		/*Reescribo el terceto cambiando el comparador por su opuesto*/
                                    
                char contrarioDelComparador[4];
				
                if (strcmp(varComparador, "BLT") == 0) 
                {
                    strcpy(contrarioDelComparador,"BGE");
                } 
                else if (strcmp(varComparador, "BLE") == 0)
                {
                    strcpy(contrarioDelComparador,"BGT");
                }
                else if (strcmp(varComparador, "BGT") == 0)
                {
                    strcpy(contrarioDelComparador,"BLE");
                }
                else if (strcmp(varComparador, "BGE") == 0)
                {
                    strcpy(contrarioDelComparador,"BLT");
                }
				else if (strcmp(varComparador, "BNE") == 0)
                {
                    strcpy(contrarioDelComparador,"BEQ");
                }
                else if (strcmp(varComparador, "BEQ") == 0)
                {
                	strcpy(contrarioDelComparador,"BNE");
                }
                
                strcpy(vector_tercetos[datoPilaIf.nro_terceto].atr1,contrarioDelComparador);
				if(apilarD(&pilaIf,&datoPilaIf)==NO_HAY_MEMORIA){
					printf("No hay memoria para insertar un elemento en la pila\n");
					exit(1);
				}
		printf("Regla 29 - NOT CONDICION\n");
		};	
    ;
condicion:
    ID comparador constante {
		buscar_en_lista(&lista_ts, $1);
		itoa(find,findString,10);
		char varAux[10];
		strcpy(varAux,"[");				
		strcat(varAux,findString);
		strcat(varAux,"]");
		crear_terceto("CMP",$1,varAux);
		int num_terceto=crear_terceto(varComparador,"_","_");
		datoPilaIf.nro_terceto=num_terceto;
		if(apilarD(&pilaIf,&datoPilaIf)==NO_HAY_MEMORIA){
			printf("No hay memoria para insertar un elemento en la pila\n");
			exit(1);
		}
		printf("Regla 30 - condicion es: ID comparador constante \n");
		};
    | between {printf("Regla 31 - condicion es: between comparador constante \n");};
    ;
operador_logico:
    AND {
		strcpy(varOperador,"AND");
		printf("Regla 32 - operador_logico es: AND \n");
		};
    | OR {
		strcpy(varOperador,"OR");
		printf("Regla 33 - operador_logico es: OR \n");
		};
    ;
comparador:
    MENOR_IG {
		
		strcpy(varComparador,"BGT");
		printf("Regla 34 - comparador es: MENOR_IG \n");
		};
    | MENOR {
		
		strcpy(varComparador,"BGE");
		printf("Regla 35 - comparador es: MENOR \n");
		};
    | MAYOR_IG {
		
		strcpy(varComparador,"BLT");
		printf("Regla 36 - comparador es: MAYOR_IG \n");
		};
    | MAYOR {
		
		strcpy(varComparador,"BLE");
		printf("Regla 37 - comparador es: MAYOR \n");
		};
    | IGUAL {
		
		strcpy(varComparador,"BNE");
		printf("Regla 38 - comparador es: IGUAL \n");
		};
    | DISTINTO {
		
		strcpy(varComparador,"BEQ");
		printf("Regla 39 - comparador es: DISTINTO \n");
		};
    ;
expresion:
    termino {
		eind=tind;
		printf("Regla 40 - expresion es: termino \n");
			};
    | expresion SUMA termino {
				itoa(eind,eindString,10);
				itoa(tind,tindString,10);
				char varAux[10],varAux2[10];
				strcpy(varAux,"[");				
				strcat(varAux,eindString);
				strcat(varAux,"]");
				strcpy(varAux2,"[");				
				strcat(varAux2,tindString);
				strcat(varAux2,"]");
				eind=crear_terceto("+",varAux,varAux2);
				printf("Regla 41 - expresion es: expresion SUMA termino \n");
							};
    | expresion RESTA termino {
				itoa(eind,eindString,10);
				itoa(tind,tindString,10);
				char varAux[10],varAux2[10];
				strcpy(varAux,"[");				
				strcat(varAux,eindString);
				strcat(varAux,"]");
				strcpy(varAux2,"[");				
				strcat(varAux2,tindString);
				strcat(varAux2,"]");
				eind=crear_terceto("-",varAux,varAux2);
				printf("Regla 42 - expresion es: expresion RESTA termino \n");
							};
    ;
termino:
    factor {
				tind=find;
				printf("Regla 43 - termino es: factor \n");
			};
    | termino MULTI factor {
				itoa(tind,tindString,10);
				itoa(find,findString,10);
				char varAux[10],varAux2[10];
				strcpy(varAux,"[");				
				strcat(varAux,tindString);
				strcat(varAux,"]");
				strcpy(varAux2,"[");				
				strcat(varAux2,findString);
				strcat(varAux2,"]");
				tind=crear_terceto("*",varAux,varAux2);
				printf("Regla 44 - termino es: termino MULTI factor \n");
							};
    | termino DIVI factor {
				itoa(tind,tindString,10);
				itoa(find,findString,10);
				char varAux[10],varAux2[10];
				strcpy(varAux,"[");				
				strcat(varAux,tindString);
				strcat(varAux,"]");
				strcpy(varAux2,"[");				
				strcat(varAux2,findString);
				strcat(varAux2,"]");
				tind=crear_terceto("/",varAux,varAux2);
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
		find=crear_terceto(yylval.string_val,"_","_");
		printf("Regla 46 - factor es: ID \n");};
    | constante {printf("Regla 47 - factor es: constante \n");};
    | PAREN_ABIERTO {auxEind=eind;auxTind=tind;} expresion PAREN_CERRADO {find=eind;eind=auxEind;tind=auxTind;printf("Regla 48 - factor es: PAREN_ABIERTO expresion PAREN_CERRADO  \n");};
    ;
constante:
    CONST_ENTERA  {	            
					strcpy(dato.nombre, yytext);
					strcpy(dato.valor, yytext);
					strcpy(dato.tipodato, "CONST_ENTERA");
					dato.longitud = 0;
					insertar_en_ts(&lista_ts, &dato);					
					find=crear_terceto(dato.valor,"_","_");
					printf("Regla 49 - constante es: CONST_ENTERA \n");};
    | CONST_FLOTANTE {					
					strcpy(dato.nombre, yytext);
					strcpy(dato.valor, yytext);
					strcpy(dato.tipodato, "CONST_FLOTANTE");
					dato.longitud = 0;
					insertar_en_ts(&lista_ts, &dato);
					find=crear_terceto(dato.valor,"_","_");
					printf("Regla 50 - constante es: CONST_FLOTANTE \n");};
    | CONST_CADENA {
					
					dato.longitud = strlen(yytext)-2;
					strcpy(dato.valor, yytext);
					quitar_blancos_y_comillas(yytext);
					strcpy(dato.nombre, yytext);												
					strcpy(dato.tipodato, "CONST_CADENA");
					find=crear_terceto(dato.nombre,"_","_");												
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
    BETWEEN PAREN_ABIERTO ID {strcpy(aux,yytext);} COMA CORCH_ABIERTO expresion {
		auxExp1=eind;
		char expString[4];
		char valorActual[4];
		char varAux[10];
		strcpy(varAux,"[");
		itoa(auxExp1,expString,10);
		strcat(varAux,expString);
		strcat(varAux,"]");
		crear_terceto("=","@expresion1",varAux);
	} PUNTO_COMA expresion {
		auxExp2=eind;
		char expString[4];
		char valorActual[4];
		char varAux[10];
		strcpy(varAux,"[");
		itoa(auxExp2,expString,10);
		strcat(varAux,expString);
		strcat(varAux,"]");
		crear_terceto("=","@expresion2",varAux);
	} CORCH_CERRADO PAREN_CERRADO {
		crear_terceto("BETWEEN","_","_");
		bind=crear_terceto("=","@resultado","0");
		int num;
		char expString[4];
		char valorActual[4];
		char varAux[10];	
		
		crear_terceto("CMP",aux,"@expresion1");
		num=crear_terceto("BLT","_","_");
		datoPilaBetween.nro_terceto=num;
		if(apilarD(&pilaBetween,&datoPilaBetween)==NO_HAY_MEMORIA){
			printf("No hay memoria para insertar un elemento en la pila del between\n");
			exit(1);
		}
		
		crear_terceto("CMP",aux,"@expresion2");
		num=crear_terceto("BGT","_","_");
		datoPilaBetween.nro_terceto=num;
		if(apilarD(&pilaBetween,&datoPilaBetween)==NO_HAY_MEMORIA){
			printf("No hay memoria para insertar un elemento en la pila del between\n");
			exit(1);
		}
		bind=crear_terceto("=","@resultado","1");
		
		itoa( obtenerIndiceTercetos(),valorActual,10);
		strcpy(varAux,"ETIQ_");
		strcat(varAux,valorActual);
		num=crear_terceto(varAux,"_","_");
		while(!pilaVacia(&pilaBetween)){
			desapilarD(&pilaBetween,&datoPilaBetween);
			
			strcpy(varAux,"[");
			itoa(num,valorActual,10);
			strcat(varAux,valorActual);
			strcat(varAux,"]");
			strcpy(vector_tercetos[datoPilaBetween.nro_terceto].atr2,varAux);			
		}
		crear_terceto("CMP","@resultado","1");
		num=crear_terceto("BNE","_","_");
		datoPilaIf.nro_terceto=num;
		if(apilarD(&pilaIf,&datoPilaIf)==NO_HAY_MEMORIA){
			printf("No hay memoria para insertar un elemento en la pila del if\n");
			exit(1);
		}
		printf("Regla 57 - BETWEEN es: BETWEEN PAREN_ABIERTO factor COMA CORCH_ABIERTO expresion PUNTO_COMA expresion CORCH_CERRADO PAREN_CERRADO \n");
		}
    ;
lista_constantes:
	lista_constantes_llena ;
	| CORCH_ABIERTO {printf("Regla 58 - lista_constantes es: vacia \n");};
	;
lista_constantes_llena:
    lista_constantes_llena PUNTO_COMA CONST_ENTERA {
		
		strcpy(contantes[auxCont].valor,yytext);	
		auxCont++;	
		printf("Regla 58 - lista_constantes es: lista_constantes PUNTO_COMA CONST_ENTERA \n");
		};
    | CORCH_ABIERTO CONST_ENTERA {
		
		strcpy(contantes[auxCont].valor,yytext);	
		
		auxCont++;	
		printf("Regla 58 - lista_constantes es:CONST_ENTERA \n");
		};	
    ;
operadores:
    SUMA {
		strcpy(opindString,"+");
		printf("Regla 59 - operadores es:SUMA \n");
		};
    | RESTA {
		strcpy(opindString,"-");
		printf("Regla 60 - operadores es:RESTA \n");
		};
    | MULTI {
		strcpy(opindString,"*");
		printf("Regla 61 - operadores es:MULTI \n");
	};
    | DIVI {
		strcpy(opindString,"/");
		printf("Regla 62 - operadores es:DIVI \n");
	};
    ;
take:
    TAKE PAREN_ABIERTO operadores PUNTO_COMA CONST_ENTERA {strcpy(aux,yytext);} PUNTO_COMA lista_constantes CORCH_CERRADO PAREN_CERRADO {
		
		
		int resultado,i,elementos;		
	    elementos=atoi(aux);
		char varAux[10];
		crear_terceto("TAKE","_","_");		
		if(auxCont == 0 ){
			
			lind=crear_terceto("=","@resultado","0");
			strcpy(varAux,"[");
			itoa(lind,lindString,10);
			strcat(varAux,lindString);
			strcat(varAux,"]");
			crear_terceto("WRITE","@resultado","_");
		}
		else if( auxCont >= elementos ){
			
			lind=crear_terceto(contantes[0].valor,"_","_");		
			
			if(elementos > 1){
				for(i=1;i<elementos;i++){
					strcpy(varAux,"[");
					itoa(lind,lindString,10);
					strcat(varAux,lindString);
					strcat(varAux,"]");					
					lind=crear_terceto(opindString,varAux,contantes[i].valor);
				}				
			}
			strcpy(varAux,"[");
			itoa(lind,lindString,10);
			strcat(varAux,lindString);
			strcat(varAux,"]");	
			lind=crear_terceto("=","@resultado",varAux);
			strcpy(varAux,"[");
			itoa(lind,lindString,10);
			strcat(varAux,lindString);
			strcat(varAux,"]");	
			crear_terceto("WRITE","@resultado","_");
		}
		else{
			
			crear_terceto("WRITE","ERROR","_");
		}
		auxCont=0;
		
		printf("Regla 63 - TAKE es:PAREN_ABIERTO operadores PUNTO_COMA CONST_ENTERA PUNTO_COMA CORCH_ABIERTO lista_constantes CORCH_CERRADO PAREN_CERRADO \n");
		
		}
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
	crearPila(&pilaIf);
	crearPila(&pilaWhile);
	crearPila(&pilaBetween);
	crearPila(&pilaTake);
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
