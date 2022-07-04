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

    escribir_codigo(archivo);

    fprintf(archivo, "MOV EAX, 4C00h\nINT 21h\n\nEND START\n");

    fclose(archivo);
}

void escribir_datos(FILE* assembler,t_lista* tabla){
    char linea[100];

    char aux[50];
    while(*tabla){
        
            
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
                sprintf(linea, "_%s db %s , '$', %d dup (?)\n", (*tabla)->info.nombre, (*tabla)->info.valor,(*tabla)->info.longitud);
            }
            
        fprintf(assembler, "%s",linea);
        tabla=&(*tabla)->sSig;
    }

}
void escribir_codigo(FILE* assembler){
    int i;
    int indice_terceto = obtenerIndiceTercetos();
    for(i=0;i <= indice_terceto;i++)
	{   if(strcmp(vector_tercetos[i].atr1,"TAKE")==0 || strcmp(vector_tercetos[i].atr1,"BETWEEN")==0 ){
            fprintf(assembler,"\nSE EJECUTA %s_%d \n",vector_tercetos[i].atr1,i);
        }
        else if(strcmp(vector_tercetos[i].atr1,"While")==0){
            fprintf(assembler,"\nETIQ_%d \n",i);
            fprintf(assembler,"\nSE EJECUTA %s \n",vector_tercetos[i].atr1);
        }
        else if(strncmp(vector_tercetos[i].atr1,"ETIQ_",strlen("ETIQ_"))==0){
            fprintf(assembler,"\n%s\n",vector_tercetos[i].atr1);
        }
        else if(strcmp(vector_tercetos[i].atr2,"_")==0 && strcmp(vector_tercetos[i].atr2,"_")==0 ){
            fprintf(assembler,"FLD %s \n",vector_tercetos[i].atr1);
        }
        else if(strcmp(vector_tercetos[i].atr1,"+")==0){
            if(strncmp(vector_tercetos[i].atr3,"[",strlen("["))!=0){
                fprintf(assembler,"FLD %s \n",vector_tercetos[i].atr3);
            }
            fprintf(assembler,"FADD\n");
        }
        else if(strcmp(vector_tercetos[i].atr1,"-")==0){
            if(strncmp(vector_tercetos[i].atr3,"[",strlen("["))!=0){
                fprintf(assembler,"FLD %s \n",vector_tercetos[i].atr3);
            }
            fprintf(assembler,"FSUB\n");
        }
        else if(strcmp(vector_tercetos[i].atr1,"*")==0){
            if(strncmp(vector_tercetos[i].atr3,"[",strlen("["))!=0){
                fprintf(assembler,"FLD %s \n",vector_tercetos[i].atr3);
            }
            fprintf(assembler,"FMUL\n");
        }
        else if(strcmp(vector_tercetos[i].atr1,"/")==0){
            if(strncmp(vector_tercetos[i].atr3,"[",strlen("["))!=0){
                fprintf(assembler,"FLD %s \n",vector_tercetos[i].atr3);
            }
            fprintf(assembler,"FDIV\n");
        }
        else if(strcmp(vector_tercetos[i].atr1,"=")==0){
            if(strncmp(vector_tercetos[i].atr3,"[",strlen("["))!=0){
                fprintf(assembler,"FLD %s \n",vector_tercetos[i].atr3);
            }
            fprintf(assembler,"FSTP %s\n",vector_tercetos[i].atr2);
        }
        else if(strcmp(vector_tercetos[i].atr1,"WRITE")==0){
            fprintf(assembler,"DisplayFloat %s \nnewline 1\n\n",vector_tercetos[i].atr2);
        }
        else if(strcmp(vector_tercetos[i].atr1,"READ")==0){
            fprintf(assembler,"GetFloat %s \n\n",vector_tercetos[i].atr2);
        }
        else if(strcmp(vector_tercetos[i].atr1,"CMP")==0){
            if(strncmp(vector_tercetos[i].atr3,"[",strlen("["))!=0){
                fprintf(assembler,"FLD %s \n",vector_tercetos[i].atr3);
            }
            fprintf(assembler,"FLD %s \n",vector_tercetos[i].atr2);
            fprintf(assembler,"FXCH\nFCOM\nFSTSW    AX\nSAHF\nFFREE\n");
        }
        else if(strcmp(vector_tercetos[i].atr1,"BEQ")==0){
            fprintf(assembler,"JE ETIQ_%s \n",conseguir_etiqueta(vector_tercetos[i].atr2));
        }
        else if(strcmp(vector_tercetos[i].atr1,"BNE")==0){
            fprintf(assembler,"JNE ETIQ_%s \n",conseguir_etiqueta(vector_tercetos[i].atr2));
        }
        else if(strcmp(vector_tercetos[i].atr1,"BLT")==0){
            fprintf(assembler,"JNAE ETIQ_%s \n",conseguir_etiqueta(vector_tercetos[i].atr2));
        }
        else if(strcmp(vector_tercetos[i].atr1,"BLE")==0){
            fprintf(assembler,"JBE ETIQ_%s \n",conseguir_etiqueta(vector_tercetos[i].atr2));
        }
        else if(strcmp(vector_tercetos[i].atr1,"BGT")==0){
            fprintf(assembler,"JNBE ETIQ_%s \n",conseguir_etiqueta(vector_tercetos[i].atr2));
        }
        else if(strcmp(vector_tercetos[i].atr1,"BGE")==0){
            fprintf(assembler,"JNB ETIQ_%s \n",conseguir_etiqueta(vector_tercetos[i].atr2));
        }
        else if(strcmp(vector_tercetos[i].atr1,"BI")==0){
            fprintf(assembler,"JMP ETIQ_%s \n",conseguir_etiqueta(vector_tercetos[i].atr2));
        }
        
    }
}

char* conseguir_etiqueta(const char *s){
   
    char *pl,*resultado;
    resultado = (char*) malloc(sizeof(char) *  strlen(s));
    if(resultado == NULL)
	{
		return NULL;
	}
    pl=resultado;
    s++;
    while(*s != ']' && *s != '\0'){
        
        *pl=*s;
        pl++;
        s++;
       
    }
    *pl='\0';     
    return resultado;
}