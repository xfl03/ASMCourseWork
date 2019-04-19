data segment
    msg1 db ' OK$'
    msg2 db ' Match$'
    msg3 db ' Not Match$'
    msg4 db ' Yes$'
    msg5 db ' No$'
    msg6 db ' Invaild Input$'

    crlf db 0dh, 0ah, '$'

    str1 db 'China'
    str1_len dw $ - str1
    str3 db 'Computer'
    str3_len dw $ - str3
data ends

extra segment
    buf1 db 10 dup(?)
    buf2 db 20 dup(?)
    buf3 db 'Computor'
extra ends

code segment
    assume cs : code, ds : data, es : extra
    main proc far
start:
        mov ax, data
        mov ds, ax

        mov ax, extra
        mov es, ax

Lbegin:
        mov ah, 01h
        int 21h
        mov bl, al
        sub bl, 30h
        mov ah, 09h

        cmp bl, 0
        jne L0

        jmp Lend
L0:
        cmp bl, 01h
        jne L1

        lea si, str1
        lea di, buf1
        mov cx, str1_len
        cld
        rep movsb

        lea dx, msg1
        int 21h
        jmp L5
L1:
        cmp bl, 02h
        jne L2

        lea di, buf2
        mov al, 'A'
        mov cx, 20
        cld
        rep stosb

        lea dx, msg1
        int 21h
        jmp L5
L2:
        cmp bl, 03h
        jne L3

        lea si, str3
        lea di, buf3
        cld
        mov cx, str3_len
        repe cmpsb
        jz L21
        lea dx, msg3
        jmp L22
        jmp L5
L21:
        lea dx, msg2
L22:
        int 21h
        jmp L5
L3:
        cmp bl, 04h
        jne L4

        lea di, str3
        mov cx, str3_len
        cld
        repne scasb
        jz L31
        lea dx, msg5
        jmp L32
L31:
        lea dx, msg4
L32:
        int 21h
        jmp L5
L4:
        lea dx, msg6
        int 21h
L5:
        lea dx, crlf
        int 21h
        jmp Lbegin
Lend:    
        mov ax, 4c00h
        int 21h
    main endp
code ends
end start
