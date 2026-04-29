
[org 0x0100]
jmp start

score:dw 0
gamename:db 'Flappy Bird$'
name1: db 'HAMZA HUSSAIN $'
name2:db'EESHA IRFAN $'
ins: db'I N S T R U C T I O N S $'
i1: db'1 press enter to play.$'
i2: db'2 the bird will go up as long as you press  the space bar.Once you leave it,it will start going downwards.$'
i3:db '3 avoid the green barriers and green ground.$'
i4: db'4 points will be awarded to you once you successfully pass a barrier.$'
i5 :db'5 press esc to pause the game.$'
i6: db'6 the game will end once you touch the barriers or ground.$'
sem :db 'Semester: Fall 2024 $',0
oldisr: dd 0                ;Storage for old ISR
oldtimer: dd 0

confirm_msg db "Press Y to exit or N to continue...", 0

ScoreBuffer db 5, 0, 0, '$' ; Buffer for the string (up to 3 digits and $ for display

num_counter: dw 0;

birdMoved: db 0

YPressed: db 0
NPressed: db 0

boold: db 'D'               ; Direction of bird

xcord : dw 50
ycord: dw 15

xcord1 : dw 70
ycord1: dw 4

xcord2 : dw 8
ycord2: dw 15

xcord3 : dw 24
ycord3: dw 4

birdx: dw   33
birdy: dw  13

lineno: dw 0

tickCount: db 0

overflow: dw 160

pcb: times 32*16 dw 0 ; space for 32 PCBs
stack: times 32*256 dw 0 ; space for 32 512 byte stacks
nextpcb: dw 1 ; index of next free pcb
current: dw 0 ; index of current pcb

oneSecondFlag: db 0

initpcb: 	push bp
			mov bp, sp
			push ax
			push bx
			push cx
			push si
			
			mov bx, [nextpcb] ; read next available pcb index
			cmp bx, 32 ; are all PCBs used
			je exit ; yes, exit
			
			mov cl, 5
			shl bx, cl ; multiply by 32 for pcb start ix2^5 
			
			mov ax, [bp+8] ; read segment parameter
			mov [pcb+bx+18], ax ; save in pcb space for cs
			mov ax, [bp+6] ; read offset parameter
			mov [pcb+bx+16], ax ; save in pcb space for ip
			mov [pcb+bx+22], ds ; set stack to our segment
			
			mov si, [nextpcb] ; read this pcb index
			mov cl, 9
			shl si, cl ; multiply by 512...ix2^9 (512)
			add si, 256*2+stack ; end of stack for this thread
			mov ax, [bp+4] ; read parameter for subroutine
			sub si, 2 ; decrement thread stack pointer
			mov [si], ax ; pushing param on thread stack
			sub si, 2 ; space for return address
			mov [pcb+bx+14], si ; save si in pcb space for sp
			
			mov word [pcb+bx+26], 0x0200 ; initialize thread flags
			mov ax, [pcb+28] ; read next of 0th thread in ax
			mov [pcb+bx+28], ax ; set as next of new thread
			
			mov ax, [nextpcb] ; read new thread index
			mov [pcb+28], ax ; set as next of 0th thread
			
			inc word [nextpcb] ; this pcb is now used
			
			exit: pop si
			pop cx
			pop bx
			pop ax
			pop bp
			ret 6


clrscr1:
    pusha                  
    mov ax, 0xB800        
    mov es, ax
    mov ah, 0x7F
    mov al, ' ' 	
    xor di, di            
    mov cx, 3200          
loop_screen1:
    mov [es:di], ax         
    add di, 2            
    loop loop_screen1       
    popa                   
    ret  
names:
 pusha 
call clrscr1 
    mov ah, 02h           
    mov bh, 0            
    mov dh, 8             
    mov dl, 10            
    int 10h              
    mov ah, 09h           
    mov dx, name1       
    int 21h

	mov ah, 02h           
    mov bh, 0            
    mov dh, 2         
    mov dl, 30           
    int 10h              
    mov ah, 09h
    mov dx, gamename       
    int 21h
	
	mov ah, 02h           
    mov bh, 0            
    mov dh, 8            
    mov dl, 50            
    int 10h              
    mov ah, 09h           
    mov dx, name2      
    int 21h
	
	mov ah, 02h           
    mov bh, 0            
    mov dh, 10            
    mov dl, 10            
    int 10h              
    mov ah, 09h           
    mov dx, rollno1      
    int 21h
	
	mov ah, 02h           
    mov bh, 0            
    mov dh, 10            
    mov dl, 50            
    int 10h              
    mov ah, 09h           
    mov dx, rollno2     
    int 21h
	
	mov ah, 02h           
    mov bh, 0            
    mov dh, 15            
    mov dl, 28         
    int 10h              
    mov ah, 09h           
    mov dx, sem     
    int 21h	

	popa
	ret
instructions:
call clrscr1
	mov ah, 02h           
    mov bh, 0            
    mov dh, 3           
    mov dl, 30         
    int 10h              
    mov ah, 09h           
    mov dx, ins  
    int 21h	
	
	mov ah, 02h           
    mov bh, 0            
    mov dh, 7            
    mov dl, 2         
    int 10h              
    mov ah, 09h           
    mov dx, i1    
    int 21h	
	
	mov ah, 02h           
    mov bh, 0   
	mov dh, 9           
    mov dl, 2       
    int 10h              
    mov ah, 09h           
    mov dx, i2    
    int 21h	
	mov ah, 02h           
    mov bh, 0   
	mov dh, 12           
    mov dl, 3        
    int 10h              
    mov ah, 09h           
    mov dx, i3    
    int 21h	
	mov ah, 02h           
    mov bh, 0   
	mov dh, 14           
    mov dl, 3        
    int 10h              
    mov ah, 09h           
    mov dx, i4    
    int 21h	
	mov ah, 02h           
    mov bh, 0   
	mov dh, 16           
    mov dl, 3         
    int 10h              
    mov ah, 09h           
    mov dx, i5   
    int 21h	
	mov ah, 02h           
    mov bh, 0   
	mov dh, 18          
    mov dl, 3        
    int 10h              
    mov ah, 09h           
    mov dx, i6    
    int 21h	
	ret
delayBirdDrop:
    pusha
    mov byte [cs:oneSecondFlag], 0
    .delayOneSecond:
        add ax, 0xFFFF
        add ax, 1
        cmp byte [cs:oneSecondFlag], 4
        jge .exit
        jmp .delayOneSecond

    .exit:
        mov byte [boold], 'D'
        mov byte[cs:oneSecondFlag], 0
        popa
        ret

sound:
	pusha
    ; Turn on the speaker
    in al, 61h
    or al, 3h
    out 61h, al

    ; Set the frequency for the beep
    mov al, 0b6h
    out 43h, al
    mov ax, 1193180 / 440 ; Frequency for A4 note
    out 42h, al
    mov al, ah
    out 42h, al

    ;Delay
    call delay
    
    ; Turn off the speaker
    in al, 61h
    and al, 0FCh
    out 61h, al
	popa
	ret


timer:
    pusha
    call sound
    inc byte [cs:oneSecondFlag]
	mov byte al,[boold]
    cmp byte[boold], 'T'
	je check_timer;
	jmp exit_timer;
check_timer:
	 cmp byte [cs:oneSecondFlag], 18
	 jge change_to_d;
	jmp exit_timer;

    mov [pcb+bx+0], ax ; save ax in current pcb
			mov [pcb+bx+4], cx ; save cx in current pcb
			mov [pcb+bx+6], dx ; save dx in current pcb
			mov [pcb+bx+8], si ; save si in current pcb
			mov [pcb+bx+10], di ; save di in current pcb
            push word[pcb+bx+6]
			mov [pcb+bx+12], bp ; save bp in current pcb
			mov [pcb+bx+24], es ; save es in current pcb
            push word[pcb+bx+24]
			mov [pcb+bx+2], ax ; save bx in current pcb
			mov [pcb+bx+20], ax ; save ds in current pcb
            pop ax
			mov [pcb+bx+16], ax ; save ip in current pcb
			mov [pcb+bx+18], ax ; save cs in current pcb
			mov [pcb+bx+26], ax ; save cs in current pcb
            pop bx
			mov [pcb+bx+22], ss ; save ss in current pcb
			mov [pcb+bx+14], sp ; save sp in current pcb
			
			mov bx, [pcb+bx+28] ; read next pcb of this pcb
			mov [current], bx ; update current to new pcb
			mov cl, 5
			shl bx, cl ; multiply by 32 for pcb start
			
			mov cx, [pcb+bx+4] ; read cx of new process
			mov dx, [pcb+bx+6] ; read dx of new process
			mov si, [pcb+bx+8] ; read si of new process
			mov di, [pcb+bx+10] ; read diof new process
			mov bp, [pcb+bx+12] ; read bp of new process
			mov es, [pcb+bx+24] ; read es of new process
			mov ss, [pcb+bx+22] ; read ss of new process
			mov sp, [pcb+bx+14] ; read sp of new process


	change_to_d:
        mov byte [boold], 'D'
        mov byte[cs:oneSecondFlag], 0
		jmp exit_timer;
    ; inc byte [cs:tickCount]     ; Increment tick count
    ; cmp byte [cs:tickCount],3 
    ; jne exit_timer              ; If not 18 ticks, exit the handler

    ; mov byte [cs:tickCount], 0  ; Reset tick counter
	; call wait_for_retrace
    ; call animations             ; Call the animations subroutine

exit_timer:
	mov al, 0x20
	out 0x20, al
    popa
    iret                        ; Return from interrupt

;-------------------------------------------------------------------------------------------------------------------------

                                     ;Spacebar interupt

;-------------------------------------------------------------------------------------------------------------------------

space:
    push ax
    push es

    in al, 0x60             ; Read scan code from keyboard
    
    cmp al, 0x16            ; Check if spacebar is pressed (make code)
    jz key_pressed
    cmp al, 0x96            ; Check if spacebar is released (break code)
    jz key_released
    cmp al, 0x01            ; Check if ESC is pressed
    jz esc_pressed

    jmp done

key_pressed:
    mov byte [boold], 'U'   ; Set boold to 'U' for up
    jmp done

key_released:
    mov byte [boold], 'T'   ; Set boold to 'D' for down
    jmp done

esc_pressed:
    call clrscr             ; Clear the screen
                            ; Display confirmation message
    mov ax, 0xb800          ; Set video memory segment
    mov es, ax
    mov di, 160 * 12 + 30   ; Position at row 12, column 30

    lea si, confirm_msg

.print_message:
    lodsb
    cmp al, 0
    je .wait_choice         ; End of message
    mov ah, 0x0F            ; Set text attribute (white on black)
    mov word [es:di], ax
    add di, 2
    jmp .print_message

.wait_choice:
    mov byte[YPressed], 0
    mov byte[NPressed], 0
    in al, 0x60             ; Wait for another keypress
    cmp al, 0x15            ; Check for 'Y'
    je .YPressed
    cmp al, 0x31            ; Check for 'N'
    je .NPressed
    jmp .wait_choice        ; Loop if invalid key

.YPressed:
    mov byte[YPressed], 1
    jmp done

.NPressed:
    mov byte[NPressed], 1
    jmp done

done:
    pop es
    pop ax
    jmp far [cs:oldisr]     ; Resume the old ISR
    iret

;---------------------------------------------------------------------------------------------------------------
; Clear screen subroutine
;---------------------------------------------------------------------------------------------------------
clrscr:
    pusha
    mov ax, 0xb800         ; Video memory segment
    mov es, ax
    xor di, di             ; Start at the beginning of video memory

loop_clear:
    mov word [es:di], 0x0720 ; 0x07 (black background, grey text), 0x20 (space)
    add di, 2              ; Move to the next character cell
    cmp di, 4000           ; 4000 bytes = 80 columns * 25 rows * 2 bytes per cell
    jne loop_clear         ; Loop until all cells are cleared

    popa
    ret

;-----------------------------------------------------------------------------------------------------------------

; Print barriers subroutine

;-----------------------------------------------------------------------------------------------------------
barriers:
    push bp
    mov bp, sp
    pusha
    cmp word[bp+4], 72
    je normal_case

    cmp word[bp+4], 72
    jnb ifgreater72

normal_case:
    mov al, 80
    mul byte [bp+6]
    add ax, [bp+4]
    shl ax, 1
    mov di, ax
    xor ax, ax

    mov ax, 0xb800
    mov es, ax

    mov dx, 0

printing_height:
    mov cx, 0

printing_barriers_length:
    mov word[es:di], 0x2F20
    add di, 2
    add cx, 1
    cmp cx, 8
    jne printing_barriers_length
    add di, 144
    add dx, 1
    cmp dx, 6
    jne printing_height

    popa
    pop bp
    ret

ifgreater72:
    mov ax, 0xb800
    mov es, ax
    xor ax, ax
    mov al, 80
    mul byte [bp+6]
    add ax, [bp+4]
    shl ax, 1
    mov di, ax
    xor ax, ax

    mov cx, 80
    sub cx, [bp+4]         ; Rows available at the end
    mov dx, 8        
    sub dx, cx             ; Rows for printing on the same row

    shl cx, 1
    sub [overflow], cx
    shr cx, 1

    mov ax, 0

printingheight:
    mov bx, 0

printingbarrierslength:
    mov word[es:di], 0x2F20
    add di, 2
    add bx, 1
    cmp bx, cx
    jne printingbarrierslength
    add di, [overflow]
    add ax, 1
    cmp ax, 6
    jne printingheight

    mov word [overflow], 160

    shl cx, 1
    add di, cx
    shr cx, 1

    sub di, 1120

    shl dx, 1
    sub [overflow], dx
    shr dx, 1

    mov ax, 0

printing.height:
    mov bx, 0

printing.barriers.length:
    mov word[es:di], 0x2F20
    add di, 2
    add bx, 1
    cmp bx, dx
    jne printing.barriers.length
    add di, [overflow]
    add ax, 1
    cmp ax, 6
    jne printing.height

    mov word [overflow], 160

    popa
    pop bp
    ret

;------------------------------------------------------------------------------------------------------------------------
; Print ground and sky
;-------------------------------------------------------------------------------------------------------------------------
ground:
    pusha
    mov di, 0
    mov ax, 0xb800
    mov es, ax

grj1G:
    mov word[es:di], 0x6F20
    add di, 2
    cmp di, 320
    jne grj1G

grj1B:
    mov word[es:di], 0x2F20 
    add di, 2 
    cmp di, 640
    jne grj1B

    mov di, 3360

grj2G:
    mov word[es:di], 0x2F20
    add di, 2
    cmp di, 3680
    jne grj2G

grj2B:
    mov word[es:di], 0x6F20 
    add di, 2 
    cmp di, 4000
    jne grj2B

    popa 
    ret

sky:
    pusha
    mov di, 640
    mov ax, 0xb800
    mov es, ax

sky1:
    mov word[es:di], 0x3F20
    add di, 2
    cmp di, 3360
    jne sky1
    popa
    ret

;-------------------------------------------------------------------------------------------------------------------------
; Animation Effects
;-------------------------------------------------------------------------------------------------------------------------
animations:
    pusha

    ; Update barrier positions
    dec word [xcord]
	push word[xcord]
    call update_score
    pop ax
    call score_printing

	xor ax,ax
    cmp word [xcord], 0
    jge dec_xcord1
    mov word [xcord], 79

dec_xcord1:
    dec word [xcord1]
	push word[xcord1]
    call update_score
    pop ax
    call score_printing

	xor ax,ax
    cmp word [xcord1], 0
    jge dec_xcord2
    mov word [xcord1], 79

dec_xcord2:
    dec word [xcord2]
    push word[xcord2]
    call update_score
    pop ax
    call score_printing

	xor ax,ax
    cmp word [xcord2], 0
    jge dec_xcord3
    mov word [xcord2], 79

dec_xcord3:
    dec word [xcord3]
    push word[xcord3]
    call update_score
    pop ax
    call score_printing

	xor ax,ax
    cmp word [xcord3], 0
    jge dec_birdy
    mov word [xcord3], 79

; Update bird position
dec_birdy:
    xor ax,ax   
    mov byte al,[boold]
    cmp byte al,'U'
    je upwards
    cmp byte[boold], 'T'
    je print_call;
   ; call delayBirdDrop
    normalDown:
    inc word  [birdy]
    jmp print_call

upwards:
    sub word [birdy],1
    jmp print_call

    Sound:
    ret
initPcb:
    ret 6

;------------------------------------------------------------------------------------------------------------------------
   ; Stop the bird at the green boundary

print_call:
    ; Redraw the screen
    call ground
    call sky
    call score_printing
    ; Draw barriers
    mov ax, [ycord]
    push ax
    mov ax, [xcord]
    push ax
    call barriers
    pop ax
    pop ax

    mov ax, [ycord1]
    push ax
    mov ax, [xcord1]
    push ax
    call barriers
    pop ax
    pop ax

    mov ax, [ycord2]
    push ax
    mov ax, [xcord2]
    push ax
    call barriers
    pop ax
    pop ax

    mov ax, [ycord3]
    push ax
    mov ax, [xcord3]
    push ax
    call barriers
    pop ax
    pop ax

    ; Draw bird
    push word [birdy]
    push word [birdx]
    call check_collision
    pop ax
    pop ax
    xor ax,ax
  
;bird_printing:
   ; mov byte al,[boold]
    ; cmp byte al,'T'
	; je skipping_printing;
    mov ax, [birdy]
    push ax
    mov ax, [birdx]
    push ax
    call print_bird
    pop ax
    pop ax
skipping_printing:
    popa
    ret

;------------------------------------------------------------------------------------------------------------
; Delay
;------------------------------------------------------------------------------------------------------------
delay:
    pusha
    mov cx, 0FFFFh
.delay_loop:
    loop .delay_loop
    popa
    ret

;-------------------------------------------------------------------------------------------------------------

                                ;retrace(copied from gpt)
								
;-------------------------------------------------------------------------------------------------------------

wait_for_retrace:
    mov dx, 0x03DA        ; VGA status register
.wait_not_retrace:
    in al, dx
    test al, 0x08         ; Check if in vertical retrace
    jz .wait_not_retrace  ; Loop until retrace starts
.wait_retrace:
    in al, dx
    test al, 0x08         ; Wait until retrace ends
    jnz .wait_retrace
    ret

    Game:
    ret
	
;---------------------------------------------------------------------------------------------------------------

                                  ;printing of bird

;---------------------------------------------------------------------------------------------------------------

print_bird:
    push bp
    mov bp,sp
    pusha

    mov al, 80
    mul byte [bp+6]
    add ax, [bp+4]
    shl ax, 1
    mov di, ax
    xor ax, ax

    mov ax, 0xb800
    mov es, ax
    mov ax ,0x6F20

    mov [es:di],ax
    popa
    pop bp
    ret
;--------------------------------------------------------------

check_collision:
    push bp
    mov bp, sp
    pusha

    ; Get bird's position in video memory
    mov al, 80
    mul byte [bp+6]
    add ax, [bp+4]
    shl ax, 1
    mov di, ax

    ; Set video memory segment
    mov ax, 0xb800
    mov es, ax

    ; Check for collision
    mov ax, [es:di]
    cmp ax, 0x3F20         ; Check if it's blue sky
    je no_collision

    ; Collision detected, terminate the game
	
	moveBird:
        mov byte[birdMoved], 1

        push word[birdy]
        pop cx

        push word[birdx]
        pop bx

        xor ax, ax
        mov ax, 160
        mul word cx
        shl bx, 1
        add ax, bx
        mov di, ax

        mov ax, 0xb800
        mov es, ax
        mov ax ,0x3F20

        mov [es:di],ax

        inc word[birdy]
        
        push word[birdy]
        pop cx

        push word[birdx]
        pop bx

        xor ax, ax
        mov ax, 160
        mul word cx
        shl bx, 1
        add ax, bx
        mov di, ax

        mov ax, 0xb800
        mov es, ax
        mov ax ,0x6F20

        mov [es:di],ax

        call delay
        call delay
        call delay
        call delay
        call delay
        call delay
        call delay
        call delay
        call delay
        call delay


        cmp word[birdy], 20
		jge endcollision
		jmp moveBird
	
endcollision:
    cmp byte[birdMoved], 1
    je .cont 	
    call moveBird
    .cont:
	call clrscr
    jmp exit_from_program

no_collision:
    popa
    pop bp
    ret

;------------------------------------------------------------------------------------------------------------------

endscreen:
    pusha
    mov ax,0xb800
    mov es,ax
    mov di,0

hus:
    mov cx,160
ms:
    mov word[es:di],0x3F20
    add di,2

    loop ms 
    call delay;
    call delay;
    call delay;
    cmp di,4000
    jl hus

    popa
    ret

;--------------------------------------------------------------------------------------------------------------------------
; Start
;--------------------------------------------------------------------------------------------------------------------------

start:
     call names             ; Display names and information

 .wait_for_enter:
     mov ah, 00h            ; BIOS: Wait for a keypress
     int 16h                ; Get keypress in AX
     cmp al, 0x0D           ; Check if the key is Enter (ASCII: 0x0D)
     jne .wait_for_enter

	 call instructions
	
	 .wait_for_enter3:
     mov ah, 00h            ; BIOS: Wait for a keypress
     int 16h                ; Get keypress in AX
     cmp al, 0x0D           ; Check if the key is Enter (ASCII: 0x0D)
     jne .wait_for_enter3
	 hide_cursor1:
     pusha
     mov ah, 01h            ; BIOS: Set cursor shape
     mov cx, 0x2607         ; CX = 0x2607 hides the cursor (start > end)
     int 10h
    call clrscr
    call ground
    call sky

    ; Register the printing thread
push bx ; use current code segment
mov ax, Game
push ax ; use mytask as offset
push word [lineno] ; thread parameter
call initPcb ; register the thread
inc word [lineno] ; update line number

; Register the sound thread
push cx ; use current code segment
mov ax, Sound
push ax ; use playsound as offset
push word 0 ; frequency parameter (e.g., 440 Hz for A4 note)
call initPcb ; register the thread

;-------------------------------------------------------------------------------------------------------------------------
    xor ax,ax
    mov es,ax


    mov ax,word[es:9*4];
    mov word[oldisr],ax

    mov ax,word[es:9*4+2]
    mov word[oldisr+2],ax

    mov ax,word[es:8*4];
    mov word[oldtimer], ax;

    mov ax,word[es:8*4+2];
    mov word[oldtimer+2], ax;


    cli
    mov word[es:8*4], timer  ; Set ISR address for IRQ0 (Timer)
    mov word[es:8*4+2], cs   ; Set ISR segment for IRQ0

    mov word[es:9*4],space
    mov word[es:9*4+2],cs
    sti

gameLoop:
    cmp byte[YPressed], 1
    je exit_from_program
    call delay
    call delay
    call delay
    call wait_for_retrace
    call animations             ; Call the animations subroutine
    jmp gameLoop                ; Infinite game loop


update_score:
    push bp
    mov bp,sp
    pusha

    mov ax, [bp+4]
    cmp word[birdx], ax
    jne endUpd

updateS:
    inc word[score]
    jmp endUpd

endUpd:
    popa
    pop bp
    ret 

;-------------------------------------------------------------------------------------------------------------------------
score_printing:
    pusha
    mov ax, [score]        
    mov bx, 10             
    lea di, [ScoreBuffer + 3] 
    mov byte [di], '$'     
    dec di                 

    .convert_loop:
        xor dx, dx         
        div bx             
        add dl, '0'        
        mov [di], dl       
        dec di             
        test ax, ax        
        jnz .convert_loop   

    lea si, [di+1]

    mov dl, 38
    mov dh, 0        
    mov bh, 0              
    mov ah, 02h            
    int 0x10               

    mov ah, 09h            
    mov dx, si             
    int 0x21               

    popa
    ret




exit_from_program:
    call clrscr
    call endscreen

    xor ax, ax
    mov es, ax

    mov ax,word[oldisr];
    mov word[es:9*4],ax

    mov ax,word[oldisr+2]
    mov word[es:9*4+2],ax

    mov ax,word[oldtimer];
    mov word[es:8*4], ax;

    mov ax,word[oldtimer+2];
    mov word[es:8*4+2], ax;

    mov ax,0x4C00
int 0x21

