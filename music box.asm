DATA SEGMENT 
    MENU DB 0DH, 0AH, 'Choose the song you want and press the key:'
    DB 0DH, 0AH, '1: Senbon Zakura'
	DB 0DH, 0AH, '2: Merry Christmas Mr. Lawrence'
	DB 0DH, 0AH, '3: Bad Apple!!'
	DB 0DH, 0AH, 'q: EXIT'             ;退出
	DB 0AH, 0AH, '$'
		 
music1_frequency DW 393, 441, 294, 262, 294, 262, 393, 441, 294, 262, 294, 262
	DW 393, 441, 294, 262, 294, 262, 350, 330, 350, 330, 294, 262
	DW 393, 441, 294, 262, 294, 262, 393, 441, 294, 262, 294, 262
	DW 393, 441, 525, 700, 661, 700, 661, 589, 525, 441
    DW 393, 441, 294, 262, 294, 262, 393, 441, 294, 262, 294, 262
	DW 393, 441, 294, 262, 294, 262, 350, 330, 350, 330, 294, 262
	DW 294, 262, 294, 350, 294, 350, 441, 393, 441, 525, 441, 525
    DW 700, 661, 700, 661, 589, 525, 589
    DW 0
music1_time DW 12, 12, 6, 6, 6, 6, 12, 12, 6, 6, 6, 6
    DW 12, 12, 6, 6, 6, 6, 12, 12, 3, 3, 6, 12
    DW 12, 12, 6, 6, 6, 6, 12, 12, 6, 6, 6, 6
    DW 12, 12, 12, 12, 6, 6, 6, 6, 12, 12
    DW 12, 12, 6, 6, 6, 6, 12, 12, 6, 6, 6, 6
    DW 12, 12, 6, 6, 6, 6, 12, 12, 3, 3, 6, 12
    DW 12, 6, 6, 12, 6, 6, 12, 6, 6, 12, 6, 6
    DW 12, 6, 3, 3, 12, 12, 24
    DW 0
	
music2_frequency DW 294, 330, 294, 221, 294
    DW 221, 330, 294, 330, 393, 330
    DW 294, 330, 294, 221, 262
    DW 525, 495, 393, 330
    DW 294, 330, 294, 221, 294
    DW 294, 330, 294, 330, 393, 330
    DW 294, 330, 294, 262, 221, 221
    DW 221, 196
    
    DW 589, 661, 589, 441, 589
    DW 589, 661, 589, 661, 786, 661
    DW 589, 661, 589, 441, 525
    DW 1050, 990, 786, 661
    DW 589, 661, 589, 441, 589
    DW 589, 661, 589, 661, 786, 661
    DW 589, 661, 589, 525, 441
    DW 330, 330, 262
    DW 0
music2_time DW 12, 12, 12, 12, 72
    DW 12, 12, 12, 12, 12, 12
    DW 12, 12, 12, 12, 72
    DW 24, 12, 12, 24
    DW 12, 12, 12, 12, 72
    DW 12, 12, 12, 12, 12, 12
    DW 12, 12, 12, 12, 24, 24
    DW 48, 48

    DW 12, 12, 12, 12, 72
    DW 12, 12, 12, 12, 12, 12
    DW 12, 12, 12, 12, 72
    DW 24, 12, 12, 24
    DW 12, 12, 12, 12, 72
    DW 12, 12, 12, 12, 12, 12
    DW 12, 12, 12, 12, 48
    DW 48, 24, 24

music3_frequency DW 294, 330, 350, 393, 441, 589, 525
	DW 441, 294, 441, 393, 350, 330
	DW 294, 330, 350, 393, 441, 393, 350
	DW 330, 294, 330, 350, 330, 294, 262, 330
    DW 294, 330, 350, 393, 441, 589, 525
	DW 441, 294, 441, 393, 350, 330
	DW 294, 330, 350, 393, 441, 393, 350
	DW 330, 350, 393, 441
	DW 0	
music3_time DW 12, 12, 12, 12, 24, 12, 12
    DW 24, 24, 12, 12, 12, 12
    DW 12, 12, 12, 12, 24, 12, 12
    DW 12, 12, 12, 12, 12, 12, 12, 12
    DW 12, 12, 12, 12, 24, 12, 12
    DW 24, 24, 12, 12, 12, 12
    DW 12, 12, 12, 12, 24, 12, 12
    DW 24, 24, 24, 24
    DW 0
