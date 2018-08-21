ORG 0H
LJMP MAIN
ORG 100H
;----------------------------------------
	
sqrt: 
MOV A, 50H
MOV R6, #0
MOV R5, #0
loop:
INC R6
INC R5
SUBB A, R6
JC nosqrt
INC R6
CJNE A, #0, loop
JZ sqrtf
JC nosqrt

nosqrt:
MOV A, 50H
RLC A
MOV P1.7, C 
RLC A
MOV P1.6, C
RLC A
MOV P1.5, C
RLC A
MOV P1.4, C
SJMP ending

sqrtf:
MOV A, R5
RRC A
MOV P1.4, C 
RRC A
MOV P1.5, C
RRC A
MOV P1.6, C
RRC A
MOV P1.7, C
SJMP ending

ending:
RET

;----------------------------------------------------------------------------------------

MAIN:

MOV 50H, #200
LCALL sqrt

STOP:SJMP STOP

END