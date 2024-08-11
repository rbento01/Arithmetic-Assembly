name "testePrematura"   ; output file name (max 8 chars for DOS compatibility)

org  100h	; set location counter to 100h

;mov ax,5
;mov cx,8
;                                
;shl ax,4
;add ax,cx
;
;
;mov dx,ax
;xor ax,ax

array1 db 5,1,7,6,3,4 
lengthArray db 6 
arrayNovo db ? 
;                                                  ;
;;;;;;;;;;;;;;;;;;FORMA COM O * 10;;;;;;;;;;;;;;;;;;
; 
xor ax,ax
xor bx,bx
xor cx,cx
xor dx,dx 

lea si, array1              ;si = {5,2}
     
juntarNumeros:   
    
    mov ax,10               ;ax = 10
         
    
    mul [si]                ;ax = ax * si[0] <=> ax = 10 * 5 <=> ax = 50
           
    inc si                  ;Vai para o segundo indice
    inc dl                  ;cl = 1         Contador que vai ver quantos algarismos aumentou
       
    add ax, [si]            ;ax = ax + si[1] <=> ax = 50 + 2 <=> ax = 52 
    inc dl                  ;cl = 2
    
    mov arrayNovo[bx], al   ;movendo os valores juntos para um novo array
    inc bx                  ;aumentando indice do array novo 
    inc si                  ;aumentado o indice do array
                                                                         
    cmp dl, lengthArray ;if(cl=tamanho do array) Se for sai, faz-se isto para ver se ja chegou ao ultimo numero do array
    je end 
   
   
    loop juntarNumeros  
    
end:
    ret