DATA SEGMENT
MSG1 DB 10,13,'ENTER  THE STRING:$'
STR1 DB 100,0,100 dup(0)
LEN1 DW 0000H
MSG2 DB 10,13,'SUBSTRING TO BE REPLACED IS: $'
STR2 DB 20,0,20 DUP(0)
LEN2 DW 0000H
MSG3 DB 10,13,'REPLACE WITH:$'
STR3 DB 20,0,20 DUP(0)
LEN3 DW 0000H
MSG4 DB 10,13,'OUTPUT STRING IS: $'
DATA ENDS

DISPLAY MACRO MSG
    LEA DX,MSG
    MOV AH,09H
    INT 21H
ENDM  
 
CODE SEGMENT
ASSUME CS:CODE,DS:DATA,ES:DATA
;initialise data and extra segment
START: MOV AX,DATA  
MOV DS,AX
MOV ES,AX
;display first msg,take its input,move its length to len1 using al and bx
DISPLAY MSG1
LEA DX,STR1
MOV AH,0AH
INT 21H
MOV AL,[STR1+1]
MOV BX,OFFSET LEN1      
MOV BYTE PTR [BX],AL
;repeat
DISPLAY MSG2
LEA DX,STR2
MOV AH,0AH
INT 21H
MOV AL,[STR2+1]
MOV BX,OFFSET LEN2      
MOV BYTE PTR [BX],AL 

DISPLAY MSG3
LEA DX,STR3
MOV AH,0AH
INT 21H
MOV AL,[STR3+1]
MOV BX,OFFSET LEN3      
MOV BYTE PTR [BX],AL

DISPLAY MSG4

;load actual string input and its length for strings 1 and 2
LEA SI,STR1+2
MOV CX,LEN1

LEA DI,STR2+2
MOV BX,LEN2

;push first string details
 PUSH SI
 PUSH CX
;compare first characters
 UP:MOV AL,[SI]
 L3:MOV AH,[DI]
    CMP AH,AL
    JZ L2;jump to l2 if they are equal
    ;else pop cx and si
    POP CX
    POP SI
    LEA DI,STR2+2;pinnem load cheyyanam
    MOV BX,LEN2
    MOV DL,[SI];move the first character into an array and print it
    MOV AH,02H
    INT 21H
    INC SI;move to next character
    DEC CX
    PUSH SI;push again
    PUSH CX
    CMP CX,0000;check counter 0 aayonn i.e string theernonn,ennit nokit jump ngotelum
    JNZ UP
    JZ LAST

 L2:DEC BX
    PUSH SI
    PUSH CX
    ;MOV AX,LEN2
    ;CMP BX,AX
    CMP BX,0000H
    JNZ L4
 L4:
    INC SI
    INC DI
    CMP BX,0000
    JZ L1
     DEC CX 
    JNZ UP
 L1:LEA DI,STR3+2
    MOV BX,LEN3
 L9:MOV DL,[DI]
    MOV AH,02H
    INT 21H
    INC DI
    DEC BX
    JNZ L9 
    LEA DI,STR2+2
    MOV BX,LEN2
    PUSH SI
    PUSH CX
    JMP UP
LAST:
    MOV AH,4CH
    INT 21H
CODE ENDS
END START
