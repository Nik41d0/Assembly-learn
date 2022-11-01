;输出1+2+3+……N 的和>500时的值 和 N的值
DATAS SEGMENT
    
    SUM DW ?
    N DW ?  
DATAS ENDS

STACKS SEGMENT

STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    MOV AX,0
    MOV BX,0
LP:
    INC BX
    ADD AX,BX	
    CMP AX,500
    JLE LP
    
    MOV SUM,AX
    MOV N,BX
    
    MOV AX,SUM
    MOV BL,100
    IDIV BL
    ADD AX,30H
    MOV BX,AX
    
    MOV AH,2
    MOV DL,BL
    INT 21H
    
    MOV AH,0
    MOV AL,BH
    MOV BL,10
    IDIV BL
    ADD AX,3030H
    MOV BX,AX
    
    MOV AH,2
    MOV DL,BL
    INT 21H
    MOV AH,2
    MOV DL,BH
    INT 21H
    
    MOV AH,2
    MOV DL,10
    INT 21H
    
    MOV AX,N
    MOV BL,10
    IDIV BL
    ADD AX,3030H
    MOV BX,AX
    
    MOV AH,2
    MOV DL,BL
    INT 21H
    MOV AH,2
    MOV DL,BH
    INT 21H
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
