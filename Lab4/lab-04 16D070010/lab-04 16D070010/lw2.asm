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
lcd_sendstring1:
		Using 0
			push AR0
			push AR3
	    push 0e0h
		MOV R3, #8
  PRINT_LOOP:
        clr   a                 ;clear Accumulator for any previous data
        mov  a, @R0        ;load the first character in accumulator
         acall lcd_senddata      ;send first char
         inc   R0              ;increment data pointer
        DJNZ R3, PRINT_LOOP    ;jump back to send the next character
 pop 0e0h
POP AR3
			pop AR0
         ret                     ;End of routine
		 
lcd_sendstring2:
		Using 0
			push AR0
			push AR3
	    push 0e0h
		MOV R3, #8
		PRINT_LOOP1:
        clr   a                 ;clear Accumulator for any previous data
        mov  a, @R0        ;load the first character in accumulator
         acall lcd_senddata      ;send first char
         inc   R0              ;increment data pointer
        DJNZ R3, PRINT_LOOP1   ;jump back to send the next character
		pop 0e0h
POP AR3
			pop AR0
         ret

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
MOV 50H, A
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

bin2ascii: 
USING 0
PUSH PSW
PUSH AR0
PUSH AR1
PUSH AR2
MOV R0, 23H
MOV R1, #40H
MOV R2, #16

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

displayValues:
USING 0
	PUSH AR0
	PUSH AR1

mov P2,#00h
         ;mov P1,#00h
      	 acall delay
		 acall delay
         acall lcd_init      ;initialise LCD
	  acall delay
	  acall delay
	  acall delay
	  MOV R0, #40H
	  mov a,#84h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  acall lcd_sendstring1	   ;call text strings sending routine
	  acall delay
	  mov R0, #48H
	  mov a,#0C4h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  acall lcd_sendstring2   ;call text strings sending routine
	  acall delay
	  
	  MOV R0, #50H
  	  LCALL DELAY5
mov P2,#00h
         ;mov P1,#00h
      	 acall delay
		 acall delay
         acall lcd_init      ;initialise LCD
	  acall delay
	  acall delay
	  acall delay
	  mov a,#84h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  acall lcd_sendstring1	   ;call text strings sending routine
	  acall delay
	  mov R0, #58H
	  mov a,#0C4h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  acall lcd_sendstring2   ;call text strings sending routine
	  acall delay
LCALL DELAY5
POP AR1
POP AR0
RET
;---------------------------------------------------------------------------

MAIN:
MOV R0, #30H
MOV R1, #90H
MOV 22H, #16
MOV A, #11H
loopm:
MOV @R0, A
INC A
INC R0
MOV @R1, A
INC A
INC R1
DJNZ 22H, loopm
loopmm: CLR A
LCALL readNibble; Read the MSB from the user and store in into locations 4EH
MOV A, 50H
SWAP A
MOV 23H, A
LCALL bin2ascii
LCALL displayvalues


SJMP loopmm
END
;======================MAIN====================
