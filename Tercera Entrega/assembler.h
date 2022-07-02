#ifndef ASSEMBLER_H
#define ASSEMBLER_H

#define TAM 35
#define VARIABLE_DUPLICADA 2
#define SIN_MEMORIA 3
#define ID_EN_LISTA 4
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


void generarAssembler(t_lista*);
void escribir_datos(FILE*,t_lista*);
void escribir_codigo(FILE*);



#endif