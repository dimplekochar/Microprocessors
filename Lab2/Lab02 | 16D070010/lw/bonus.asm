ORG 00H 
	LJMP MAIN
	ORG 50H 
	MOV SP,#0CFH;-----------------------Initialize STACK POINTER
zeroOut:
		USING 0
		PUSH AR0
		PUSH AR2
		MOV R2, 50H ;Specified value of N in 50H moved to R2
		MOV R0, 51H ;Specified value of P in 51H moved to R0
	LOOP0:
        MOV @R0, #0H
		INC R0
		DJNZ R2, LOOP0
		POP AR2
		POP AR0
		RET
display:
		USING 1
		PUSH AR6
		PUSH AR5
		PUSH AR3
		PUSH AR2
		PUSH AR1
		PUSH AR0
		MOV R2, 50H ;Specified value of N in 50H moved to R2
		MOV R0, 51H ;Specified value of P in 51H moved to R0
		LOOP1:
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
		ONESEC:
		MOV R6,#200  	;For delay of 50ms, given in labsheet
		BACK1:
		MOV R5,#0FFH
		BACK:
		DJNZ R5, BACK
		DJNZ R6, BACK1
		DJNZ R3, ONESEC
		INC R0
		DJNZ R2, LOOP1
		POP AR0
		POP AR1
		POP AR2
		POP AR3
		POP AR5
		POP AR6
RET
		


bin2ascii:
		USING 2
		PUSH AR2
		PUSH AR1
		PUSH AR0

		MOV R2, 50H ;Specified value of N in 50H moved to R2
		MOV R0, 51H ;Specified value of P to read in 51H moved to R0
		MOV R1, 52H ;Specified value of P to read in 52H moved to R1
	LOOP2:
		CLR C
        MOV A, @R0
		ANL A, #0F0H
		SWAP A
		MOV @R1, A
		SUBB A, #09H
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
		DJNZ R2, LOOP2
		POP AR0
		POP AR1
		POP AR2
		RET
		
		
memcpy:
		USING 3
		PUSH AR2
		PUSH AR1
		PUSH AR0
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
		LOOP3:
		MOV A, @R0
		MOV @R1, A
		DEC R0
		DEC R1
		DJNZ R2, LOOP3
		POP AR0
		POP AR1
		POP AR2
		RET

MAIN:
MOV A, #1H
MOV R1, #20H
MOV 60H, #25H
INITV:					
        MOV @R1, A
		INC A
		INC R1
		DJNZ 60H, INITV
MOV 50H,#5;------------------------No of memory locations of Array A 
MOV 51H,#45H;------------------------Array A start location 
LCALL zeroOut;----------------------Clear memory
MOV 50H,#5;------------------------No of memory locations of Array B 
MOV 51H,#40H;------------------------Array B start location 
LCALL zeroOut;----------------------Clear memory
MOV 50H,#5;------------------------No of memory locations of source array 
MOV 51H,#35H;------------------------Source array start location 
MOV 52H,#55H;------------------------Destination array(A) start location 
LCALL bin2ascii;--------------------Write at memory location
MOV 50H,#5;------------------------No of elements of Array A to be copied in Array B 
MOV 51H,#30H;------------------------Array A start location 
MOV 52H,#65H;------------------------Array B start location 
LCALL memcpy;-----------------------Copy block of memory to other location
MOV 50H,#5;------------------------No of memory locations of Array B 
MOV 51H,#20H;------------------------Array B start location 
MOV 4FH,#25H;------------------------User defined delay value 
LCALL display;----------------------Display the last four bits of elements on LEDs
here:SJMP here;---------------------WHILE loop(Infinite Loop) 
END 