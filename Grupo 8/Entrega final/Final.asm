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
prueba dd ?
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

FLD 2555 
FSTP hola
FLD 99.99 
FSTP numero1
FLD a 
FLD b 
FLD 4 
FADD
FMUL
FSTP numero2
FLD 234 
FLD 423 
FLD 7124 
FADD
FLD 9421 
FMUL
FADD
FSTP numero3
FLD 35 
FLD 5 
FDIV
FLD 346 
FADD
FLD 535 
FLD 2 
FMUL
FSUB
FLD 544 
FADD
FLD 2 
FMUL
FSTP numero4
DisplayFloat HOLAdsadasd 
newline 1

GetFloat PEPE 

DisplayFloat prueba 
newline 1

FLD 0 
FLD saldos 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNBE ETIQ_41 
FLD 85 
FLD saldos 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JBE ETIQ_45 

ETIQ_41
FLD Le_queda_poco_saldo 
FSTP mensaje
DisplayFloat Hola_mundoWWWWEWEQW 
newline 1


ETIQ_45
FLD 0 
FLD saldos 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JBE ETIQ_71 
FLD 2 
FSTP @expresion1
FLD a 
FLD b 
FLD 4 
FADD
FMUL
FSTP @expresion2

SE EJECUTA BETWEEN_57 
FLD 0 
FSTP @resultado
FLD @expresion1 
FLD a 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNAE ETIQ_64 
FLD @expresion2 
FLD a 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNBE ETIQ_64 
FLD 1 
FSTP @resultado

ETIQ_64
FLD 1 
FLD @resultado 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNE ETIQ_70 
FLD Le_queda_poco_saldo 
FSTP mensaje
DisplayFloat Hola_mundoWWWWEWEQW 
newline 1


ETIQ_70

ETIQ_71

ETIQ_72 

SE EJECUTA While 
FLD 0 
FLD saldos 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JBE ETIQ_80 
FLD ESTOY_EN_EL_WHILEE 
FSTP mensaje
DisplayFloat Q_UE_ONDAAAA 
newline 1

JMP ETIQ_72 

ETIQ_80
FLD 0 
FLD saldos 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNE ETIQ_87 
FLD ESTOY_EN_EL_WHILEE 
FSTP mensaje
DisplayFloat Q_UE_ONDAAAA 
newline 1


ETIQ_87
FLD 0 
FLD saldos 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNB ETIQ_94 
FLD Le_queda_poco_saldo 
FSTP mensaje
DisplayFloat Hola_mundo 
newline 1


ETIQ_94
FLD 0 
FLD saldo 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNE ETIQ_101 
FLD 1 
FLD saldo 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNE ETIQ_104 

ETIQ_101
FLD funciona_el_if_wiii 
FSTP mensaje

ETIQ_104
FLD 0 
FLD saldo 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JE ETIQ_114 
FLD 1 
FLD saldo 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JE ETIQ_113 
FLD agggg_no_funciona 
FSTP mensaje

ETIQ_113

ETIQ_114
FLD 123 
FLD variable 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JBE ETIQ_120 
FLD probemos_el_NOT_condicion 
FSTP mensaje

ETIQ_120

ETIQ_121 

SE EJECUTA While 
FLD 0 
FLD saldo 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JE ETIQ_133 
FLD 1 
FLD saldo 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JE ETIQ_132 
FLD while_con_saltos 
FSTP mensaje
DisplayFloat Q_UE_ONDAAAA 
newline 1

JMP ETIQ_121 

ETIQ_132

ETIQ_133

ETIQ_134 

SE EJECUTA While 
FLD 267 
FLD saldo 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNBE ETIQ_141 
FLD 145 
FLD saldo 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNE ETIQ_146 

ETIQ_141
FLD while_con_saltos_y_OR 
FSTP mensaje
DisplayFloat Q_UE_ONDAAAA 
newline 1

JMP ETIQ_134 

ETIQ_146

SE EJECUTA TAKE_147 
FLD 2 
FLD 12 
FSUB
FLD 24 
FSUB
FLD 48 
FSUB
FSTP @resultado
DisplayFloat @resultado 
newline 1


