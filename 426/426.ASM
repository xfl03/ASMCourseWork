data segment
    gm_x dw 0;Graphic Memory x
    gm_y dw 0;Graphic Memory y
    p0 dw 0
    p1 dw 1
data ends

code segment
    assume cs : code, ds : data
    main proc far
start:
        mov ax, data
        mov ds, ax

        ;cls
        call clear_screen

        ;ax=0
        mov ax,0;counter
        ;cx=0
        mov cx,2
        ;dx=0
        mov dx,0;sum
        ;for(cx=2;cx<=100;++cx)
main_loop:
            ;if(is_prime(cx)==0) continue
            ;protect ax
            push ax
            mov ax,cx
            call is_prime
            pop ax
            cmp bx,0
            je main_loop_end
            ;if(ax%10==0) println
            ;protect ax
            push ax
            mov bx,0ah
            div bl
            cmp ah,0
            jne main_flag
            call print_line
main_flag:
            ;print(cx)
            mov ax,cx
            call print_decimal
            pop ax
            ;dx+=cx
            add dx,cx
            ;++ax
            inc ax
main_loop_end:            
        inc cx
        cmp cx,64h
        jle main_loop

        ;println_decimal(ax)
        call print_line
        call print_decimal
        ;println_decimal(dx)
        call print_line
        mov ax,dx
        call print_decimal

        mov ax, 4c00h
        int 21h
    main endp

    ;param ax - number
    ;return bx - 1 is prime / 0 not prime
    ;protect cx dx
    is_prime proc near
        push cx
        push dx

        ;if(ax==2) return 1
        cmp ax,02h
        je is_prime_end1

        ;dx=ax
        mov dx,ax

        ;for(cx=2;cx<dx;++cx)
        mov cx,02h
is_prime_loop:
            ;ax=dx
            mov ax,dx
            ;ah=al%cl
            div cl
            ;if(ah!=0) continue
            cmp ah,0
            jne is_prime_loop_end
            ;return 0
            mov bx,0
            jmp is_prime_end
is_prime_loop_end:            
        inc cx 
        cmp cx,dx
        jb is_prime_loop

is_prime_end1:
        ;return 1
        mov bx,01h
is_prime_end:
        pop dx
        pop cx
        ret
    is_prime endp

    ;param ax - number
    ;void
    ;protect bx cx dx
    print_decimal proc near
        push bx
        push cx
        push dx

        ;cx=0
        mov cx,0

        ;while(ax>0)
print_decimal_loop1:
            ;ax=ax/10,dx=ax%10
            mov dx,0
            mov bx,0ah
            div bx
            ;++cx
            inc cx
            ;push(dx)
            push dx
        cmp ax,0
        jg print_decimal_loop1

        ;for(;cx>0;--cx)
print_decimal_loop2:
            ;pop(ax)
            pop ax
            ;ah=07h
            mov ah,07h
            ;al+=30h
            add al,30h
            ;print_char(ax)      
            call print_char
        loop print_decimal_loop2       

        ;print_char(' ')
        mov al,' '
        call print_char

        pop dx
        pop cx
        pop bx
        ret
    print_decimal endp

    ;param ah - print mode
    ;param al - char
    ;void
    ;protect bx cx dx
    print_char proc near
        push bx

        ;setchar(gm_x,gm_y)
        mov bx,gm_x
        mov p0,bx
        mov bx,gm_y
        mov p1,bx
        call set_char
        ;++gm_x
        inc gm_x

        pop bx
        ret
    print_char endp

    ;void
    ;protect ax bx cx dx
    print_line proc near
        push ax

        ;gm_x=0
        mov ax,0
        mov gm_x,ax
        ;++gm_y
        inc gm_y

        pop ax
        ret
    print_line endp
    
    ;param ah - print mode
    ;param al - char
    ;param p0 - x
    ;param p1 - y
    ;void
    ;protect bx cx dx
    set_char proc near
        push bx
        push cx
        push dx

        ;es=B800H
        mov bx,0b800h;Begin address of Graphic Memory
        mov es,bx
        ;di=y*80*2+x*2
        ;protect ax
        push ax
        mov ax,p1
        mov bx,0a0h
        mul bl
        mov dx,ax
        mov ax,p0
        mov bx,02h
        mul bl
        add ax,dx
        mov di,ax
        pop ax
        ;es[di]=ax
        mov es:[di],ax

        pop dx
        pop cx
        pop bx
        ret
    set_char endp

    ;void
    ;protect ax bx cx dx 
    clear_screen proc near
        push ax
        push bx

        ;es=B800H
        mov ax,0b800h;Begin address of Graphic Memory
        mov es,ax
        ;ax=0
        mov ax,0

        ;for(cx=4000;cx>0;cx--)
        mov cx,0fa0h
clear_screen_loop:
            ;es[ax]=0
            mov di,ax
            mov bx,0
            mov es:[di],bx            
            ;++ax
            inc ax
        loop clear_screen_loop       

        pop bx
        pop ax
        ret
    clear_screen endp
code ends
end start
