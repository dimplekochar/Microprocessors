ORG 0H
LJMP MAIN
ORG 50H
;----------------------------------------
	
DELAY4: 
USING 0
PUSH PSW
PUSH AR3
PUSH AR4
PUSH AR5
PUSH AR6
MOV R6, 50H
dela4: MOV R3,#5
del4:MOV R4,#200 
	   BACK44: MOV R5,#0FFH 
		      BACK4: DJNZ R5, BACK4 
			        DJNZ R4, BACK44
			        DJNZ R3,del4
					DJNZ R6, dela4
POP AR6
POP AR5
POP AR4
POP AR3
POP PSW
RET

;----------------------------------------------------------------------------------------

MAIN:

Loop:
MOV A, #0H

MOV C, P1.3
RLC A
MOV C, P1.2
RLC A
MOV C, P1.1
RLC A
MOV C, P1.0
RLC A
MOV 50H, A

LCALL DELAY4
CPL P1.5
LCALL DELAY4
CPL P1.5
CPL P1.6
LCALL DELAY4
CPL P1.5
LCALL DELAY4
CPL P1.5
CPL P1.6
CPL P1.7
SJMP Loop




STOP:SJMP STOP

END