.MODEL SMALL 
.STACK 100H

.DATA         
	CR EQU 0DH
	LF EQU 0AH
	ENDL DB 0DH, 0AH, '$' 
	NUMBER_STRING DB '00000$'
	
	N DW ?
	M DW ?
	I DW ?
	J DW ?
	COUNTER DW 0
	SUM DW 0

.CODE         

;   when a lot of registors are at work, 
;   it is recomended that we should not store values at registors
;   rather we store the values at memory and every time we need the value
;   we just fetch it from memory. We should leave one or two registors free,
;   (in this code, DX) of any dedicated operation for this purpose 

MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX
    
    CALL NUMBER_INPUT   ; input stored in N

    ; M = N, I = 2
    MOV DX, N 
    MOV M, DX   
    MOV I, 2
    
    ; loop range: [2, N]
    START_LOOP: 
        ; if (I > N) -> exit this loop
        MOV DX, M
        CMP I, DX   
        JG END_OF_LOOP
        
        MOV BX, I
        CALL FAULTY_NUMBER 
        
        INC I    ; I++
    JMP START_LOOP
    
    END_OF_LOOP:
    
    MOV DX, COUNTER
    MOV N, DX
    CALL NUMBER_PRINT  
    
    END_CODE:
    MOV AH, 4CH
    INT 21H

MAIN ENDP

FAULTY_NUMBER PROC
    ; BX == I, SUM = 0, J = 2 
    MOV SUM, 0
    MOV J, 2
    
    ; loop range: [2, I]
    START_FAULTY_LOOP:   
        ; if (J >= I) -> exit this loop
        CMP J, BX   
        JGE END_FAULTY_LOOP
        
        ; division: divident = AX, divisor = CX
        MOV DX, 0
        MOV AX, BX
        MOV CX, J
        DIV CX
        
        ; quotient stored in AX, remainder stored in DX
        CMP DX, 0
        JNE SKIP
        
        ; if (I%J == 0) -> SUM += J
        MOV DX, J
        ADD SUM, DX
        
        SKIP:
        
        INC J    ; J++
        JMP START_FAULTY_LOOP
        
    END_FAULTY_LOOP: 
    
    CMP SUM, BX
    JL END_FAULTY_PROC
    
    ; if (SUM > I) -> COUNTER++
    INC COUNTER
    
    END_FAULTY_PROC:
    RET
FAULTY_NUMBER ENDP

; NUMBER INPUT
NUMBER_INPUT PROC
    ; fast DX = 0
    XOR DX, DX
    
    INPUT_LOOP:
        ; char input 
        MOV AH, 1
        INT 21H
    
        ; if \n\r, stop taking input
        CMP AL, CR    
        JE END_INPUT_LOOP
        CMP AL, LF
        JE END_INPUT_LOOP

        AND AX, 000FH ; fast char to digit also clears AH
        MOV CX, AX ; save AX 
        
        ; DX = DX * 10 + AX
        MOV AX, 10
        MUL DX
        ADD AX, CX
        MOV DX, AX
        JMP INPUT_LOOP
    
    END_INPUT_LOOP:

	MOV N, DX
	CALL NEWLINE
    
    RET
NUMBER_INPUT ENDP                                               

; NUMBER PRINT
NUMBER_PRINT PROC
    MOV AX, N
    
    LEA DI, NUMBER_STRING
    ADD DI, 5
    
    PRINT_LOOP:
        DEC DI
        
        MOV DX, 0
        
        MOV CX, 10
        DIV CX
        
        ADD DL, '0'
        MOV [DI], DL
        
        CMP AX, 0
        JNE PRINT_LOOP
    
    MOV DX, DI
    MOV AH, 9
    INT 21H
    
    RET
NUMBER_PRINT ENDP

; NEWLINE PRINT
NEWLINE PROC
    LEA DX, ENDL
    MOV AH, 9
    INT 21H
    RET
NEWLINE ENDP 

END MAIN 