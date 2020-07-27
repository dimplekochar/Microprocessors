	ORG 00H
	LJMP MAIN

;----------------------------------------------------------------
	ORG 50H

DELAY:
	MOV R0, 4FH
	SETB P1.7
	ACALL LOOP
	MOV R0, 4FH
	CLR P1.7
	ACALL LOOP
	RET

LOOP:			;For running the loop D/2 times
	MOV R3, #10		
	HALFSEC:		;For making 50ms*10=0.5sec
	MOV R2,#200  	;For delay of 50ms, given in labsheet
	BACK1:
	MOV R1,#0FFH
	BACK:
	DJNZ R1, BACK
	DJNZ R2, BACK1
	DJNZ R3, HALFSEC
	DJNZ R0, LOOP
	RET
	
    

;----------------------------------------------------------------------

MAIN:
		MOV 4FH, #6		;D=6sec
		CLR P1.7	;MAKE P1.7 OUTPUT PORT
		
		ACALL DELAY			;Blink led once
		HERE: SJMP HERE
		
;HERE: 	ACALL DELAY		;To blink infinite times.	
;		SJMP HERE
		END

;--------------------------------------------------------------------------
