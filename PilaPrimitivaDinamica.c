#include "PilaPrimitivaDinamica.h"
#include <stdlib.h>
#include <stdio.h>
void crearPila(t_pilaD *p)
{
  *p=NULL;
}
int pilaVacia(const t_pilaD *p)
{
  return (*p)==NULL;
}
int pilaLlena(const t_pilaD *p)
{
  t_nodo *aux;
  aux=(t_nodo*)malloc(sizeof(t_nodo));
  free(aux);
  return aux==NULL;
}
int apilarD(t_pilaD *p,const t_datoS *d)
{
  t_nodo *aux;
  aux=(t_nodo*)malloc(sizeof(t_nodo));
  if(!aux)
    return  NO_HAY_MEMORIA;
  aux->dato=*d;
  aux->sig=*p;
  *p=aux;
  return TODO_BIEN;
}
int desapilarD(t_pilaD *p,t_datoS *d)
{
  if(!*p)
    return PILA_VACIA;
  t_nodo *aux;
  aux=*p;
  *d=aux->dato;
  *p=aux->sig;
  free(aux);
  return  TODO_BIEN;
}
int verTopeD(const t_pilaD *p, t_datoS *d)
{
  if(!*p)
    return PILA_VACIA;
  *d=((*p)->dato);
  return  TODO_BIEN;
}
void vaciarPilaD(t_pilaD *p)
{
  t_nodo *aux;
  while(*p)
  {
    aux=*p;
    *p=aux->sig;
    free(aux);
  }
}





