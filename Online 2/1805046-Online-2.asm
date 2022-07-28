.MODEL SMALL 
.STACK 100H 
.DATA

    N DW ?
    CR EQU 0DH
    LF EQU 0AH
	endl DB 0DH, 0AH, '$'
	INVALID DB 'INVALID$'
	F DB 'F$'
	B DB 'B$'
	BPlus DB 'B+$'
	AMinus DB 'A-$'
	A DB 'A$'
	APlus DB 'A+$'

.CODE 
MAIN PROC
    ;Data Segment Initialization  
    MOV AX, @DATA
    MOV DS, AX
    
    ; fast BX = 0
    XOR BX, BX
    
    INPUT_LOOP:
    ; char input 
    MOV AH, 1
    INT 21H
    
    ; if \n\r, stop taking input
    CMP AL, CR    
    JE END_INPUT_LOOP
    CMP AL, LF
    JE END_INPUT_LOOP
    
    ; fast char to digit
    ; also clears AH
    AND AX, 000FH
    
    ; save AX 
    MOV CX, AX
    
    ; BX = BX * 10 + AX
    MOV AX, 10
    MUL BX
    ADD AX, CX
    MOV BX, AX
    JMP INPUT_LOOP
    
    END_INPUT_LOOP:
    MOV N, BX
    
    ; printing CR and LF
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H
    
    
    ;------------------------------------
    ; start from here
    ; input is in N
    
    ;check if less than 0
    MOV AX, N
    CMP AX, 0
    JL LESS_THAN_ZERO
    
    ;N>=0
    CMP AX, 60
    JL LESS_THAN_SIXTY
    
    ;N>=60
    CMP AX, 65
    JL LESS_THAN_SIXTY_FIVE
    
    ;N>=65
    CMP AX, 70
    JL LESS_THAN_SEVENTY
    
    ;N>=70
    CMP AX, 75
    JL LESS_THAN_SEVENTY_FIVE
    
    ;N>=75
    CMP AX, 80
    JL LESS_THAN_EIGHTY
    
    ;N>=80
    CMP AX, 100
    JLE LESS_THAN_OR_EQUAL_TO_ONE_HUNDRED
    
    ;N>100
    JMP GREATER_THAN_HUNDRED
    
    
    LESS_THAN_ZERO:
        LEA DX, INVALID
        MOV AH, 9
        INT 21H 
        JMP END_CODE
        
    GREATER_THAN_HUNDRED:
        LEA DX, INVALID
        MOV AH, 9
        INT 21H 
        JMP END_CODE
    
    LESS_THAN_SIXTY:
        LEA DX, F
        MOV AH, 9
        INT 21H 
        JMP END_CODE
        
    LESS_THAN_SIXTY_FIVE:
        LEA DX, B
        MOV AH, 9
        INT 21H 
        JMP END_CODE
        
    LESS_THAN_SEVENTY:
        LEA DX, BPlus
        MOV AH, 9
        INT 21H 
        JMP END_CODE
        
    LESS_THAN_SEVENTY_FIVE:
        LEA DX, AMinus
        MOV AH, 9
        INT 21H 
        JMP END_CODE
         
    LESS_THAN_EIGHTY:
        LEA DX, A
        MOV AH, 9
        INT 21H 
        JMP END_CODE
        
    LESS_THAN_OR_EQUAL_TO_ONE_HUNDRED:
        LEA DX, APlus
        MOV AH, 9
        INT 21H
        
    
    END_CODE:  

	; interrupt to exit
    MOV AH, 4CH
    INT 21H
    
  
MAIN ENDP 
END MAIN 