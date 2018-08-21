Org 0h
ljmp main
Org 100h

main:
MOV 50H, #9FH
MOV 60H, #9FH
MOV A, 50H
ADD A, 60H

MOV 70H,A
CLR A
MOV ACC.0, C
MOV 71H, A

HERE:SJMP HERE
END