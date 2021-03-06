; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
ljmp start

org 200h
start:
      mov P2,#00h
      mov P1,#00h
	  ;initial delay for lcd power up

	;here1:setb p1.0
      	  acall delay
	;clr p1.0
	  acall delay
	;sjmp here1


	  acall lcd_init      ;initialise LCD
	
	  acall delay
	  acall delay
	  acall delay
	  mov a,#081H		 ;Put cursor on first row,1st column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string1   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring1	   ;call text strings sending routine
	  acall delay
	  acall delay
	  MOV R1, #91H
	  MOV @R1, #44H
	  INC R1
	  MOV @R1, #49H
	  INC R1
	  MOV @R1, #4DH
	  INC R1
	  MOV @R1, #50H
	  INC R1
	  MOV @R1, #4CH
	  INC R1
	  MOV @R1, #45H
	  INC R1
	  MOV @R1, #0
	  mov a,#0C4h		  ;Put cursor on second row,3 column
	  acall lcd_command
	  acall delay
	  mov   R0, #91H
	  acall lcd_sendstring


here: sjmp here				//stay here 

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
;------------------text strings sending routine-------------------------------------
lcd_sendstring1:
	 push 0e0h
	 PRINT_LOOP1:
         clr   a   		 ;clear Accumulator for any previous data
         movc  a, @a+dptr        ;load the first character in accumulator
         jz    exit1              ;go to exit if zero
         acall lcd_senddata      ;send first char
         inc   dptr              ;increment data pointer
         sjmp  PRINT_LOOP1    ;jump back to send the next character
exit1:    pop 0e0h
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------


;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
		using 0
			push AR0
	 push 0e0h
	 mov   R0, #91H
	 PRINT_LOOP:
         clr   a   		 ;clear Accumulator for any previous data
         mov  a, @R0         ;load the first character in accumulator
         jz    exit              ;go to exit if zero
         acall lcd_senddata      ;send first char
         inc   R0              ;increment data pointer
         sjmp  PRINT_LOOP    ;jump back to send the next character
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

;------------- ROM text strings---------------------------------------------------------------
org 300h
my_string1:
         DB   "EE 337 - Lab 4", 00H
end
	

