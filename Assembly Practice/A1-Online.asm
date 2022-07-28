; Problem statement: Take input a letter from A to H. 
; Output for letters A-H would be 17-10 consecutively, depending on the input

.MODEL SMALL
.STACK 100H

.DATA
    ENDL DB 0DH, 0AH, '$' 
    
    InputText DB 'Input a capital letter between A and H: $'
    OutputText DB 'Output: $'
    X DB ?
    Y DB ?

.CODE  

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    LEA DX, InputText
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    MOV X, AL
    
    LEA DX, endl
    MOV AH, 9
    INT 21H
    
    SUB X, 'A'
    ADD X, '0'
    
    LEA DX, OutputText
    MOV AH, 9
    INT 21H
    
    MOV DL, '1'
    MOV AH, 2
    INT 21H
    
    MOV DL, '7'
    SUB DL, X
    ADD DL, '0'
    MOV AH, 2
    INT 21H
    
    MOV AH, 4CH
    INT 21H
    MAIN ENDP
END MAIN