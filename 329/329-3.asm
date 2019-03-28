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
        mov cl,al
        sub cl,30h

        mov ah,09h
        lea dx,crlf
        int 21h

        mov ah,02h
L1:
        mov dl,'*'
        int 21h
        loop L1

        mov ax,4c00h
        int 21h
    main endp
code ends
end start