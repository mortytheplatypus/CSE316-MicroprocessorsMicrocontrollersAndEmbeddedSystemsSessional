.MODEL SMALL 
.STACK 100H 

.DATA         

	CR EQU 0DH
	LF EQU 0AH
	endl DB 0DH, 0AH, '$'

	STRING DB 'All are equal!$'
	X DB ? 
	Y DB ?
	Z DB ?


.CODE         

;Greatest of 3 numbers
MAIN PROC
    ; Data Segment Initialization
    MOV AX, @data
    MOV	DS, AX 
	
	;input starts
	MOV AH, 1
	INT 21H
	MOV X, AL 
	
	LEA DX, endl
	MOV AH, 9
	INT 21H
	
	MOV AH, 1
	INT 21H
	MOV Y, AL 
	
	LEA DX, endl
	MOV AH, 9
	INT 21H
	
	MOV AH, 1
	INT 21H
	MOV Z, AL 
	
	LEA DX, endl
	MOV AH, 9
	INT 21H 
	;input ends  
	
	START:
	MOV AL, X
	CMP AL, Y
	JLE X_LESS_THAN_Y  
	
	JMP SKIP
	
	X_LESS_THAN_Y:
	    MOV BL, Y
	    MOV X, BL
	    MOV Y, AL 
	
	SKIP:
	
	MOV AL, Y
	CMP AL, Z
	JGE ALREADY_SORTED
	
	;Y_LESS_THAN_Z
	MOV BL, Z
	MOV Y, BL
	MOV Z, AL
	
	JMP START 
	
	ALREADY_SORTED:
	    MOV DL, X
	    MOV AH, 2
	    INT 21H
	    
	    LEA DX, endl
	    MOV AH, 2
	    INT 21H
	    
	    MOV DL, Y
	    MOV AH, 2
	    INT 21H
	    
	    LEA DX, endl
	    MOV AH, 2
	    INT 21H
	    
	    MOV DL, Z
	    MOV AH, 2
	    INT 21H
	    
	    LEA DX, endl
	    MOV AH, 2
	    INT 21H
	
    ; DOS EXIT
    MOV AH, 4CH     ; terminate process
    INT 21H         ; DOS Service Invoke
    
MAIN ENDP
END MAIN
