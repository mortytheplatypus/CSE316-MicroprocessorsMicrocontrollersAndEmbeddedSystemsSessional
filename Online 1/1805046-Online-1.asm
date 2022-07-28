.MODEL SMALL
.STACK 100H

.DATA
    endl DB 13, 10, '$' 

    line1267 DB '*******$'
    line35 DB '***$'
    line4 DB '**$' 

    promptFirst DB 'Enter the initial of your first name: $'
    promptMiddle DB 'Enter the initial of your middle name: $'
    promptLast DB 'Enter the initial of your last name: $'

    A DB ?
    B DB ?
    C DB ?

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ;input starts
    ;first
    LEA DX, promptFirst
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    MOV A, AL
    
    LEA DX, endl
    MOV AH, 9
    INT 21H
    
    ;middle
    LEA DX, promptMiddle
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    MOV B, AL
    
    LEA DX, endl
    MOV AH, 9
    INT 21H
    
    ;last
    LEA DX, promptLast
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    MOV C, AL
    
    LEA DX, endl
    MOV AH, 9
    INT 21H
    
    ;input ends
    
    ;1
    LEA DX, line1267
    MOV AH, 9
    INT 21H
    
    LEA DX, endl
    MOV AH, 9
    INT 21H 
    
    ;2
    LEA DX, line1267
    MOV AH, 9
    INT 21H
    
    LEA DX, endl
    MOV AH, 9
    INT 21H
    
    ;3
    LEA DX, line35
    MOV AH, 9
    INT 21H
    
    MOV DL, A
    MOV AH, 2
    INT 21H 
    
    LEA DX, line35
    MOV AH, 9
    INT 21H
    
    LEA DX, endl
    MOV AH, 9
    INT 21H
    
    ;4
    LEA DX, line4
    MOV AH, 9
    INT 21H
    
    MOV DL, A
    MOV AH, 2
    INT 21H
    
    MOV DL, B
    MOV AH, 2
    INT 21H
    
    MOV DL, C
    MOV AH, 2
    INT 21H
    
    LEA DX, line4
    MOV AH, 9
    INT 21H 
    
    LEA DX, endl
    MOV AH, 9
    INT 21H
    
    ;5
    LEA DX, line35
    MOV AH, 9
    INT 21H
    
    MOV DL, C
    MOV AH, 2
    INT 21H 
    
    LEA DX, line35
    MOV AH, 9
    INT 21H
    
    LEA DX, endl
    MOV AH, 9
    INT 21H
    
    ;6
    LEA DX, line1267
    MOV AH, 9
    INT 21H
    
    LEA DX, endl
    MOV AH, 9
    INT 21H
    
    ;7
    LEA DX, line1267
    MOV AH, 9
    INT 21H
    
    LEA DX, endl
    MOV AH, 9
    INT 21H
    
    
    
    MOV AH, 4CH
    INT 21H
    MAIN ENDP
END MAIN