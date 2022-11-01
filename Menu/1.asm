DATAS SEGMENT
    X1 DB "****PRESS 1,ADD **************************",10,13,"$"
    X2 DB "****PRESS 2,NAME INPUT AND OUTPUT   ******",10,13,"$"
    X3 DB "****PRESS 0,EXIT *************************",10,13,"$"
    X DB  ?
    Y DB  ?
    Z DB  ?
    STRING DB 'Please input your data','$'
    MESG1 DB 0DH,0AH,'what is your name?$'
    MESG2 DB '?(Y/N)$'
    BUF DB 30 ? 30 DUP(?)

   
DATAS ENDS

STACKS SEGMENT
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START1:
    MOV AX,DATAS
    MOV DS,AX
START: 
	MOV AH,9
    LEA DX,X1
    INT 21H
    MOV AH,9
    LEA DX,X2
    INT 21H  
    MOV AH,9
    LEA DX,X3
    INT 21H     
    
    MOV AH,1
    INT 21H
    CMP AL,"1"
    JE  LP1
    CMP AL,"2"
    JE  LP2
    CMP AL,"0"
    JE EXIT
    JMP START
   
LP1:       
    MOV AH,2
    MOV DL,10
    INT 21H 
    MOV AH,9   
    LEA DX,STRING
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
    JZ  START  
    
    SUB AL,30H
    MOV BL,10
    MUL BL
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
    MUL BL
    MOV Y,AL
    MOV AH,1
    INT 21H
    SUB AL,30H
    ADD AL,Y   
    ADD X,AL 
 
  
    MOV AH,2
    MOV DL,'='
    INT 21H    
    
    MOV BL,10    
    MOV AH,0   
    MOV AL,X
    IDIV BL
 
    ADD AX,3030H
    MOV BX,AX
    MOV AH,2
    MOV DL,BL
    INT 21H 
    
    MOV AH,2
    MOV DL,BH
    INT 21H     
    JMP LP   
     
LP2:     
 	AGAIN:MOV AH,9
      MOV DX,OFFSET MESG1
      INT 21H
     ; MOV AH,2
     ; MOV DL,0AH
     ; INT 21H
      MOV AH,0AH
      MOV DX,OFFSET BUF  
      INT 21H
      MOV BL,BUF+1
      MOV BH,0
      MOV SI,OFFSET BUF+2
      MOV BYTE PTR [BX+SI],'$'
      MOV AH,2
      MOV DL,0AH
      INT 21H
      MOV AH,9
      MOV DX,OFFSET BUF+2  
      INT 21H

      MOV AH,9
      MOV DX,OFFSET MESG2   
      INT 21H

      MOV AH,1
      INT 21H

      CMP AL,'Y'
      JNE AGAIN  
      MOV AH,2
      MOV DL,10
      INT 21H  
      JMP START
    
EXIT:    MOV AH,4CH
    INT 21H
CODES ENDS
    END START1
