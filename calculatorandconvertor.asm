                      org 100h 
   OUTD DW ?
    IND DB ?
    
    SELECT DB ?
    
    INP1 DW ?   ; save decimal input
    
    COUNT DB ?
    D1 DB ?     ; save 1st decimal digit
    D2 DB ?     ; save 2nd decimal digit
    D3 DB ?     ; save 3rd decimal digit
    D4 DB ?     ; save 4th decimal digit
    D5 DB ?     ; save 5th decimal digit

jmp start       ; jump over data declaration

msg:     db     "1-ADD",0dh,0ah,"2-MULTIPLY",0dh,0ah,"3-SUBTRACT",0dh,0ah,"4-DIVIDE", 0Dh,0Ah,"5-CONVERT", '$'
msg2:    db      0dh,0ah,"Enter First No : $"
msg3:    db      0dh,0ah,"Enter Second No : $"
msg4:    db      0dh,0ah,"Choice Error $" 
msg5:    db      0dh,0ah,"Result : $" 
msg6:    db      0dh,0ah ,'thank you for using the calculator! press any key... ', 0Dh,0Ah, '$'

start:  mov ah,9
        mov dx, offset msg ;first we will display hte first message from which he can choose the operation using int 21h
        int 21h
        mov ah,0                       
        int 16h  ;then we will use int 16h to read a key press, to know the operation he choosed
        cmp al,31h ;the keypress will be stored in al so, we will comapre to 1 addition ..........
        je Addition
        cmp al,32h
        je Multiply
        cmp al,33h
        je Subtract
        cmp al,34h
        je Divide  
        cmp al,35h
        je Convert  
        mov ah,09h
        mov dx, offset msg4
        int 21h
        mov ah,0
        int 16h
        jmp start
        
Addition:   mov ah,09h  ;then let us handle the case of addition operation
            mov dx, offset msg2  ;first we will display this message enter first no also using int 21h
            int 21h
            mov cx,0 ;we will call InputNo to handle our input as we will take each number seprately
            call InputNo  ;first we will move to cx 0 because we will increment on it later in InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            add dx,bx
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call View 
            jmp exit 
            
InputNo:    mov ah,0
            int 16h ;then we will use int 16h to read a key press     
            mov dx,0  
            mov bx,1 
            cmp al,0dh ;the keypress will be stored in al so, we will comapre to  0d which represent the enter key, to know wheter he finished entering the number or not 
            je FormNo ;if it's the enter key then this mean we already have our number stored in the stack, so we will return it back using FormNo
            sub ax,30h ;we will subtract 30 from the the value of ax to convert the value of key press from ascii to decimal
            call ViewNo ;then call ViewNo to view the key we pressed on the screen
            mov ah,0 ;we will mov 0 to ah before we push ax to the stack bec we only need the value in al
            push ax  ;push the contents of ax to the stack
            inc cx   ;we will add 1 to cx as this represent the counter for the number of digit
            jmp InputNo ;then we will jump back to input number to either take another number or press enter          
   

;we took each number separatly so we need to form our number and store in one bit for example if our number 235
FormNo:     pop ax  
            push dx      
            mul bx
            pop dx
            add dx,ax
            mov ax,bx       
            mov bx,10
            push dx
            mul bx
            pop dx
            mov bx,ax
            dec cx
            cmp cx,0
            jne FormNo
            ret   
       
View:  mov ax,dx
       mov dx,0
       div cx 
       call ViewNo
       mov bx,dx 
       mov dx,0
       mov ax,cx 
       mov cx,10
       div cx
       mov dx,bx 
       mov cx,ax
       cmp ax,0
       jne View
       ret


ViewNo:    push ax ;we will push ax and dx to the stack because we will change there values while viewing then we will pop them back from
           push dx ;the stack we will do these so, we don't affect their contents
           mov dx,ax ;we will mov the value to dx as interrupt 21h expect that the output is stored in it
           add dl,30h ;add 30 to its value to convert it back to ascii
           mov ah,2
           int 21h
           pop dx  
           pop ax
           ret
          
                       
