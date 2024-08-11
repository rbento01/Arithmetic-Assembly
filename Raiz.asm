org 100h

.data
    raiz db 100 dup ? 

    contRaiz db 0
    contPontVirg db 0 
    contZero db 0
    
    arrayNovo db 100 dup(0)
    contArrNov db 0
    
    
    ;variaveis e mensagens adicionadas 
    
    msgIn db "Introduza os valores para a raiz: $"; enter, linefeed, msg
    msgFi db 13, 10, "A raiz contem os valores: $" 
  
    erroPontoVirg db 13,10, "Erro, foi introduzido mais do que 1 Ponto Final $"; enter, linefeed, msg 
    erroTecla db 13,10, "Foram introduzidos caracteres invalidos $" 

.code
regRaiz:
    
    
    lea dx, msgIn ; loading the address of msgIn
    mov ah,09h
    int 21h
    
    mov cx, 100 ; going through the loop 100 times
    lea si, raiz ;loading the address of array
    
loopRaiz:
	mov ah, 01h
	int 21h
    sub al,48
	mov [si],al 
	jmp verificaRaiz          

verificaRaiz:      
	add al,48 
	
	add raiz[0],48
	
    cmp raiz[0], 2Ch
    je erroPontVirg
                      
    cmp raiz[0], 2Eh
    je erroPontVirg
	
    sub raiz[0],48
    
	cmp al, 0Dh 
	je  enter  

	cmp al, 2Eh
	je pontoFinalVirgula
	
	cmp al, 2Ch
	je pontoFinalVirgula
	
	cmp al, 08h
	je backspace
	
	cmp al,30h
	jb caracterInvalido
	
	cmp al,39h
	ja caracterInvalido 
	 
	inc si 
	inc contRaiz
	
	cmp al, 30h
	je zero
	jmp loopRaiz

zero: 
    inc contZero
    jmp loopRaiz
       
caracterInvalido:  

     lea dx, erroTecla
     mov ah, 09h
     int 21h
     mov contPontVirg, 0
     mov contRaiz, 0
     jmp regRaiz
     
backspace:
    
    dec si
    dec contRaiz
    mov ah, 02h         ; DOS Display character call 
    mov dl, 20h         ; A space to clear old character 
    int 21h             ; Display it  
    mov dl, 08h         ; Another backspace character to move cursor back again
    int 21h             ; Display it 
    jmp loopRaiz        

;adicionado        
pontoFinalVirgula:
     
     inc contPontVirg
     
     mov cl,2
     cmp contPontVirg, cl
     jge erroPontVirg
     
     jmp loopRaiz 

;adicionado     
erroPontVirg:
     
    lea dx, erroPontoVirg
    mov ah,09h
    int 21h
    mov contPontVirg, 0
    mov contRaiz, 0
    jmp regRaiz
    
enter:   
       
    lea dx,msgFi ;loading the address of msgFi
    mov ah,09h
    int 21h
         
    lea si, raiz ;loading the address of array
    xor dx,dx

juntarRaiz:
             
    mov ax,10               ;ax = 10
         
    
    mul [si]                ;ax = ax * si[0] <=> ax = 10 * 5 <=> ax = 50
           
    inc si                  ;Vai para o segundo indice
    inc dl                  ;cl = 1         Contador que vai ver quantos algarismos aumentou
       
    add ax, [si]            ;ax = ax + si[1] <=> ax = 50 + 2 <=> ax = 52 
    inc dl                  ;cl = 2
    
    mov arrayNovo[bx], al   ;movendo os valores juntos para um novo array
    inc bx                  ;aumentando indice do array novo
    inc contArrNov 
    inc si                  ;aumentado o indice do array
                                                                         
    cmp dl, contRaiz ;if(cl=tamanho do array) Se for sai, faz-se isto para ver se ja chegou ao ultimo numero do array
    je loopmostraRaiz 
   
   
    loop juntarRaiz

finish:
    ret

