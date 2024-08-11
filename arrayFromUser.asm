org 100h

.data
    array db 100 dup(?)
    msgIn db 13, 10, "Introduza os valores para o Array: $"; enter, linefeed, msg
    msgFi db "O Array contem os valores: $" 
    cont db 0
    aux db 0 
    arrayAux db 100 dup(?)
    
.code
inic:
    mov ax,@data
    mov ds, ax
   
    lea dx, msgIn ; loading the address of msgIn
    mov ah,09h
    int 21h
    
    mov cx, 100 ; going through the loop 4 times
    lea si, array ;loading the address of array

;loop to request 4 numbers to the array    
    loop1:
        mov ah, 01h
        int 21h      
        
        cmp al, 0Dh ;compare the key pressed 
                     ;with the enter ASCII code
        je  rest    ;if enter was pressed jump to "rest"   
        
        mov [si],al                  
        inc si     
        ;mov bx, cont
        inc cont
        loop loop1    
 

rest:       

        mov dl,10  
        mov ah,02
        int 21h
        
;        mov dl,13
;        mov ah,02
;        int 21h
;           
           
        lea dx,msgFi ;loading the address of msgFi
        mov ah,09h
        int 21h
        lea si, array 
 
mov cl, cont 

juntarNumeros:    
    xor ax,ax
    
    mov ax,[si]     ;ax = [0] 
    inc aux         ;aux = 1
    inc si          ;[1]
    mov cx,[si]
    inc aux         ;aux = 2

    shl ax,4
    add ax,cx 
    
    lea di,arrayAux
    inc di  
    mov [di],ax 
    
    mov cl, cont
    
    cmp aux, cl
    je loop2 
   
    loop juntarNumeros
                       
;loop to print the numbers of the array    
    loop2:      
        
        mov dl,[di]
        mov ah,02h
        int 21h
    
        inc si
        loop loop2

finish:
     ret   