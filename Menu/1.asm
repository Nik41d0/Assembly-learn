DATAS SEGMENT
    X1 DB "|****PRESS 1,ADD **************************|",10,13,"$";加法
    X2 DB "|****PRESS 2,NAME INPUT AND OUTPUT ********|",10,13,"$";名字
    X3 DB "|****PRESS 3,The Sum **********************|",10,13,"$";1到N之和
    X4 DB "|****PRESS 4,The Count ********************|",10,13,"$";计数
    X5 DB "|****PRESS 5,Sort *************************|",10,13,"$";20个数中最大值
    X6 DB "|****PRESS 6,Compare String ***************|",10,13,"$"
    X0 DB "|****PRESS 0,EXIT *************************|",10,13,"$";退出
	
    STRING DB 13,10,"Please input your data","$"
    X DB  ?
    Y DB  ?
    Z DB  ?
    
    MESG1 DB 13,10,"what is your name?","$"
    MESG2 DB "?(Y/N)$"
    BUF DB 30,?,30 DUP(?)
	
    SUM DW ?
    N DW ?  
    
    MESG3 DB 13,10,"Please input strings",10,13,"$"
    MESG31 DB 13,10,"Character Number Other",13,10,"$"
    CHAR DB ?
    NUM1 DB ?
    QITA DB ?
    STR1 DB 30,?,30 DUP(?)
	
    MESG4 DB 13,10,"Please input 20 numbers",10,13,"$"
    MESG41 DB 13,10,"Please press Enter to return: ","$"
    NUM2 DW 100 DUP(?)       ;预留100个数组元素
   
    MAX DW ?                ;最大值
    COUNT DW ?              ;数组元素个数
    CHUSHU DW 10            ;分离数据取余数用的10
    ERROR DB 13,10,"Input Error",13,10,"$"
    
    MESG61 DB 13,10,"Please input the first strings:",13,10,"$"
    MESG62 DB 13,10,"Please input the second strings:",13,10,"$"
    STR61 DB 30,?,30 DUP(?)
    STR62 DB 30,?,30 DUP(?)
    LEN61 DB ?
    LEN62 DB ?
    
    ;此处输入数据段代码  
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START1:
    MOV AX,DATAS
    MOV DS,AX
    MOV ES,AX
    MOV SI,0
    MOV DI,0
START: 
	CALL MENU
LP10:     
    CALL OPT1     
    
LP2:
    CALL OPT2 
    JMP START
  	
LP30:
    MOV AX,0
    MOV BX,0
    CALL OPT3
    JMP START
    
LP4:	
    CALL OPT4
    JMP START
	
LP5:	
    CALL OPT5
    JMP START
LP6:
    CALL OPT6
    JMP START
	
EXIT:    
    MOV AH,4CH
    INT 21H

MENU PROC
    MOV AH,9
    LEA DX,X1
    INT 21H
    MOV AH,9
    LEA DX,X2
    INT 21H  
    MOV AH,9
    LEA DX,X3
    INT 21H
    MOV AH,9
    LEA DX,X4
    INT 21H
    MOV AH,9
    LEA DX,X5
    INT 21H 
    MOV AH,9
    LEA DX,X6
    INT 21H  
    MOV AH,9
    LEA DX,X0
    INT 21H     
    
    MOV AH,1
    INT 21H
    CMP AL,"1"
    JE  LP10
    CMP AL,"2"
    JE  LP2
    CMP AL,"3"
    JE LP30
    CMP AL,"4"
    JE LP4
    CMP AL,"5"
    JE LP5
    CMP AL,"6"
    JE LP6
    CMP AL,"0"
    JE EXIT
    JMP START
MENU ENDP

OPT1 PROC
LP11: 
    MOV AH,9   
    LEA DX,STRING
    INT  21H
    MOV AH,2  
    MOV DL,13
    INT 21H 
    MOV AH,2  
    MOV DL,10
    INT 21H 
    
    MOV AH,1
    INT 21H
    
    CMP AL,27
    JZ  START    ;按ESC键返回菜单
    
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
    JMP LP11   
OPT1 ENDP

OPT2 PROC 
LP21:     ;名字判断
    MOV AH,9
    LEA DX,MESG1
    INT 21H
    MOV AH,10
    MOV DX,OFFSET BUF  ;DX为缓冲区首址，DX+1实际键入字符数
    INT 21H
    MOV BL,BUF+1
    MOV BH,0
    MOV SI,OFFSET BUF+2
    MOV BYTE PTR [BX+SI],"$"
    
    MOV AH,2
    MOV DL,10
    INT 21H
    MOV AH,9
    MOV DX,OFFSET BUF+2  ;在下一行显示名字
    INT 21H
    MOV AH,9
    MOV DX,OFFSET MESG2   ;同行显示？（Y/N）
    INT 21H

    MOV AH,1
    INT 21H
    CMP AL,'y'
    JNE LP21
    
    MOV AH,2
    MOV DL,10
    INT 21H  
  	RET
OPT2 ENDP

OPT3 PROC
LP31:
    INC BX
    ADD AX,BX	
    CMP AX,500
    JLE LP31
	
    MOV SUM,AX
    MOV N,BX
	
    MOV AX,SUM
    MOV BL,100
    IDIV BL
    ADD AX,30H
    MOV BX,AX
	
    MOV AH,2
    MOV DL,13
    INT 21H
    MOV AH,2
    MOV DL,10
    INT 21H	
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
	MOV AH,2
	MOV DL,10
	INT 21H
	RET
OPT3 ENDP

OPT4 PROC
    MOV AH,9
    LEA DX,MESG3
    INT 21H
    MOV AH,10
    LEA DX,STR1
    INT 21H
	
    MOV BL,STR1+1
    MOV BYTE PTR [STR1+2+BX],"$" 
	
    MOV CX,0
    MOV CL,STR1+1
    MOV BX,0
