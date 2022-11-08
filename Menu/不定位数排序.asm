;实现了 不定位数、不定个数 的从小到大排序(当然要在寄存器的存储范围内)，以 空格 为间隔，以 回车 表示输入完毕
DATAS SEGMENT
    MESG4 DB 13,10,"Please input 20 numbers",10,13,"$"
    NUM2 DW 100 DUP(?)       ;预留100个数组元素
    MAX DW ?                ;最大值
    COUNT DW ?              ;数组元素个数
    CHUSHU DW 10            ;分离数据取余数用的10
    ERROR DB 13,10,"Input Error",13,10,"$"
DATAS ENDS

STACKS SEGMENT

STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
LP5:	
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
    LEA DX,MESG4
    INT 21H
    MOV AH,1
    INT 21H
    CMP AL,13
    JE START
    JMP EXIT
ERROR1: 
    MOV AH,9
    LEA DX,ERROR
    INT 21H
    JMP START
    
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


EXIT:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