Multiply:   mov ah,09h
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            mov ax,dx
            mul bx 
            mov dx,ax
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call View 
            jmp exit 


Subtract:   mov ah,09h
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            sub bx,dx
            mov dx,bx
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call View 
            jmp exit 
    
            
Divide:     mov ah,09h
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            mov ax,bx
            mov cx,dx
            mov dx,0
            mov bx,0
            div cx
            mov bx,dx
            mov dx,ax
            push bx 
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call View
            pop bx
            cmp bx,0
            je exit 
            jmp exit             

Convert:    
    
    
    OP1 db '1. DECIMAL TO HEXADECIMAL $' 
    
    REM DW ?
    
    NEWL DB 10,13,'$'   ;newline
    
    DECIMALINP DB 'First Insert + or - than insert input value between (0-9) Maximum Limit is :  65,535 $'
    
    INDECIMAL DB 'DECIMAL VALUE: $'
    INBINARY DB 'BINARY VALUE: $'
    INHEXADECIMAL DB 'HEXADECIMAL VALUE: $'
    
    ERRORMSG DB 'Input Error! Wrong Key Inserted $'
    

    
    ENDMSG DB 9,'THANKS $'
    
.CODE

    MOV AX,@DATA    ; import data segment
    MOV DS,AX
    
    MOV AH,9    
    
    LEA DX,NEWL
    INT 21H
    
    
    LEA DX,OP1      ; print option1
    INT 21H
    LEA DX,NEWL
    INT 21H
  
    
    LEA DX,NEWL                           
    INT 21H
    LEA DX,NEWL
    INT 21H
    

    
    MOV AH,1
    INT 21H                   ; taking input to select a option
    MOV SELECT,AL
    
                              ; part1: decimal to others
    CMP SELECT,'1'
    JE DECIMAL
    
    
    ;;ERROR TEST
    CMP SELECT,'0'
    JL ERROR
    
    CMP SELECT,'2'
    JG ERROR
    ;;;;;;;;;;;;
    
    
    DECIMAL:    ; part1
        
        MOV AH,9
        LEA DX,NEWL
        INT 21H
        LEA DX,NEWL
        INT 21H        
        LEA DX,NEWL
        INT 21H
        
        LEA DX,DECIMALINP
        INT 21H
        
        LEA DX,NEWL
        INT 21H
        
        LEA DX,INDECIMAL
        INT 21H
        
        CALL INPUT_DECIMALFUN       ; calling decimal_input function
        MOV INP1,BX                 ; input saved in INP1
                                
        CMP SELECT,'1'              ; for hexadecimal output
        JE OUT_HEXA
        
        OUT_HEXA:
            
            MOV AH,9
            LEA DX,NEWL
            INT 21H
            LEA DX,NEWL
            INT 21H
            
            LEA DX,INHEXADECIMAL
            INT 21H
            
            MOV BX,INP1             ; fix input in a register for output
            CALL OUT_HEXAFUN        ; calling hex_output function
                
        
        
;Functions Area        
        
