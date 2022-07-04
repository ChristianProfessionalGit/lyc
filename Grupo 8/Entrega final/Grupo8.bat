flex Lexico.l
bison -dyv sintactico.y
gcc.exe lex.yy.c y.tab.c -o Grupo8.exe
Grupo8.exe prueba.txt

@echo off
del Grupo8.exe
del lex.yy.c
del y.tab.c
del y.tab.h
del y.output

pause