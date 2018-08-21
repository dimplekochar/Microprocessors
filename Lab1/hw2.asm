Org 0h
ljmp main
Org 100h

main:
MOV 50H, #19
MOV R4, 50H
MOV R1, #1
MOV R0, #51H
MOV A, #0
LOOP: 
ADD A, R1
INC R1
MOV @R0, A
INC R0
DEC R4
CJNE R4, #0, LOOP

HERE:SJMP HERE
END