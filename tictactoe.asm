.model small
.stack 100h
.data
c db 1,2,3,4,5,6,7,8,9

repeat db 'type y to play again or any key to quit','$'
heading db 'Tic Tac Toe',10,13,'                                     IIT-JU','$'
l1 db '  |  |  $'
l2 db '_ _ _ _ _ _ _ _ _ _$'
l3 db '| $'    
done db '0'
cur db 79
congo db 'congratulations! Player $'
msg db 'player $'
player db '0'
enter db ' ::enter a position:$'
won db ' won$'
count db '0'
tie db 'it is a tie.no one won$' 
invalid db 10,13,'enter valid input$'
.code
main proc 
    mov ax,@data
    mov ds,ax
    
       
    
    call board
    main_loop: 
        
        mov ah,2
        mov dl,10
        int 21h
        mov dl,13
        int 21h
        
        ;set cursor
        mov ah,2
        mov dh,20
        mov dl,30
        int 10h
        
        lea dx,msg
        mov ah,9
        int 21h
        
        mov ah,2
        mov dl,player
        int 21h
        
        mov ah,9
        lea dx,enter
        int 21h
        
        inp:
        mov ah,1
        int 21h 
        sub al,49               
        mov bh,0
        mov bl,al 
        
        call valid
        
        call update
        call check 
        call board  
        cmp done,'1'
        je win
        inc count
        cmp count,'9'
        je draw
        call change_player  
    valid:
        mov bh,0
        cmp c[bx],9
        jg ne
        ret
        ne:  
            
            mov ah,9
            lea dx,invalid
            int 21h
            jmp inp
    reset:
        lea si,c[0]
        mov [si],1
        
        lea si,c[1]
        mov [si],2 
        
        lea si,c[2]
        mov [si],3
        
        lea si,c[3]
        mov [si],4
        
        lea si,c[4]
        mov [si],5
        
        lea si,c[5]
        mov [si],6
        
        lea si,c[6]
        mov [si],7
        
        lea si,c[7]
        mov [si],8
        
        lea si,c[8]
        mov [si],9 
        
        mov done,'0'
        mov count,'0'
        ret
    win:
        ;set cursor
        mov ah,2
        mov dh,20
        mov dl,30
        int 10h
        
        mov ah,9
        lea dx,congo
        int 21h
        
        lea si,player
        mov ah,2
        mov dl,[si]
        int 21h
                                      
        mov ah,9
        lea dx,won
        int 21h
        
        ;set cursor
        mov ah,2
        mov dh,22
        mov dl,30
        int 10h
         
        mov ah,9
        lea dx,repeat
        int 21h
        
        mov ah,1
        int 21h
        cmp al,'y'
        je label_repeat
        jmp exit       
        label_repeat: 
            ;clear screen
            mov ax,0600h
            mov bh,07h
            mov cx,0000h
            mov dx,184fh 
            int 10h 
            call reset
            call board
            jmp main_loop 
            
    draw:
    
        ;set cursor
        mov ah,2
        mov dh,20
        mov dl,30
        int 10h 
        
        lea dx,tie
        mov ah,9
        int 21h 
        
        ;set cursor
        mov ah,2
        mov dh,22
        mov dl,30
        int 10h        
        
        mov ah,9 
        lea dx,repeat
        int 21h
        
        mov ah,1
        int 21h
        cmp al,'y'
        je label_repeat1
        jmp exit       
        label_repeat1: 
            ;clear screen
            mov ax,0600h
            mov bh,07h
            mov cx,0000h
            mov dx,184fh 
            int 10h 
            call reset
            call board
            jmp main_loop 
            
        
    check:
        row_1:
            mov al,c[0]
            mov bl,c[1]
            cmp al,bl
            je label
            jmp row_2
            label:
                mov al,c[2]
                cmp al,c[1]
                je result
                jmp row_2
                result:
                    xor done,1
                    ret
        row_2:
            mov al,c[3]
            cmp al,c[4]
            je label1
            jmp row_3
            label1:
                cmp al,c[5]
                je result
                jmp row_3
        row_3:
            mov al,c[6]
            cmp al,c[7]
            je label2
            jmp col_1
            label2:
                cmp al,c[8]
                je result
                jmp col_1
        col_1:
            mov al,c[0]
            cmp al,c[3]
            je label3
            jmp col_2
            label3:
                cmp al,c[6]
                je result
                jmp col_2
        col_2:
            mov al,c[1]
            cmp al,c[4]
            je label4
            jmp col_3
            label4:
                cmp al,c[7]
                je result
                jmp col_3
        col_3:
            mov al,c[2]
            cmp al,c[5]
            je label5
            jmp diag_1
            label5:
                cmp al,c[8]
                je result
                jmp diag_1
        diag_1:
            mov al,c[0]
            cmp al,c[4]
            je label6
            jmp diag_2
            label6:
                cmp al,c[8]
                je result
                jmp diag_2
        diag_2:
            mov al,c[2]
            cmp al,c[4]
            je label7
            ret
            label7:
                cmp al,c[6]
                je result
                ret              
    change_player:
        lea si,player
        xor [si],1
        jmp main_loop
    update:
        lea si,player
        cmp [si],'1'
        je write_x
        cmp [si],'0'
        je write_o
        
        write_x:
            mov cl,'X'
            jmp change
        write_o:
            mov cl,'O'
            jmp change
        change:
            mov bh,0
            lea si,c[bx] 
            sub cl,48 
            mov [si],cl
        ret 
    
    board:
        ;clear screen
        mov ax,0600h
        mov bh,07h
        mov cx,0000h
        mov dx,184fh 
        int 10h 
        
        ;set cursor
        mov ah,2
        mov bh,0
        mov dh,6
        mov dl,35
        int 10h
       
    
        mov ah,9
        lea dx,heading
        int 21h
        
        ;set cursor
        mov ah,2 
        mov bh,0
        mov dh,10
        mov dl,35
        int 10h
        
        lea dx,l1
        mov ah,9
        int 21h
        
        ;set cursor
        mov ah,2
        mov dh,11
        mov dl,35
        int 10h
        
        mov ah,2
        mov dl,32
        int 21h  
        
        ;row 1
        ;cell 1
        mov si,offset c[0]
        mov dx,[si] 
        add dx,48
        mov ah,2
        int 21h 
        
        lea dx,l3
        mov ah,9
        int 21h
         
        ;cell 2
        mov si,offset c[1]
        mov dx,[si] 
        add dx,48
        mov ah,2
        int 21h
        
        lea dx,l3
        mov ah,9
        int 21h 
        
        ;cell 3
        mov si,offset c[2]
        mov dx,[si] 
        add dx,48
        mov ah,2
        int 21h
        
        ;set cursor
        mov ah,2
        mov dh,12
        mov dl,30
        int 10h
        
        lea dx,l2
        mov ah,9
        int 21h 
        
        ;set cursor
        mov ah,2
        mov dh,13
        mov dl,35
        int 10h 
        
        mov ah,9
        lea dx,l1
        int 21h
        
        ;set cursor
        mov ah,2
        mov dh,14
        mov dl,35
        int 10h
        
        ;row 2
        mov ah,2
        mov dl,32
        int 21h
        ;cell 4
        mov si,offset c[3]
        mov dx,[si] 
        add dx,48
        mov ah,2
        int 21h
        
        lea dx,l3
        mov ah,9
        int 21h
         
        ;cell 5
        mov si,offset c[4]
        mov dx,[si] 
        add dx,48
        mov ah,2
        int 21h 
        
        lea dx,l3
        mov ah,9
        int 21h 
        
        ;cell 6
        mov si,offset c[5]
        mov dx,[si] 
        add dx,48
        mov ah,2
        int 21h
        
        ;set cursor
        mov ah,2
        mov dh,15
        mov dl,30
        int 10h
        
        lea dx,l2
        mov ah,9
        int 21h 
        
        ;set cursor
        mov ah,2
        mov dh,16
        mov dl,35
        int 10h
        

        
        lea dx,l1
        mov ah,9
        int 21h
        
        ;set cursor
        mov ah,2
        mov dh,17
        mov dl,35
        int 10h
        
        ;row 3
        mov ah,2
        mov dl,32
        int 21h
        ;cell 7
        mov si,offset c[6]
        mov dx,[si] 
        add dx,48
        mov ah,2
        int 21h 
        
        lea dx,l3
        mov ah,9
        int 21h
         
        ;cell 8
        mov si,offset c[7]
        mov dx,[si] 
        add dx,48
        mov ah,2
        int 21h 
        
        lea dx,l3
        mov ah,9
        int 21h 
        
        ;cell 9
        lea si,c[8]
        mov dx,[si] 
        add dx,48
        mov ah,2
        int 21h
        
        ;set cursor
        mov ah,2
        mov dh,18
        mov dl,35
        int 10h  
        
        lea dx,l1
        mov ah,9
        int 21h
        
        ;set cursor
        mov ah,2
        mov dh,19
        mov dl,35
        int 10h 
        
        ret
        
          
    exit:
    mov ah,4ch
    int 21h
    main endp

end main
