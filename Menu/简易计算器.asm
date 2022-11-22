; 减法和除法做得不够好，加法和乘法还凑合
DATAS SEGMENT 
    STR1 DB 13,10,"|**** Press 1 is ADD ****|","$"
    STR2 DB 13,10,"|**** Press 2 is SUB ****|","$"
    STR3 DB 13,10,"|**** Press 3 is MUL ****|","$"
    STR4 DB 13,10,"|**** Press 4 is DIV ****|","$"
    STR0 DB 13,10,"|**** Press 0 is EXIT ***|","$"
    STR5 DB 13,10,"Please input a number:","$"
    STR11 DB 13,10,"Press space to express that the number is entered",13,10,"$"
    ERROR DB 13,13,"INPUT ERROR",13,10,"$"
    X DW ?
    Y DW ?
    CHUSHU DW 10
DATAS ENDS

STACKS SEGMENT
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    MOV ES,AX
    CALL MAIN
L1:
    CALL OPT1
    JMP START
L2:
    CALL OPT2
    JMP START
L3:
    CALL OPT3
    JMP START
L4:
    CALL OPT4
    JMP START
EXIT:
    MOV AH,4CH
    INT 21H

PRINTF MACRO A
    MOV AH,9
    LEA DX,A
    INT 21H
    ENDM
FUHAO MACRO A
    MOV AH,2
    MOV DL,A
    INT 21H
    ENDM
GETNUM PROC	
    MOV   BX, 0         ;每个从键盘接收的多位数最终放BX，再送内存单元NUM2
LP01:  
    MOV AH, 1
    INT 21H
    CMP AL," "
    JE LP02       
    SUB AL,30H
       
    JL    ERROR1        
    CMP   AL, 9
    JG    ERROR1 
          
    CBW
    XCHG  AX, BX         ;把从键盘输入的多个数字字符转换为真正的数值
    MOV   CX, 10
    MUL   CX
    XCHG  AX, BX
    ADD   BX, AX
    JMP LP01
ERROR1: 
    MOV AH,9
    LEA DX,ERROR
    INT 21H
    JMP LP01 
LP02:
    RET 
GETNUM ENDP

PRINT PROC      
    MOV CX,0     ;此CX用于记录每个元素在分离时入栈次数
LP05:		
    MOV AX,BX
    CWD
    DIV CHUSHU	
    PUSH DX       ;入栈的是余数
    INC CX
    MOV BX,AX     ;保存商       
    CMP AX,0    ;商不为0,继续送BX除10
    JNZ LP05
LP06:		
    POP DX        ;;全部分离完,出栈依次从高到低显示
    MOV AH,2
    ADD DL,30H
    INT 21H
    LOOP LP06     
PRINT ENDP

OPT1 PROC
    PRINTF STR11
	
    CALL GETNUM
    MOV X,BX
    FUHAO "+"
	
    CALL GETNUM
    ADD BX,X
    FUHAO "="
	
    CALL PRINT
OPT1 ENDP

OPT2 PROC
    PRINTF STR11
    CALL GETNUM
    MOV X,BX
	
    FUHAO "-"
    CALL GETNUM
    FUHAO "="
	
    SUB BX,X
    MOV X,BX
    AND X,80H
    .IF X==80H
        NEG BX
    .ELSEIF
        FUHAO "-"
    .ENDIF
    CALL PRINT
    RET
OPT2 ENDP

OPT3 PROC
    PRINTF STR11
    CALL GETNUM
    MOV X,BX
	
    FUHAO "*"
	
    CALL GETNUM
    MOV AX,X
    IMUL BX
    MOV BX,AX
	
    FUHAO "="
    CALL PRINT
    RET
OPT3 ENDP

OPT4 PROC
    PRINTF STR11
    CALL GETNUM
    MOV X,BX
	
    FUHAO "/"
    CALL GETNUM
    MOV AX,X
    IDIV BX
    MOV BX,AX
	
    FUHAO "="
    CALL PRINT
    RET
OPT4 ENDP

MAIN PROC
    PRINTF STR1
    PRINTF STR2
    PRINTF STR3
    PRINTF STR4
    PRINTF STR0
    PRINTF STR0
    PRINTF STR5
	
    MOV AH,1
    INT 21H
    CMP AL,"1"
    JE L1
    CMP AL,"2"
    JE L2
    CMP AL,"3"
    JE L3
    CMP AL,"4"
    JE L4
    CMP AL,"0"
    JE EXIT
    JMP START
    RET
MAIN ENDP
CODES ENDS
    END START
