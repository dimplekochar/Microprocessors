ORG 0H
LJMP MAIN
ORG 50H
;----------------------------------------
readNibble:
rel:
MOV P1,#0FFH
LCALL DELAY5
CLR P1.7
CLR P1.6
CLR P1.5
CLR P1.4
LCALL DELAY1
MOV C, P1.3
MOV P1.7, C
MOV C, P1.2
MOV P1.6, C
MOV C, P1.1
MOV P1.5, C
MOV C, P1.0
MOV P1.4, C
CLR A
CLR C
MOV C, P1.3
RLC A
MOV C, P1.2
RLC A
MOV C, P1.1
RLC A
MOV C, P1.0
RLC A
MOV 60H, A
LCALL DELAY5
CLR A
CLR C
MOV C, P1.3
RLC A
MOV C, P1.2
RLC A
MOV C, P1.1
RLC A
MOV C, P1.0
RLC A
CJNE A, #0FH, rel
RET

DELAY5: 
USING 0
PUSH PSW
PUSH AR3
PUSH AR4
PUSH AR5
MOV R3,#100
del5:MOV R4,#200 
	   BACK55: MOV R5,#0FFH 
		      BACK5: DJNZ R5, BACK5 
			        DJNZ R4, BACK5
			        DJNZ R3,del5
POP AR5
POP AR4
POP AR3
POP PSW
RET

DELAY1: 
USING 0
PUSH PSW
PUSH AR3
PUSH AR4
PUSH AR5
MOV R3,#20
del1:MOV R4,#200 
	   BACK11: MOV R5,#0FFH 
		      BACK1: DJNZ R5, BACK1 
			        DJNZ R4, BACK11
			        DJNZ R3,del1
POP AR5
POP AR4
POP AR3
POP PSW
RET

packNibbles:
CLR A
CLR C
MOV A, 4EH
RL A
RL A
RL A
RL A
ADD A, 4FH
MOV 50H, A
RET

MAIN:
LCALL readNibble; Read the MSB from the user and store in into locations 4EH
MOV 4EH, 60H
LCALL readNibble; Read the LSB from the user and store in into locations 4FH
MOV 4FH, 60H
LCALL packNibbles;

STOP:SJMP STOP

END