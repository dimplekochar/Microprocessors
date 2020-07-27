	ORG 00H
	LJMP MAIN


;----------------------------------------------------------------
	ORG 50H

zeroOut:
		using 0
		PUSH AR0
		PUSH AR2
		MOV R2, 50H ;Specified value of N in 50H moved to R2
		MOV R0, 51H ;Specified value of P in 51H moved to R0
LOOP:
        MOV @R0, #0H
		INC R0
		DJNZ R2, LOOP
		POP AR2
		POP AR0
		RET
;----------------------------------------------------------------------

MAIN:					;Initializing some test values in address from 31H to 43H (13 values)
		MOV 60H, #13
		MOV R1, #31H
		MOV A, #2H
INITV:					
        MOV @R1, A
		INC A
		INC R1
		DJNZ 60H, INITV
						;using the subroutine to clear values from 31H to 42H (12 values)
		MOV 50H, #12
		MOV 51H, #31H
		LCALL zeroOut
		HERE:SJMP HERE
		END

;--------------------------------------------------------------------------
