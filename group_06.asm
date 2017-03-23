TITLE Add and Subtract (AddSub.asm)
INCLUDE Irvine32.inc

.data

	inputNumber BYTE 80 DUP(0);
	initialStr BYTE 'Input the Winning Numbers (Input 0 to start to check the (winning)numbers )', 0
	repeatInput BYTE 'Input your Number ( Input the last three of number or input 0 to exit) :', 0
	SorryMessage BYTE 'No match any Winning Numbers', 0
	happyMessage BYTE '!!!!!!!!!!!!!!!  Match (You already earn money) ^_^  !!!!!!!!!!!!!!', 0
	popMessage BYTE 'Attention you match the Winning number', 0
	specialMessage BYTE '!!!!!!!!!!!!!!!  Match  (Specail Number You have to match each number) !!!!!!!!!!', 0
	message BYTE "Do you want to quit?",0
	answer DWORD 6
	S DWORD 0,0;
	array DWORD ?;

.code

main PROC
	mov  esi , offset array			; 把將要存進去的 陣列給esi
	mov  ecx , 0					; 初始化計數
	mov edx ,offset initialStr		; 準備印字串
	call WriteString
	call Crlf
	mov ebx , 0
InputWinNumber:
	call ReadDec  					;讀取使用者輸入的本期中獎號碼 (存在 eax)
	cmp eax , ebx 					;如果使用者輸入0 就開始進行對獎程序
	je InputyourNumber
	add ecx , 1						; 計說 使用者總共輸入幾組 中獎號碼
	mov  [esi] , eax 				; 存入array 中
	add esi , TYPE array;			; 移動array index
	jmp InputWinNumber

InputyourNumber:
	mov edx ,offset repeatInput
	call WriteString
	call Crlf
	call ReadDec  					; 讀取使用者輸入待對獎號碼
	cmp eax , 0						; 如果使用者輸入 0 就跳到 詢問是否結束程式
	jz end_program
	mov ebx , eax 					;  將使用者輸入待對獎號碼 存在 ebx

	mov S , ecx						; 將特別獎做個標記 (第一個 輸入的中獎號碼)
	sub ecx , 1
	mov S+4 , ecx;					; 將特別獎做個標記 (第二個 輸入的中獎號碼)
	add ecx , 1
	mov esi , OFFSET array			; 待測 中獎發票(array offset)   存在 esi
	mov edi , 1000 
	push ecx

CompareTheNumber:
	mov edx , 0;					; 準備進行除法 edx:eax 另edx為0
	mov eax , [esi] 				; 中獎號碼存入 eax  (除法目的為取得末三碼)
	div edi
	cmp ecx , S;					; 確認是不是特獎 
	je specialNumber
	cmp ecx , S+4;					; 確認是不是特獎 
	je specialNumber
	cmp edx, ebx					; 確認有沒有中獎
	jz happy
	jmp next
specialNumber:						; 確認是特獎的時候 在看有沒有中
	cmp edx, ebx
	jz veryhappy
next:
	add esi , TYPE array			; array index +1
	loop CompareTheNumber			; loop 所有中獎的號碼

	mov edx ,offset SorryMessage    ; 到此就是沒中獎 並且印出 抱歉訊息
	call WriteString				
	call Crlf
	pop ecx
	jmp InputyourNumber

happy:              				;-------------------  一般中獎------------------
	mov  eax,yellow+(red*16)		; 讓輸入的字有顏色
    call SetTextColor				
	mov edx ,offset happyMessage 	
	call WriteString
	call Crlf
	mov eax , [esi]					; 把對中的號碼輸出 給使用者確認
	call WriteDec
	call Crlf
	mov edx ,offset happyMessage  
	call WriteString
	call Crlf
	mov  eax,white+(black*16)		; 讓字恢復原有的顏色
    call SetTextColor
    mov  edx,OFFSET popMessage 	; 彈跳出提醒視窗
    mov  ebx,OFFSET popMessage                 
    call MsgBox
    pop ecx
	jmp InputyourNumber
veryhappy:          				;--------------------  特別中獎 (特獎)------------
	mov  eax,yellow+(red*16)		; 讓輸入的字有顏色
    call SetTextColor
	mov edx ,offset specialMessage 
	call WriteString
	call Crlf
	mov eax , [esi]					; 把對中的號碼輸出 給使用者確認
	call WriteDec
	call Crlf
	mov edx ,offset specialMessage 
	call WriteString
	call Crlf
	mov  eax,white+(black*16)		; 讓字恢復原有的顏色
    call SetTextColor
    mov  edx,OFFSET popMessage	; 彈跳出提醒視窗
    mov  ebx,OFFSET popMessage                
    call MsgBox
    pop ecx
	jmp InputyourNumber

end_program:
	  mov  edx,OFFSET message 			;確認是否要離開
      mov  ebx,OFFSET happyMessage                       
      call MsgBoxAsk
      cmp  answer,eax
      je  real_end  					;YES 就結束程式
      jmp InputyourNumber				;NO 繼續輸入
real_end:
	exit
main endp

end main

