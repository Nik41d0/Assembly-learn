;实现了两位数的加减,但结果要求是两位数
;当10≤W≤99时,可正常显示
DATAS SEGMENT
    X DB ?
    Y DB ?
    Z DB ?
    STR1 DB "PLEASE INPUT YOUR DATA",13,10,"$" 
DATAS ENDS

STACKS SEGMENT
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
	MOV AX,DATAS
	MOV DS,AX
    MOV AH,9   
    LEA DX,STR1 
    INT  21H
LP: 
    MOV AH,2  
    MOV DL,13
    INT 21H 
    MOV AH,2  
    MOV DL,10
    INT 21H
    
    MOV AH,1
    INT 21H
    CMP AL,27
    JZ  EXIT   

    SUB AL,30H
    MOV BL,10
    IMUL BL
    MOV X,AL
   
    MOV AH,1
    INT 21H
    SUB AL,30H
    ADD X,AL  

    MOV AH,2
    MOV DL,'+'
    INT 21H

    MOV AH,1
    INT 21H
    SUB AL,30H

    MOV BL,10
    IMUL BL
    MOV Y,AL

    MOV AH,1
    INT 21H
    SUB AL,30H
    ADD AL,Y
    ADD X,AL  

	MOV AH,2
	MOV DL,"-"
	INT 21H 
	
	MOV AH,1
    INT 21H
    SUB AL,30H

    MOV BL,10
    IMUL BL
    MOV Z,AL

    MOV AH,1
    INT 21H
    SUB AL,30H
    ADD AL,Z  
    SUB X,AL 

    MOV AH,2
    MOV DL,'='
    INT 21H    
    
    MOV AH,0   
    MOV AL,X
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
         
    JMP  LP
EXIT: 
    MOV AH,4CH
    INT 21H  
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
