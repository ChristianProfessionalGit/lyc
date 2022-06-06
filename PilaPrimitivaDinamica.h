#ifndef PILAPRIMITIVADINAMICA_H_INCLUDED
#define PILAPRIMITIVADINAMICA_H_INCLUDED
#define TODO_BIEN 0
#define NO_HAY_MEMORIA  1
#define PILA_VACIA 1

typedef struct
{
  int dni;
  char car;
}t_algo;
typedef t_algo  t_datoS;
typedef struct S_NODO
{
  t_datoS dato;
  struct S_NODO *sig;
}t_nodo;
typedef t_nodo* t_pilaD;

void crearPila(t_pilaD*);
int pilaVacia(const t_pilaD* );
int pilaLlena(const t_pilaD *);
int apilarD(t_pilaD* ,const t_datoS* );
int desapilarD(t_pilaD* ,t_datoS* );
int verTopeD(const t_pilaD* ,t_datoS*);
void vaciarPilaD(t_pilaD *);

#endif // PILAPRIMITIVADINAMICA_H_INCLUDED
