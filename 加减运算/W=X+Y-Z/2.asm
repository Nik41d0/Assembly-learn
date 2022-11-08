;设W、X、Y、Z均为8位带符号数，要求完成计算表达式W=X+Y-Z。
;当W<0时
;思路:同样是输出两个字符，一个是 负号，一个是运算结果的 绝对值(NEG)
DATAS SEGMENT  
    X DB ?
    SHANG DB ?	;存储负号
    YU DB ?	
DATAS ENDS

STACKS SEGMENT

STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX

    MOV AH,1	;读取第一个数
    INT 21H
    MOV X,AL
	 
    MOV AH,2	;打印 + 号
    MOV DL,"+"
    INT 21H
	
    MOV AH,1	;读取第二个数	
    INT 21H
    ADD X,AL
	
    MOV AH,2
    MOV DL,"-"
    INT 21H
	
    MOV AH,1
    INT 21H   
    SUB X,AL
    SUB X,30H
    NEG X 	;求补，相当于 0-X
    MOV AL,X
	
    MOV AH,2
    MOV DL,"="
    INT 21H
	
    MOV AH,2
    ADD SHANG,"-"
    MOV DL,SHANG
    INT 21H
	
    MOV AH,2
    ADD X,30H
    MOV DL,X
    INT 21H

    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