LP41:
    MOV BL,CL
    .IF [STR1+BX]>="A" && [STR1+BX]<="Z" || [STR1+BX]>="a" && [STR1+BX]<="z"        
        INC CHAR
    .ELSEIF [STR1+BX]>="0" && [STR1+BX]<="9"
        INC NUM1
    .ELSE
        INC QITA
    .ENDIF
    LOOPNZ LP41
	
    MOV AH,9
    LEA DX,MESG31
    INT 21H
    MOV BX,0
    MOV CX,3
LP42:
    MOV AH,2
    MOV DL,[CHAR+BX]
    ADD DL,30H
    INT 21H
    MOV AH,2
    MOV DL,32
    INT 21H
    MOV [CHAR+BX],0
    INC BX
    LOOPNZ LP42
    MOV AH,2	
    MOV DL,10
    INT 21H
    RET
OPT4 ENDP

OPT5 PROC
    MOV AH,9
    LEA DX,MESG4
    INT 21H
    MOV   BX, 0         ;每个从键盘接收的多位数最终放BX，再送内存单元NUM2
LP51:  
    MOV   AH, 1
    INT   21H
    CMP   AL,32          ;按空格输入下一组数据
    JZ    LP52
    PUSH AX              ;保护AX，用与判断是不是回车
    CMP   AL,13
    JZ    LP52           ;回车结束，但要继续累计个数并保存
    SUB   AL,30H         
      
    JL    ERROR1         ; <0 报错 重新输入
    CMP   AL, 9
    JG    ERROR1         ; >9 报错 重新输入
    CBW
    XCHG  AX, BX         ;把从键盘输入的多个数字字符转换为真正的数值
    MOV   CX, 10
    MUL   CX
    XCHG  AX, BX
    ADD   BX, AX
     
    JMP LP51  
LP52:  
    MOV   NUM2[SI],BX     ;把输入的元素送内存单元中   
    MOV   BX,0
    INC   SI
    INC   SI
    INC   DI                ;记录输入的数组元素个数
    MOV   COUNT,DI          ;存数组元素个数
    POP   AX
    CMP   AL,13
    JZ    LP53
    JMP   LP51 
LP53:  
    MOV	CX,DI            ;冒泡法排序
    DEC	CX               ;比较遍数
LOOP1: 
    MOV DX,CX            ;保存外循环的循环次数也可以做内循环计数
    MOV	BX,0
LOOP2:
    MOV  AX, NUM2[BX] 
    CMP  AX,NUM2[BX+2]
    JLE	L
    XCHG  AX,NUM2[BX+2]
    MOV   NUM2[BX],AX
L:  
    ADD BX,2 
    LOOP LOOP2
    MOV CX,DX     
    LOOP LOOP1
    
    MOV AH,2
    MOV DL,13
    INT 21H
    CALL TERN     ;子程序调用，处理商和余数  	
    
    MOV AH,9
    LEA DX,MESG41
    INT 21H
    MOV AH,1
    INT 21H
    CMP AL,13
    JE START
    RET
ERROR1: 
    MOV AH,9
    LEA DX,ERROR
    INT 21H
    JMP LP51
OPT5 ENDP

TERN PROC  ;入栈的方法:入栈的是余数
    MOV CX,COUNT          
    MOV SI,0      ;地址指针变化    
LP04:   
    PUSH CX       ;此CX控制元素输出
    MOV BX,NUM2[SI]
    MOV CX,0      ;此CX用于记录每个元素在分离时入栈次数
LP05:		
    MOV AX,BX
    CWD
    DIV CHUSHU
			
    PUSH DX       ;入栈的是余数
    MOV BX,AX     ;保存商
    INC CX        ;入栈次数
    CMP AX,0      ;商不为0,继续送BX除10
    JNZ LP05	
LP06:		
    POP DX        ;;全部分离完,出栈依次从高到低显示
    MOV AH,2
    ADD DL,30H
    INT 21H
    LOOP LP06     
	
    MOV AH,2
    MOV DL,32    ;输出的元素用空格分隔
    INT 21H
             
    ADD SI,2     ;地址指针移动,取下一个数  
    POP CX	
    LOOP LP04
    RET
TERN ENDP

OPT6 PROC
    MOV AH,9
    LEA DX,MESG61
    INT 21H
    MOV AH,10	
    LEA DX,STR61
    INT 21H
    MOV BX,0
    MOV BL,STR61+1	
    MOV LEN61,BL	
    MOV [BX+STR61+2],BYTE PTR "$"
	
    MOV AH,9
    LEA DX,MESG62
    INT 21H
    MOV AH,10
    LEA DX,STR62
    INT 21H
    MOV BX,0
    MOV BL,STR62+1
    MOV LEN62,BL
    MOV [BX+STR62+2],BYTE PTR "$"	
    .IF LEN61 >= BL
        MOV AL,LEN61
        SUB AL,BL
        LEA SI,[STR61+AX+2]
        LEA DI,[STR62+2] 
    .ELSE
        SUB BL,LEN61
        LEA SI,[STR61+2]
        LEA DI,[STR62+BX+2]
    .ENDIF
    CLD
    MOV CL,LEN61
    REPE CMPSB
    JZ LET1
    MOV DL,"N"
    JMP PRINT
LET1:
    MOV DL,"Y"
PRINT:
    MOV BL,DL
	
    MOV AH,2
    MOV DL,10
    INT 21H
    MOV AH,2
    MOV DL,BL
    INT 21H
    MOV AH,2
    MOV DL,10
    INT 21H
    RET
OPT6 ENDP

CODES ENDS
    END START1