DATA ENDS

CODE SEGMENT                                                
    ASSUME DS:DATA, CS:CODE 

START:
    MOV AX, DATA
	MOV DS, AX  
	MOV AH, 0
	MOV AL, 0
	  
INPUT:                      ;控制音乐播放的主程序
    LEA DX, MENU
	MOV AH, 9               ;调用9号中断，将菜单显示在屏幕上
	INT 21H                 ;显示菜单  
	MOV AH, 1
	INT 21H                 ;调用1号中断，输入播放哪首音乐或者退出播放
	  
stop_music:
    CMP AL, 'q'             ;若输入的字符为q，则中断，停止播放音乐
	JZ end_music
	    
music1:      
    CMP AL, '1'
    JNZ music2              ;若输入的数字不为1，跳转到音乐2的子程序接着判断
    lea SI, music1_frequency;将音乐1频率的偏移地址赋值给SI
    lea BP, music1_time     ;将音乐1节拍的偏移地址赋值给BP
    CALL play_music         ;调用播放音乐子程序
    JMP INPUT               ;循环继续输入，直至按下‘q’，即退出播放

music2:      
    CMP AL, '2'
    JNZ music3              ;若输入的数字不为2，跳转到音乐3的子程序接着判断
    lea SI, music2_frequency;将音乐2频率的偏移地址赋值给SI
    lea BP, music2_time     ;将音乐2节拍的偏移地址赋值给BP
    CALL play_music         ;调用播放音乐子程序
    JMP INPUT               ;循环继续输入，直至按下‘q’，即退出播放

music3:      
    CMP AL, '3'
    JNZ INPUT               ;若输入的数字不为3，跳转继续输入
    lea SI, music3_frequency;将音乐2频率的偏移地址赋值给SI
    lea BP, music3_time     ;将音乐2节拍的偏移地址赋值给BP
    CALL play_music         ;调用播放音乐子程序
    JMP INPUT               ;循环继续输入，直至按下‘q’，即退出播放

end_music:                                                             
    MOV AH, 4CH
    INT 21H




sound proc near
    PUSH AX 
    PUSH BX 
    PUSH CX 
    PUSH DX 
    PUSH DI 

    MOV AL, 0B6H   ;8253 初始化
    OUT 43H, AL    ;43H 是 8253 芯片控制口的端口地址
    MOV DX, 12H    ;高 16 位
    MOV AX, 3280H  ;低 16 位                                        
    DIV DI         ;计算分频值, 赋给 AX, DI 中存放声音的频率值。
    OUT 42H, AL    ;先送低 8 位到计数器，42H 是 8253 定时器 2 的端口地址
    MOV AL, AH 
    OUT 42H, AL    ;后送高 8 位计数器
		
	;设置 8255 芯片, 控制扬声器的开/关
    IN AL, 61H    ;读取 8255 B 端口原值
    MOV AH, AL    ;保存原值
    OR AL, 3      ;使低两位置变为 1，打开开关
    OUT 61H, AL   ;开扬声器, 发声
		
WAIT1:    
    MOV CX, 28000 ;设置一拍的长度                                          
DELAY1:   
        NOP
	LOOP DELAY1
    DEC BX        ;循环 BX 拍
    JNZ WAIT1 

    MOV AL, AH    ;恢复扬声器端口原值
    OUT 61H, AL 
    
    POP DI 
    POP DX 
    POP CX 
    POP BX                                                 
    POP AX 
    RET 
sound ENDP



play_music PROC NEAR   ;播放音乐子程序
    PUSH DS
	SUB AX, AX
    PUSH AX

play_start:
	MOV AH, 1
	INT 16H
	JNZ INPUT
    
    MOV DI, [SI]
	CMP DI, 0       ;判断音符是否为0，为 0 则结束播放音乐子程序
	JE end_play

	MOV BX, [BP]    ;节拍
	CALL sound   
	ADD SI, 2
	ADD BP, 2
	JMP play_start  ;继续执行音乐播放子程序，直至一首音乐结束
	   
end_play:
    RET   
play_music endp
CODE  ENDS 
END START   