; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
LJMP MAIN

org 200h

org 3bh
	ljmp isrkey
	
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
		 
;-----------------------------1sec delay-----------------------------------------------
delaysec: 
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
		 
		 
		 
;-----------------------------100ms delay------------------------------------------------
DELAY1: 
USING 0
PUSH PSW
PUSH AR3
PUSH AR4
PUSH AR5
MOV R3,#2
del15:MOV R4,#200 
	   BACK115: MOV R5,#0FFH 
		      BACK15: DJNZ R5, BACK15
			        DJNZ R4, BACK115
			        DJNZ R3,del15
POP AR5
POP AR4
POP AR3
POP PSW
RET
;------------------------------10ms delay------------------------------------------------
delay10: 
USING 0
PUSH PSW
PUSH AR3
PUSH AR4
PUSH AR5
MOV R4,#40 
	   BACK116: MOV R5,#0FFH 
		      BACK16: DJNZ R5, BACK16
			        DJNZ R4, BACK116
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
         ret
;End of routine

lcd_sendkey:
		Using 0
			push AR0
			push AR3
			push AR6
	    push 0e0h
 	 mov R6, A;Put cursor on first row,1st column
	 	 mov a, #80h
acall lcd_command	 ;send command to LCD
acall delay
mov   dptr, #initial   ;Load DPTR with sring1 Addr
	 PRINT_LOOP1:
clr   a                 ;clear Accumulator for any previous data
movc  a,@a+dptr         ;load the first character in accumulator
jz    exit              ;go to exit if zero
acall lcd_senddata      ;send first char
inc   dptr              ;increment data pointer
sjmp  PRINT_LOOP1    ;jump back to send the next character
exit:		clr   a                 ;clear Accumulator for any previous data
        mov  a, R6        ;load the first character in accumulator
         acall lcd_senddata      ;send first char
 pop 0e0h
 pop AR6
POP AR3
			pop AR0
         ret                     ;End of routine



MAIN:

mov P2,#00h

acall delay
acall delay
acall lcd_init      ;initialise LCD
acall delay
acall delay
acall delay
mov a,#081H		 ;Put cursor on first row,1st column
acall lcd_command	 ;send command to LCD
acall delay


;------- keypad configuration------------

mov p1,#00fh		;LSB as row, MSB as column									
setb IE.7
mov a,0b1h		;IEN1, interrupt enable register
ORL a,#01		;changing only the required bit, without changing the other bits
mov 0b1h,a			
mov 9cH,#00fh		;KBLS (level selector), LSB as row, MSB as column
mov 9dH,#00f0h		;KBE (Keyboard enable) LSB as interrupt, MSB as I/O

mov p1, #0f0h	

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

;======================MAIN====================
org 500h
	isrkey:
	mov a, p1
	acall delay10
	cjne a, p1, ending
	Final: 
	clr p1.0
	setb p1.1
	setb p1.2
	setb p1.3
	mov a, p1
	anl a, #0f0h
	cjne a, #0f0h, row0
	setb p1.0
	clr p1.1
	setb p1.2
	setb p1.3
	mov a, p1
	anl a, #0f0h
	cjne a, #0f0h, row1
	setb p1.0
	setb p1.1
	clr p1.2
	setb p1.3
	mov a, p1
	anl a, #0f0h
	cjne a, #0f0h, row2
	setb p1.0
	setb p1.1
	setb p1.2
	clr p1.3
	mov a, p1
	anl a, #0f0h
	cjne a, #0f0h, row3
	sjmp final
	
		row0: mov dptr, #disp0
	sjmp col
		row1: mov dptr, #disp1
	sjmp col
		row2: mov dptr, #disp2
	sjmp col
		row3: mov dptr, #disp3
	sjmp col
	
	col: 
	rlc a
	jnc colfound
	inc dptr
	sjmp col
	
	colfound:
	 mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	clr a
	clr c
	movc a, @a+dptr
	lcall lcd_sendkey
  	lcall delaysec

	ending:
	clearkbf: 
	mov 9eh, #0
	mov R4, 9eh
	cjne r4, #0, clearkbf
	;mov p1, #0fh
	
	 clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 
	reti
	
	
	org 700h
initial:
		DB "Key pressed is ", 0H
disp0:
		DB   '0', '1', '2', '3'
disp1:
		DB   '4', '5', '6', '7'
disp2:
		DB   '8', '9', 'A', 'B'
disp3:
		DB   'C', 'D', 'E', 'F'
			
END			

