data segment
    x db 2
    y db 3
    z db 5
    s1 db 'Quotient is $'
    s2 db 0dh,0ah,'Remainder is $'
data ends
code segment
    assume cs:code,ds:data
    main proc far
start:
        ;ds=data
        mov ax,data
        mov ds,ax

        ;(al,ah)=(x+y+z)/3
        mov ah,0h
        mov al,x
        add al,y
        add al,z
        mov bl,03h
        div bl

        ;(bh,bl)=(ah+30H,al+30H)
        mov bx,ax
        add bl,30h
        add bh,30h

        ;write(s1)
        mov ah,09h
        lea dx,s1
        int 21h

        ;write(bl)
        mov ah,02h
        mov dl,bl
        int 21h

        ;write(s2)
        mov ah,09h
        lea dx,s2
        int 21h

        ;write(bh)
        mov ah,02h
        mov dl,bh
        int 21h

        ;exit(0)
        mov ax,4c00h
        int 21h
    main endp
code ends
end start