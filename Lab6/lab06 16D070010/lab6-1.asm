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
		 acall DELAY1
         clr   LCD_en
         ret                  ;Return from busy routine
		 
;-----------------------------100ms delay------------------------------------------------
DELAY1: 
USING 0
PUSH PSW
PUSH AR3
PUSH AR4
PUSH AR5
MOV R3,#2
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
;-------------------------------initial delay-----------------------------------------------
delay:	 push 0
		push 1
        mov r0,#1
loop2:	 mov r1,#255
loop1:	 djnz r1, loop1
djnz r0, loop2
pop 1
pop 0 
ret

;-----------------------text strings sending routine-------------------------------------

lcd_sendstring:
		Using 0
			push AR0
			push AR3
			push AR6
	    push 0e0h
		MOV R3, #17
		MOV R0, #41H
		 mov R6,#080H	
  PRINT_LOOP:
 	 mov a, R6;Put cursor on first row,1st column
acall lcd_command	 ;send command to LCD
acall delay
        clr   a                 ;clear Accumulator for any previous data
        mov  a, R0        ;load the first character in accumulator
         acall lcd_senddata      ;send first char
         inc   R0 
inc R6		 ;increment data pointer
        DJNZ R3, PRINT_LOOP    ;jump back to send the next character
 pop 0e0h
 pop AR6
POP AR3
			pop AR0
         ret                     ;End of routine

MAIN:

mov P2,#00h
mov P1,#00h
acall delay
acall delay
acall lcd_init      ;initialise LCD
acall delay
acall delay
acall delay
mov a,#081H		 ;Put cursor on first row,1st column
acall lcd_command	 ;send command to LCD
acall delay

	

Here:	  acall lcd_sendstring  ;call text strings sending routine
 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
			
SJMP Here
END
;======================MAIN====================
