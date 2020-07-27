	ORG 00H
	LJMP MAIN


;----------------------------------------------------------------
	ORG 50H

bin2ascii:
		MOV R2, 50H ;Specified value of N in 50H moved to R2
		MOV R0, 51H ;Specified value of P to read in 51H moved to R0
		MOV R1, 52H ;Specified value of P to read in 52H moved to R1
LOOP:
		CLR C
        MOV A, @R0
		ANL A, #0F0H
		SWAP A
		MOV @R1, A
		SUBB A, #0AH
		MOV A, @R1
		JC rel
		ADD A, #7H
		rel: 
		ADD A, #30H
		MOV @R1, A
		INC R1
		MOV A, @R0
		ANL A, #0FH
		MOV @R1, A
		SUBB A, #09H
		MOV A, @R1
		JC rell
		ADD A, #7H
		rell: 
		ADD A, #30H
		MOV @R1, A
		INC R1
		INC R0
		DJNZ R2, LOOP
		RET
;----------------------------------------------------------------------

MAIN:					
		MOV 50H, #2
		MOV 51H, #31H
		MOV 52H, #11H
		MOV 31H, #2FH
		MOV 32H, #3EH
		LCALL bin2ascii
		HERE:SJMP HERE
		END

;--------------------------------------------------------------------------
