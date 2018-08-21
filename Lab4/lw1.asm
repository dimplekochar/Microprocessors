; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
LJMP MAIN

org 200h
	
;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
          mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
		Using 0
			push AR0
	    push 0e0h
	    mov R0, #40H
        clr   a                 ;clear Accumulator for any previous data
        mov  a, @R0        ;load the first character in accumulator
         jz    exit              ;go to exit if zero
         acall lcd_senddata      ;send first char
         inc   R0 		 ;increment data pointer
		 clr   a                 ;clear Accumulator for any previous data
        mov  a, @R0 
		acall lcd_senddata 
exit:    pop 0e0h
			pop AR0
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret

;----------------read and pack nibbles--------------------------------------------------------
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
MOV C, P1.7
RLC A
MOV C, P1.6
RLC A
MOV C, P1.5
RLC A
MOV C, P1.4
RLC A
MOV 30H, A
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
			        DJNZ R4, BACK55
			        DJNZ R3,del5
POP AR5
POP AR4
POP AR3
POP PSW
RET

DELAY2: 
USING 0
PUSH PSW
PUSH AR3
PUSH AR4
PUSH AR5
MOV R3,#40
del2:MOV R4,#200 
	   BACK22: MOV R5,#0FFH 
	         BACK2: DJNZ R5, BACK2 
			        DJNZ R4, BACK22
			        DJNZ R3,del2
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
USING 0
	PUSH AR0
MOV R0, 51H
CLR A
CLR C
MOV A, 4EH
SWAP A
ADD A, 4FH
MOV @R0, A
POP AR0
RET

displayValues:
USING 0
	PUSH AR0
	PUSH AR1
MOV A, P1
ADD A, 39H
MOV 35H, A
MOV R0, A
LCALL bin2ascii
CJNE @R0, #0, display
mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
SJMP ending1
display: mov P2,#00h
         ;mov P1,#00h
      	 acall delay
		 acall delay
         acall lcd_init      ;initialise LCD
	  acall delay
	  acall delay
	  acall delay
	  mov a,#85h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay
	
	ending1: LCALL DELAY2
POP AR1
POP AR0
RET
;---------------------------------------------------------------------------
bin2ascii:
USING 0
PUSH PSW
PUSH AR0
PUSH AR1
PUSH AR2
MOV R0, 35H
MOV R1, #40H
MOV R2, #1

LOOP: MOV A,@R0
	  ANL A,#0F0H
	  SWAP A
      MOV @R1,A
	  SUBB A,#0AH
	  JC NEXT1
	  JNC NEXT2

NEXT1: MOV A, @R1
	   ADD A, #30H
	   MOV @R1, A
	   INC R1
	   SJMP PART2

NEXT2: MOV A, @R1
	   ADD A, #37H
	   MOV @R1, A
	   INC R1
	   SJMP PART2

PART2: MOV A,@R0
	  ANL A,#0FH
      MOV @R1,A
	  SUBB A,#0AH
	  JC NEXT3
	  JNC NEXT4
	  
NEXT3: MOV A, @R1
	   ADD A, #30H
	   MOV @R1, A
	   INC R1
	   SJMP ENDING

NEXT4: MOV A, @R1
	   ADD A, #37H
	   MOV @R1, A
	   INC R1
	   SJMP ENDING
	  
ENDING: INC R0
		DJNZ R2, LOOP
		POP AR2
		POp AR1
		POP AR0
		POP PSW
		RET


;---------------------------------------------------------------------------
shuffleBits:
using 0;
	push ar0
	push ar1
	push ar2
	MOV R0, 38H
	MOV R1, 39H
	MOV R2, 50H
	MOV A, R2
	SUBB A, #1
	MOV R2, A
	loopxor: 
	MOV A, @R0
	INC R0
	XRL A, @R0
	MOV @R1, A
	INC R1
	DJNZ R2, loopxor
	MOV A, @R0
	MOV R0, 38H
	XRL A, @R0
	MOV @R1, A
	pop ar2
	pop ar1
	pop ar0
	RET

;---------------------------------------------------------------------------
MAIN:
MOV 50H, #3 ;value of k
MOV 51H, #60H ;value of p
MOV R3, 51H
MOV 38H, R3
MOV 39H, #70H
MOV R2, 50H
Looprun:
LCALL readNibble; Read the MSB from the user and store in into locations 4EH
MOV 4EH, 30H
LCALL readNibble; Read the LSB from the user and store in into locations 4FH
MOV 4FH, 30H
LCALL packNibbles;
INC 51H
DJNZ R2, Looprun
CLR P1.7
CLR P1.6
CLR P1.5
CLR P1.4
MOV 4EH, #0
MOV 4FH, #0
LCALL shuffleBits
LCALL DELAY2
STOP:
LCALL displayValues
SJMP STOP

END
;======================MAIN====================
