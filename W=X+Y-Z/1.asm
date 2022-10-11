;设W、X、Y、Z均为8位带符号数，要求完成计算表达式W=X+Y-Z。
;当W≥10时
;思路:输出两个字符，一个是商，一个是余数(DIV)
DATAS SEGMENT  
    X DB ?
    SHANG DB ?	;定义变量,存储商,准确来说是存储 运算结果的第一个字符
    YU DB ?	;存余数，预算结果的第二个字符
DATAS ENDS

STACKS SEGMENT

STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    MOV AH,1	
    INT 21H
    MOV X,AL 
    	
    MOV AH,2
    MOV DL,"+"
    INT 21H
	
    MOV AH,1	
    INT 21H
    ADD X,AL
	
    MOV AH,2
    MOV DL,"-"
    INT 21H
	
    MOV AH,1
    INT 21H   
    SUB X,AL 
    MOV AL,X
    SUB AL,30H
	
    MOV AH,0
    MOV BL,10
    DIV BL	
    MOV SHANG,AL
    MOV YU,AH
	
    MOV AH,2	
    MOV DL,"="
    INT 21H
	
    MOV AH,2
    ADD SHANG,30H
    MOV DL,SHANG
    INT 21H
	
    MOV AH,2
    ADD YU,30H
    MOV DL,YU
    INT 21H

    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
