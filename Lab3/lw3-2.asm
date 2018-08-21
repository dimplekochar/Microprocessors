ORG 0H
LJMP MAIN
ORG 50H
;----------------------------------------
	
MAIN:
Loop:
CLR A
CLR C
MOV C, P1.1
RLC A
MOV C, P1.0
RLC A
MOV 50H, A
CLR A
CLR C
MOV C, P1.3
RLC A
MOV C, P1.2
RLC A
ADD A, 50H
RRC A
MOV P1.4, C
RRC A
MOV P1.5, C
RRC A
MOV P1.6, C
SJMP Loop


STOP:SJMP STOP

END
