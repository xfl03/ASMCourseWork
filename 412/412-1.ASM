data segment
    arr dw 10h, 35h, 78h, -82h, 478h, -62h, 340h
    len dw ($ - arr) / 2
    crlf db 0dh, 0ah, '$'
data ends
code segment
    assume cs : code, ds : data
    main proc far
start:
        mov ax, data
        mov ds, ax

        mov cx, len
        mov bx, 7fffh
L1:
        lodsw
        cmp ax, bx
        jge L2
        mov bx, ax
L2:
        loop L1

        call far ptr p10
        call far ptr p2
        call far ptr p16

        mov ax, 4c00h
        int 21h
    main endp
code ends
io segment
    assume cs : io
    pneg proc near
        cmp bx, 0
        jge pneg_L1
        neg bx
        mov ah, 02h
        mov dl, '-'
        int 21h
pneg_L1:
        ret
    pneg endp
    pn proc near
        mov cx, 0
pn_L1:
        mov dx, 0
        div bx
        push dx
        inc cx
        cmp ax, 0
        jg pn_L1
        
        mov ah, 02h
pn_L2:
        pop bx
        mov dl, bl
        cmp dl, 0ah
        jl pn_L3
        add dl, 07h
pn_L3: 
        add dl, 30h
pn_L4:
        int 21h
        loop pn_L2

        ret
    pn endp
    pc proc near
        mov ah, 02h
        int 21h
        ret
    pc endp
    ps proc near
        mov ah, 09h
        int 21h
        ret
    ps endp
    pl proc near
        lea dx, crlf
        call ps
        ret
    pl endp

    p2 proc far
        push bx
        call pneg

        mov ax, bx
        mov bx, 02h
        call pn
        mov dl, 'B'
        call pc
        call pl

        pop bx
        ret
    p2 endp
    p10 proc far
        push bx
        call pneg

        mov ax, bx
        mov bx, 0ah
        call pn
        mov dl, 'D'
        call pc
        call pl

        pop bx
        ret
    p10 endp
    p16 proc far
        push bx
        call pneg

        mov ax, bx
        mov bx, 10h
        call pn
        mov dl, 'H'
        call pc
        call pl

        pop bx
        ret
    p16 endp
io ends 
end start
