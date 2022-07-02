#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <conio.h>

#include "assembler.h"
#include "tercetos.h"

void generarAssembler(t_lista* tabla)
{
    
    FILE *archivo;

    if((archivo = fopen("Final.asm", "w"))==NULL){
        printf("No se puede crear el archivo \"Final.asm\"\n");
        exit(1);
    }

    fprintf(archivo, "include macros2.asm\ninclude number.asm\n.MODEL LARGE\n.386\n.STACK 200h\n\n.DATA\n");

    escribir_datos(archivo,tabla);

    fprintf(archivo, "\n.CODE\n\nSTART:\n\nMOV AX,@DATA\nMOV DS, AX\nMOV ES, AX\n\n");

    //escribir_codigo(archivo);

    fprintf(archivo, "MOV EAX, 4C00h\nINT 21h\n\nEND START\n");

    fclose(archivo);
}

void escribir_datos(FILE* assembler,t_lista* tabla){
    char linea[100];

    char aux[50];
    while(*tabla){
        
            printf("Leamos la tabla %s\n",(*tabla)->info.tipodato);
            if(strcmp((*tabla)->info.tipodato,"INTEGER")==0 || strcmp((*tabla)->info.tipodato,"FLOAT")==0 || strcmp((*tabla)->info.tipodato,"STRING")==0){
                 sprintf(linea, "%s dd ?\n", (*tabla)->info.nombre);
            }
            else if(strcmp((*tabla)->info.tipodato,"CONST_ENTERA")==0 || strcmp((*tabla)->info.tipodato,"CONST_FLOTANTE")==0)
            {
                strcpy(aux,(*tabla)->info.valor);
                if(strcmp((*tabla)->info.tipodato,"CONST_ENTERA")==0){                    
                    strcat(aux,".0");
                }
                sprintf(linea, "_%s dd %s\n", (*tabla)->info.nombre,aux);
            }
            else if(strcmp((*tabla)->info.tipodato,"CONST_CADENA")==0){
                sprintf(linea, "_%s db %s , '$', %d dup (?)\n", (*tabla)->info.valor, (*tabla)->info.nombre,(*tabla)->info.longitud);
            }
            
        fprintf(assembler, "%s",linea);
        tabla=&(*tabla)->sSig;
    }

}