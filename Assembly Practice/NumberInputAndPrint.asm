.MODEL SMALL 
.STACK 100H 

.DATA         

	CR EQU 0DH
	LF EQU 0AH
	ENDL DB 0DH, 0AH, '$'
	NUMBER_STRING DB '00000$'
	
	N DW ?
	
	IS_NEGATIVE DB 0 

.CODE         

MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX
    
    CALL INPUT
    CALL PRINT

	; interrupt to exit
    MOV AH, 4CH
    INT 21H
 
MAIN ENDP 

;;;;
PRINT PROC
    
    CMP N, 0
    JG RESUME
    
    NEG N
    
    MOV DX, '-'
    MOV AH, 2
    INT 21H
    
    RESUME:
    MOV AX, N
    
    LEA DI, NUMBER_STRING
    ADD DI, 5
    
    PRINT_LOOP:
        DEC DI
        
        MOV DX, 0
        ; DX:AX = 0000:AX
        
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
PRINT ENDP

;;;NUMBER INPUT
INPUT PROC
    ; fast BX = 0
    XOR BX, BX
    MOV IS_NEGATIVE, 0
    
    INPUT_LOOP:
        ; char input 
        MOV AH, 1
        INT 21H
        
        CMP AL, '-'
        JE NEGATIVE
    
        ; if \n\r, stop taking input
        CMP AL, CR    
        JE END_INPUT_LOOP
        CMP AL, LF
        JE END_INPUT_LOOP

        AND AX, 000FH ; fast char to digit also clears AH
        MOV CX, AX ; save AX 
        
        ; BX = BX * 10 + AX
        MOV AX, 10
        MUL BX
        ADD AX, CX
        MOV BX, AX
        JMP INPUT_LOOP
        
        NEGATIVE:
            MOV IS_NEGATIVE, 1
            JMP INPUT_LOOP
    
    END_INPUT_LOOP:
    
    CMP IS_NEGATIVE, 1
    JNE END_INPUT_PROC 
    
    NEG BX
    
    END_INPUT_PROC:
		MOV N, BX
		CALL NEWLINE
    
    RET
INPUT ENDP

;;;;
NEWLINE PROC
    LEA DX, ENDL
    MOV AH, 9
    INT 21H
    RET
NEWLINE ENDP
 
END MAIN 