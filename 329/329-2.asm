data segment
    crlf db 0dh,0ah,'$'
data ends
code segment
    assume cs:code,ds:data
    main proc far
start:
        mov ax,data
        mov ds,ax

        mov ah,01h
        int 21h
        sub al,30h
        mov ch,al

        int 21h
        sub al,30h
        mul ch
        mov bx,ax

        mov ah,09h
        lea dx,crlf
        int 21h

        mov ax,bx
        mov cl,0ah
        mov bl,0
L1:
        inc bl
        div cl
        add ah,30h
        push ax
        mov ah,0
        cmp al,0
        ja L1

        mov ah,02h
        mov ch,0
        mov cl,bl
L2:
        pop dx
        mov dl,dh
        int 21h
        loop L2

        mov ax,4c00h
        int 21h
    main endp
code ends
end start
