data segment
    ;TODO data here
data ends

extra segment
    ;TODO extra here
extra ends

code segment
    assume cs : code, ds : data, es : extra
    main proc far
start:
        mov ax, data
        mov ds, ax

        mov ax, extra
        mov es, ax

        ;TODO code here

        mov ax, 4c00h
        int 21h
    main endp
code ends
end start
