.MODEL SMALL 
.STACK 100H 

.DATA
	CR EQU 0DH
	LF EQU 0AH
	ENDL DB 0DH, 0AH, '$'
	
	ARRAY_SIZE_PROMPT DB 'ENTER THE SIZE OF THE ARRAY: $'
	NUMBER_INPUT_PROMPT DB 'NOW ENTER ARRAY ELEMENT(S) ONE BY ONE', 0DH, 0AH, '$'
	BINARY_SEARCH_PROMPT DB 'ENTER THE NUMBER YOU WANT TO SEARCH IN THE ARRAY: $'
	AFTER_SORTING_PROMPT DB 'ARRAY AFTER SORTING:  $'
	SPACE DB '  $' 
	FOUND_PROMPT DB ' FOUND AT INDEX $' 
	NOT_FOUND_PROMPT DB 'NOT FOUND!$'
	NUMBER_STRING DB '00000$'
	PROGRAM_TERMINATED_PROMPT DB 'THE PROGRAM HAS TERMINATED!$'
	ANOTHER_SEARCH_PROMPT DB 'DO YOU WANT TO SEARCH AGAIN IN THE SAME ARRAY? Y/N$'   
	NEW_ARRAY_PROMPT DB 'PROGRAM RESET', 0DH, 0AH, 0DH, 0AH, '$'
	
	N DW ?
	SIZE DW ?
	ITERATOR DW ?
	KEY DW ?
	I DW ?
	J DW ?
	JPLUS1 DW ?
	FOUND_POSITION DW ?
	IS_NEGATIVE DW 0 
	
	ARRAY DW 50 DUP(0) 
.CODE         

MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX
    LEA SI, ARRAY
    
    LOOP_START:
        LEA DX, ARRAY_SIZE_PROMPT
        MOV AH, 9
        INT 21H
        
        CALL NUMBER_INPUT
               
        CMP N, 0  ; (N == 0)
        JE END_OF_CODE
        
        CMP IS_NEGATIVE, 1
        JE END_OF_CODE
               
        MOV DX, N  ; SIZE = N
        MOV SIZE, DX 
        
        LEA DX, NUMBER_INPUT_PROMPT
        MOV AH, 9
        INT 21H
        
        CALL INPUT_ARRAY        
        
        CALL INSERTION_SORT 
        
        LEA DX, AFTER_SORTING_PROMPT
        MOV AH, 9
        INT 21H
        
        MOV I, 0 
        MOV DX, SIZE
        MOV ITERATOR, DX
        
        CALL PRINT_ARRAY    
        
        CALL SEARCH
        
        CALL NEWLINE
        CALL NEWLINE
        CALL NEWLINE
        LEA DX, NEW_ARRAY_PROMPT
        MOV AH, 9
        INT 21H 
        
    JMP LOOP_START
      
    END_OF_CODE:
    
        LEA DX, PROGRAM_TERMINATED_PROMPT
        MOV AH, 9
        INT 21H
    
    MOV AH, 4CH
    INT 21H 
MAIN ENDP 

;********************************************************
INPUT_ARRAY PROC
    MOV CX, SIZE   
    MOV ITERATOR, CX
    MOV I, 0
        
    ARRAY_INPUT_LOOP_START:
        MOV BX, I
        MOV [SI+BX], 0
               
        CALL NUMBER_INPUT
             
        MOV DX, N 
        ADD [SI+BX], DX  
             
        DEC ITERATOR
        CMP ITERATOR, 0
        JLE ARRAY_INPUT_LOOP_END
             
        ADD I, 2
        JMP ARRAY_INPUT_LOOP_START 
        
    ARRAY_INPUT_LOOP_END:
    RET
INPUT_ARRAY ENDP

;********************************************************
PRINT_ARRAY PROC
    MOV CX, SIZE   
    MOV ITERATOR, CX
    MOV I, 0
        
    ARRAY_OUTPUT_LOOP_START: 
            MOV BX, I
            
            MOV AX, [SI+BX]
            MOV N, AX
            
            CALL NUMBER_PRINT
            
            LEA DX, SPACE
            MOV AH, 9
            INT 21H
             
            DEC ITERATOR
            CMP ITERATOR, 0
            JE ARRAY_OUTPUT_LOOP_END
            
            ADD I, 2
            JMP ARRAY_OUTPUT_LOOP_START 
        
    ARRAY_OUTPUT_LOOP_END:
    CALL NEWLINE
    RET
PRINT_ARRAY ENDP

;********************************************************
SEARCH PROC
    SEARCH_LOOP:
        CALL NEWLINE
            
        LEA DX, BINARY_SEARCH_PROMPT
        MOV AH, 9
        INT 21H
            
        MOV IS_NEGATIVE, 0
        CALL NUMBER_INPUT ;NUMBER IS IN 'N'
            
        MOV DX, N
        CALL BINARY_SEARCH 
        CALL NEWLINE 
            
        LEA DX, ANOTHER_SEARCH_PROMPT
        MOV AH, 9
        INT 21H
        CALL NEWLINE
            
        MOV AH, 1
        INT 21H
            
        CMP AL, 'Y'
        JE SEARCH_LOOP
            
        CMP AL, 'y'
        JE SEARCH_LOOP
    RET
SEARCH ENDP

;******************************************************** 
;********************************************************
;********************************************************

