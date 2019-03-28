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
        mov bl,al
        dec bl

        mov ah,09h
        lea dx,crlf
        int 21h

        mov cl,03h
        mov ah,02h
L1:
        mov dl,bl
        int 21h
        inc bl
        loop L1

        mov ax,4c00h
        int 21h
    main endp
code ends
end start