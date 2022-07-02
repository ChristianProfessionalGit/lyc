include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
a dd ?
b dd ?
c dd ?
d dd ?
numero1 dd ?
numero2 dd ?
PEPE dd ?
mensaje dd ?
numero3 dd ?
numero4 dd ?
hola dd ?
saldos dd ?
saldo dd ?
variable dd ?
_2555 dd 2555.0
_99.99 dd 99.99
_4 dd 4.0
_234 dd 234.0
_423 dd 423.0
_7124 dd 7124.0
_9421 dd 9421.0
_35 dd 35.0
_5 dd 5.0
_346 dd 346.0
_535 dd 535.0
_2 dd 2.0
_544 dd 544.0
_HOLAdsadasd db "HOLAdsadasd" , '$', 11 dup (?)
_0 dd 0.0
_85 dd 85.0
_Le_queda_poco_saldo db "Le queda poco saldo" , '$', 19 dup (?)
_Hola_mundoWWWWEWEQW db "Hola mundoWWWWEWEQW" , '$', 19 dup (?)
_ESTOY_EN_EL_WHILEE db "ESTOY EN EL WHILEE" , '$', 18 dup (?)
_Q_UE_ONDAAAA db "Q UE ONDAAAA" , '$', 12 dup (?)
_Hola_mundo db "Hola mundo" , '$', 10 dup (?)
_1 dd 1.0
_funciona_el_if_wiii db "funciona el if wiii" , '$', 19 dup (?)
_agggg_no_funciona db "agggg no funciona" , '$', 17 dup (?)
_123 dd 123.0
_probemos_el_NOT_condicion db "probemos el NOT condicion" , '$', 25 dup (?)
_while_con_saltos db "while con saltos" , '$', 16 dup (?)
_267 dd 267.0
_145 dd 145.0
_while_con_saltos_y_OR db "while con saltos y OR" , '$', 21 dup (?)
_2.3 dd 2.3
_11.22 dd 11.22
_caso_1 db "caso 1" , '$', 6 dup (?)
_funciona_el_bet? db "funciona el bet?" , '$', 16 dup (?)
_caso_2 db "caso 2" , '$', 6 dup (?)
_caso_3 db "caso 3" , '$', 6 dup (?)
_caso_4 db "caso 4" , '$', 6 dup (?)

.CODE

START:

MOV AX,@DATA
MOV DS, AX
MOV ES, AX

MOV EAX, 4C00h
INT 21h

END START
