data segment
    gm_x dw 0;Graphic Memory x
    gm_y dw 0;Graphic Memory y
    p0 dw 0
    p1 dw 1
    msg0 db 'Primes:$'
    msg1 db 'Count:$'
    msg2 db 'Summary:$'
data ends

code segment
    assume cs : code, ds : data
    main proc far
start:
        mov ax, data
        mov ds, ax

        ;cls
        call clear_screen

        ;print(msg0)
        lea si,msg0
        call print_string

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
            call sleep_long
            pop ax
            ;dx+=cx
            add dx,cx
            ;++ax
            inc ax
main_loop_end:            
        inc cx
        cmp cx,64h
        jle main_loop

        ;println_string(msg1)
        call sleep_long
        call print_line
        lea si,msg1
        call print_string
        ;println_decimal(ax)
        call print_line
        call print_decimal
        ;println_string(msg2)
        call sleep_long
        call print_line
        lea si,msg2
        call print_string
        ;println_decimal(dx)
        call print_line
        mov ax,dx
        call print_decimal
        call shine_line

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

        ;if(ax<10) print_char(' ')
        cmp ax,0ah
        jge print_decimal_begin
        push ax
        mov ah,07h
        mov al,' '
        call print_char
        pop ax
print_decimal_begin:
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

    ;param si - address of string
    ;void
    ;protect ax bx cx dx
    print_string proc near
        push ax
        push bx

        ;ah=7
        mov ah,07h

        ;while(ds[si]!='$')
print_string_loop:
            ;print_char(ds[si])
            mov al,ds:[si]
            call print_char
            ;++si
            inc si
        mov bl,ds:[si]
        cmp bl,'$'
        jne print_string_loop

        pop bx
        pop ax
        ret
    print_string endp

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

    ;void
    ;protect ax bx cx dx
    shine_line proc near
        push ax
        push bx
        push cx
        push dx

        ;es=B800H
        mov ax,0b800h;Begin address of Graphic Memory
        mov es,ax
        ;ax=gm_y*80
        mov ax,gm_y
        mov bx,0a0h
        mul bl

        ;bx=0
        mov bx,0
        ;cx=6,while(cx--)
        mov cx,06h
shine_line_loop: 
            call sleep_short    
            ;di=ax
            mov di,ax
            ;cx=gm_x,while(cx--)
            ;protect cx
            push cx
            mov cx,gm_x
shine_line_loop2:
                ;es[di]h=bx?7:0
                mov dx,es:[di]
                mov dh,0
                cmp bx,0
                je shine_line_flag
                add dh,07h
shine_line_flag:
                mov es:[di],dx
                add di,02h        
            loop shine_line_loop2
            pop cx
            ;bx^=1
            xor bx,01h;1->0,0->1
        loop shine_line_loop

        pop dx
        pop cx
        pop bx
        pop ax
        ret
    shine_line endp

    ;param bx sloop time (percentile second)
    ;void
    ;protect ax cx dx
    sleep proc near
        push ax
        push dx

        ;while(bx>0)
sleep_loop:
            ;if(get_percentile_second()!=dx) dx=ax,b--    
            call get_percentile_second
            cmp ax,dx
            je sleep_loop
            mov dx,ax
            sub bx,05h
        cmp bx,0
        jg sleep_loop
        
        pop dx
        pop ax
        ret
    sleep endp

    ;void
    ;protect ax bx cx dx
    sleep_short proc near
        push bx

        ;sleep(30)
        mov bx,1eh
        call sleep

        pop bx
        ret
    sleep_short endp

    ;void
    ;protect ax bx cx dx
    sleep_long proc near
        push bx

        ;sleep(100)
        mov bx,64h
        call sleep

        pop bx
        ret
    sleep_long endp

    ;return ax - percentile second
    ;protect bx cx dx
    get_percentile_second proc near
        push cx
        push dx
        
        ;dh=getSecond(),dl=getPercentileSecond()
        mov ah,2ch
        int 21h
        ;ax=dh*100+dl
        mov ah,0
        mov al,dh
        mov cl,64h
        mul cl
        mov dh,0
        add ax,dx

        pop dx
        pop cx
        ret
    get_percentile_second endp
code ends
end start