; input_dec and convert into binary(input in bx)        

        INPUT_DECIMALFUN PROC
        
                MOV AH,1
                INT 21H
                MOV IND,AL
                
                CMP IND,'-'
                JNE NEXTPOS
                
                JMP BEGIN1
                
                NEXTPOS:
                    CMP IND,'+'
                    JNE ERROR
              
                
            BEGIN1:     
                XOR BX,BX      
                
                MOV AH,1      
                INT 21H
                
                MOV CX,0  
        
                REPEAT3:
                    
                    ;;ERROR TEST
                    CMP AL,'0'
                    JL ERROR
                    
                    CMP AL,'9'
                    JG ERROR
                    ;;;;;;;;;;;
                    
                    CMP CX,0
                    JE ADD1
                    CMP CX,1
                    JE ADD2
                    CMP CX,2
                    JE ADD3
                    CMP CX,3
                    JE ADD4
                    CMP CX,4
                    JE ADD5
                    
                    ADD1:
                        MOV D1,AL
                        JMP WORK
                    ADD2:
                        MOV D2,AL
                        JMP WORK
                    ADD3:
                        MOV D3,AL
                        JMP WORK
                    ADD4:
                        MOV D4,AL
                        JMP WORK
                    ADD5:
                        MOV D5,AL
                        JMP WORK
                        
                    
                    WORK:
                    AND AX,000FH      
                    PUSH AX
                    
                    MOV AX,10     
                    MUL BX        
                    POP BX         
                    ADD BX,AX      
                    
                    INC CX
                    CMP CX,5
                    JE EXIT2
                    
                    MOV AH,1    
                    INT 21H
                    
                    CMP AL,0DH   
                    JE EXIT1
                            
                    CMP AL,0DH   
                    JNE REPEATING
                    
                        
                    REPEATING:
                        
                        JMP REPEAT3
                    
                    
                    EXIT2:
                        
                        MOV AL,D1
                        CMP AL,'6'
                        JG ERROR
                        CMP AL,'6'
                        JLE NEXT2
                        
                            NEXT2:
                                MOV AL,D2
                                CMP AL,'5'
                                JG ERROR
                                CMP AL,'5'
                                JLE NEXT3
                        
                                NEXT3:
                                    MOV AL,D3
                                    CMP AL,'5'
                                    JG ERROR
                                    CMP AL,'5'
                                    JLE NEXT4
                        
                                    NEXT4:
                                        MOV AL,D4
                                        CMP AL,'3'
                                        JG ERROR
                                        CMP AL,'3'
                                        JLE NEXT5
                        
                                        NEXT5:
                                            MOV AL,D5
                                            CMP AL,'5'
                                            JG ERROR                                                                
                        
                    EXIT1:
                        
                        CMP IND,'-'
                        JE NGD
                        
                        JMP EXITIND
                        NGD:
                         NEG BX
                    
                    EXITIND:       
            
            RET                
        INPUT_DECIMALFUN ENDP    

; output_hex to binary (work with bx)        
        
        out_hexafun proc
            
            mov al,0
            mov count,al
            
            xor dx,dx
            xor ax,ax
            
            
            mov cx,16
            
            while:
                shl dx,1
                inc count
                
                shl bx,1
                jc one
                
                
                mov ax,0
                jmp cont
                
                one:
                    mov ax,1
                
                cont:
                    or dx,ax
                    
                    cmp count,4
                    je pus
                    jmp lp
                    
                    pus:
                        cmp dx,9
                        jge letter1
                        
                        add dx,30h
                        jmp prnt
                              
                        letter1:
                        add dx,37h
                        
                        prnt:
                        mov ah,2 
                        int 21h
                        
                        xor dx,dx
                        mov count,0
                         
                    lp:    
                        loop while    
            
            
                
            
            
            ret
         out_hexafun endp   

;;;output_binary from binary(work with bx)
        
        OUT_BINARYFUN PROC
            
            MOV AH,2
            MOV CX,16      
     
            TOPBIN:
                SHL BX,1       
                JNC ZEROBIN   
                
                MOV DL,49      
                JMP PRINTBIN   
                
                ZEROBIN:          
                    MOV DL,48     
                    
                PRINTBIN:          
                    INT 21H     
                    LOOP TOPBIN            
        
        
            RET
        OUT_BINARYFUN ENDP

;;ERROR message
    
    ERROR:
        
        MOV AH,9
        LEA DX,NEWL
        INT 21H
        LEA DX,NEWL
        INT 21H
        
        LEA DX,ERRORMSG
        INT 21H
        

;;end programm
    
    EXIT:
        
        MOV AH,9
        LEA DX,NEWL
        INT 21H
        LEA DX,NEWL
        INT 21H 
        LEA DX,NEWL
        INT 21H
        
        LEA DX,ENDMSG
        INT 21H
        
        MOV AH,4CH      ; ignore emulator haulted 
        INT 21H