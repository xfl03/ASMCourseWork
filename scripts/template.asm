data segment
    ;TODO data here
data ends

code segment
    assume cs : code, ds : data
    main proc far
start:
        mov ax, data
        mov ds, ax

        ;TODO code here

        mov ax, 4c00h
        int 21h
    main endp
code ends
end start
