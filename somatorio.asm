org 100h        
  
A db 5,8,6
B db 2,3,7
T dw 0
N dw 2

mov bx, 0
SOMA:
    mov al, A[bx]
    add al, B[bx]
    xor ah, ah
    add T, ax
    cmp bx, N
    je sai 
    inc bx
    jmp SOMA
    
sai:

