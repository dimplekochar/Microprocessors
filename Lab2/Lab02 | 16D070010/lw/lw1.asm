	ORG 00H
	LJMP MAIN

;----------------------------------------------------------------
	ORG 50H

display:
		MOV R2, 50H ;Specified value of N in 50H moved to R2
		MOV R0, 51H ;Specified value of P in 51H moved to R0
		LOOP:
        MOV A, @R0
		RRC A
		MOV P1.4, C
		RRC A
		MOV P1.5, C
		RRC A
		MOV P1.6, C
		RRC A
		MOV P1.7, C
		MOV R3, #20
		ACALL ONESEC
		INC R0
		DJNZ R2, LOOP
RET
	

		
ONESEC:		;For making 50ms*20=1sec
	MOV R2,#200  	;For delay of 50ms, given in labsheet
	BACK1:
	MOV R5,#0FFH
	BACK:
	DJNZ R5, BACK
	DJNZ R2, BACK1
	DJNZ R3, ONESEC
RET
	
    

;----------------------------------------------------------------------

MAIN:
		CLR P1.7
		CLR P1.6
		CLR P1.5
		CLR P1.4
		INITV:					
        MOV @R1, A
		INC A
		INC R1
		DJNZ 60H, INITV
						
		MOV 50H, #12
		MOV 51H, #31H
		CLR A
		CLR C
		ACALL display		
		HERE: SJMP HERE

		END

;--------------------------------------------------------------------------