;;;NUMBER PRINT
NUMBER_PRINT PROC
    
    CMP N, 0
    JGE RESUME_NUMBER_PRINT
    
    NEG N
    
    MOV DX, '-'
    MOV AH, 2
    INT 21H
    
    RESUME_NUMBER_PRINT:
    MOV AX, N
    
    LEA DI, NUMBER_STRING
    ADD DI, 5
    
    PRINT_LOOP:
        DEC DI
        
        MOV DX, 0 ; DX:AX = 0000:AX
        
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

;;;NUMBER INPUT
NUMBER_INPUT PROC
    XOR DX, DX ; fast DX = 0
    MOV IS_NEGATIVE, 0
    
    INPUT_LOOP:
        MOV AH, 1  ; char input
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
        
        ; DX = DX * 10 + AX
        MOV AX, 10
        MUL DX
        ADD AX, CX
        MOV DX, AX
        JMP INPUT_LOOP
        
        NEGATIVE:
            MOV IS_NEGATIVE, 1
            JMP INPUT_LOOP
    
    END_INPUT_LOOP:
    
    CMP IS_NEGATIVE, 1
    JNE END_INPUT_PROC 
    
    NEG DX
    
    END_INPUT_PROC:
		MOV N, DX
		CALL NEWLINE
    
    RET
NUMBER_INPUT ENDP

;********************************************************
NEWLINE PROC
    LEA DX, ENDL
    MOV AH, 9
    INT 21H
    RET
NEWLINE ENDP

;******************************************************** 
;********************************************************
;********************************************************
;;;INSERTION SORT
INSERTION_SORT PROC
    MOV CX, SIZE   
    MOV ITERATOR, CX
	MOV I, 2
    
    OUTER_LOOP:
		DEC ITERATOR
        CMP ITERATOR, 0
		JE END_OUTER_LOOP
		
		;COPY CONTENT OF ARRAY[SI+I] TO KEY 
		MOV BX, I
		MOV DX, [SI+BX]
		MOV KEY, DX   ; KEY = ARRAY[I]
		
		;SET VALUE OF J = I-2 [I-2, BECAUSE WORD VARIABLE]
		MOV DX, I
		MOV JPLUS1, DX 
		SUB DX, 2
		MOV J, DX
		
        INNER_LOOP: 
            CMP J, 0   ; (J >= 0)
			JL END_INNER_LOOP
			
			MOV BX, J
			MOV DX, [SI+BX]  ; DX = ARRAY[J]

			CMP DX, KEY  ; (ARRAY[J] > KEY)
			JLE END_INNER_LOOP
			
			MOV BX, JPLUS1
			MOV [SI+BX], DX  ; ARRAY[J+1] = ARRAY[J]
			SUB J, 2
			SUB JPLUS1, 2
			JMP INNER_LOOP
        END_INNER_LOOP:
		
		MOV DX, KEY
		MOV BX, JPLUS1
		MOV [SI+BX], DX  ; ARRAY[J+1] = KEY

		ADD I, 2
		JMP OUTER_LOOP
		
    END_OUTER_LOOP:
        CALL NEWLINE
        RET
INSERTION_SORT ENDP

;********************************************************
;;;BINARY SEARCH
BINARY_SEARCH PROC
    MOV I, 0  ; I = 0
	
	MOV DX, SIZE
	DEC DX
	ADD DX, DX
	MOV J, DX  ; J = 2*(SIZE-1)
	
	MOV CX, N
	
	START_BINARY_SEARCH:
		MOV BX, I 
		ADD BX, J  ; BX = I+J
		
		MOV AX, BX ; AX = BX = I+J
		SHR AX, 1  ; AX = (I+J)/2
			
		;NOW CHECK IF AX IS ODD, IF ODD, DEC 1 
		TEST AX, 1
		JZ EVEN
		DEC AX 
		
		EVEN:
		MOV BX, AX ; BX = (I+J)/2
		CMP [SI+BX], CX  ; ARRAY[(I+J)/2] == N
		JZ ELEMENT_FOUND
		
		CMP [SI+BX], CX
		JG ELEMENT_IS_SMALLER
		
		MOV I, BX  ; I = (I+J)/2
		JMP END_OF_LOOP 
		
		ELEMENT_IS_SMALLER: 
		MOV J, BX  ; J = (I+J)/2
		
		END_OF_LOOP:
		
		MOV BX, J
		SUB BX, I
		CMP BX, 2  ; (J-2) > 2
		JLE ELEMENT_NOT_FOUND
		
		JMP START_BINARY_SEARCH
	
	ELEMENT_FOUND: 
	    MOV N, CX
		CALL NUMBER_PRINT
		
		LEA DX, FOUND_PROMPT
		MOV AH, 9
		INT 21H 
		
		SHR BX, 1
		INC BX
		MOV N, BX
		CALL NUMBER_PRINT
		
	JMP END_BINARY_SEARCH
	
	ELEMENT_NOT_FOUND:
	    MOV BX, I
	    CMP [SI+BX], CX
	    JE ELEMENT_FOUND
	    
	    MOV BX, J
	    CMP [SI+BX], CX
	    JE ELEMENT_FOUND
	    
	    LEA DX, NOT_FOUND_PROMPT
		MOV AH, 9
		INT 21H
	
	END_BINARY_SEARCH:
	
	CALL NEWLINE
    RET
BINARY_SEARCH ENDP 

END MAIN 