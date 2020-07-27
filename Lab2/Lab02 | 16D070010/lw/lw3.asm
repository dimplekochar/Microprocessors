	ORG 00H
	LJMP MAIN


;----------------------------------------------------------------
	ORG 50H

memcpy:
		MOV R2, 50H ;Specified value of N in 50H moved to R2
		MOV R0, 51H ;Specified value of P in 51H to read moved to R0 (A)
		MOV R1, 52H ;Specified value of P in 52H to write moved to R1 (B)
		MOV A, R0
		SUBB A, R1
		JNC sidha
		JC ulta
		sidha:
		MOV A, @R0
		MOV @R1, A
		INC R0
		INC R1
		DJNZ R2, sidha
		RET
		ulta:
		MOV A, R0
		ADD A, R2
		SUBB A, #1H
		MOV R0, A
		MOV A, R1
		ADD A, R2
		SUBB A, #1H
		MOV R1, A
		loop:
		MOV A, @R0
		MOV @R1, A
		DEC R0
		DEC R1
		DJNZ R2, loop
		RET
;----------------------------------------------------------------------

MAIN:					
		MOV 50H, #10
		MOV 51H, #60H
		MOV 52H, #65H
		MOV 60H, #1
		MOV 61H, #2
		MOV 62H, #3
		MOV 63H, #4
		MOV 64H, #5
		MOV 65H, #6
		MOV 66H, #7
		MOV 67H, #8
		MOV 68H, #9
		MOV 69H, #10
		LCALL memcpy
		HERE:SJMP HERE
		END

;--------------------------------------------------------------------------