SE EJECUTA TAKE_154 
DisplayFloat ERROR 
newline 1


SE EJECUTA TAKE_156 
FLD 0 
FSTP @resultado
DisplayFloat @resultado 
newline 1


SE EJECUTA TAKE_159 
FLD 56 
FLD 12 
FMUL
FLD 24 
FMUL
FSTP @resultado
DisplayFloat @resultado 
newline 1

FLD 2.3 
FSTP @expresion1
FLD 11.22 
FSTP @expresion2

SE EJECUTA BETWEEN_169 
FLD 0 
FSTP @resultado
FLD @expresion1 
FLD z 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNAE ETIQ_176 
FLD @expresion2 
FLD z 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNBE ETIQ_176 
FLD 1 
FSTP @resultado

ETIQ_176
FLD 1 
FLD @resultado 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JE ETIQ_182 
FLD 0 
FLD saldos 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JBE ETIQ_186 

ETIQ_182
FLD caso_1 
FSTP mensaje
DisplayFloat funciona_el_bet? 
newline 1


ETIQ_186
FLD 2.3 
FSTP @expresion1
FLD 11.22 
FSTP @expresion2

SE EJECUTA BETWEEN_191 
FLD 0 
FSTP @resultado
FLD @expresion1 
FLD z 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNAE ETIQ_198 
FLD @expresion2 
FLD z 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNBE ETIQ_198 
FLD 1 
FSTP @resultado

ETIQ_198
FLD 1 
FLD @resultado 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JE ETIQ_205 

ETIQ_201
FLD caso_2 
FSTP mensaje
DisplayFloat funciona_el_bet? 
newline 1


ETIQ_205
FLD 2.3 
FSTP @expresion1
FLD 11.22 
FSTP @expresion2

SE EJECUTA BETWEEN_210 
FLD 0 
FSTP @resultado
FLD @expresion1 
FLD z 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNAE ETIQ_217 
FLD @expresion2 
FLD z 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNBE ETIQ_217 
FLD 1 
FSTP @resultado

ETIQ_217
FLD 1 
FLD @resultado 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JE ETIQ_238 
FLD 2 
FSTP @expresion1
FLD a 
FLD b 
FLD 4 
FADD
FMUL
FSTP @expresion2

SE EJECUTA BETWEEN_228 
FLD 0 
FSTP @resultado
FLD @expresion1 
FLD a 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNAE ETIQ_235 
FLD @expresion2 
FLD a 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNBE ETIQ_235 
FLD 1 
FSTP @resultado

ETIQ_235
FLD 1 
FLD @resultado 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNE ETIQ_242 

ETIQ_238
FLD caso_3 
FSTP mensaje
DisplayFloat funciona_el_bet? 
newline 1


ETIQ_242
FLD 2.3 
FSTP @expresion1
FLD 11.22 
FSTP @expresion2

SE EJECUTA BETWEEN_247 
FLD 0 
FSTP @resultado
FLD @expresion1 
FLD z 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNAE ETIQ_254 
FLD @expresion2 
FLD z 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNBE ETIQ_254 
FLD 1 
FSTP @resultado

ETIQ_254
FLD 1 
FLD @resultado 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNE ETIQ_279 
FLD 2 
FSTP @expresion1
FLD a 
FLD b 
FLD 4 
FADD
FMUL
FSTP @expresion2

SE EJECUTA BETWEEN_265 
FLD 0 
FSTP @resultado
FLD @expresion1 
FLD a 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNAE ETIQ_272 
FLD @expresion2 
FLD a 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNBE ETIQ_272 
FLD 1 
FSTP @resultado

ETIQ_272
FLD 1 
FLD @resultado 
FXCH
FCOM
FSTSW    AX
SAHF
FFREE
JNE ETIQ_278 
FLD caso_4 
FSTP mensaje
DisplayFloat funciona_el_bet? 
newline 1


ETIQ_278

ETIQ_279
MOV EAX, 4C00h
INT 21h

END START
