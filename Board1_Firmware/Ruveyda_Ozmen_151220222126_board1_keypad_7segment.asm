LIST P=16F877A,R=DEC
#include <P16F877A.INC>
__CONFIG _HS_OSC & _WDT_OFF & _PWRTE_ON & _LVP_OFF 

CBLOCK 0x20
    KEY_CODE  ;output register  for key codes    
    DELAY_COUNT_1 
    DELAY_COUNT_2 
    DELAY_COUNT_3
    SCAN_CODE;24
    DISP1;25
    DISP2;26
    DISP3;27
    DISP4;28
    ACTIVE_CURSOR;29
    CURSOR_COMMAND;2A
    KEY_CODE_REG
    
ENDC

    ORG 0x0000
    
   
    GOTO MAIN   
    ; this area should be used to   describe the tables
    
    SEVEN_SEG_TABLE:
    ADDWF PCL, F
    RETLW B'00111111'  ; 0
    RETLW B'00000110' ; 1
    RETLW B'01011011' ; 2
    RETLW B'01001111'  ; 3
    RETLW B'01100110'  ; 4
    RETLW B'01101101' ; 5
    RETLW B'01111101' ; 6
    RETLW B'00000111'  ; 7
    RETLW B'01111111'  ; 8
    RETLW B'01101111'  ; 9
    RETLW B'10000000'  ; '*'10
    RETLW B'00001000';  ; '#' 11
    RETLW B'00001000'; ; 'A' 12
    RETLW B'00001000'; ; 'B'
    RETLW B'00001000'; ; 'C'
    RETLW B'00001000'; ; 'D'
    RETLW B'00001000'; ; 'D'
    RETLW B'00001000'; ; 'D' 
 
   
    
 DIGIT_TABLE:
    ADDWF PCL, F
    RETLW B'00000001'  ; 0
    RETLW B'00000010' ; 1
    RETLW B'00000100' ; 2
    RETLW B'00001000'  ; 3
    
    
    
    
MAIN:   ;_____________________initialize for first operation___________
    BANKSEL TRISB
    MOVLW B'11110000' 
    MOVWF TRISB   
    BANKSEL TRISC
    CLRF TRISC        
    BCF OPTION_REG, 7 ; b port pull up
    BANKSEL TRISD
    CLRF TRISD
    BANKSEL PORTC
    CLRF PORTC   
    BANKSEL TRISE
    CLRF TRISE
    
    BANKSEL SCAN_CODE
    MOVLW 13
    MOVWF KEY_CODE
    MOVWF ACTIVE_CURSOR
    MOVLW 0xF
    MOVWF DISP1
    MOVLW 0xF
    MOVWF DISP2
    MOVLW 0xF
    MOVWF DISP3
    MOVLW 0xF
    MOVWF DISP4
 ;.......................................................................
 ;............main loop..................................................
 

    
 
    
LOOP_MAIN:
 
    
    CALL SCAN_KEYPAD   
    CALL KEY_PROCESS
    CALL KEY_LOAD
    CALL SCAN_SCREEN 
   
   
    
    GOTO LOOP_MAIN
 ;.................................................................   
SCAN_KEYPAD:    ;**scans for key
    
    BANKSEL PORTB 
    MOVLW B'11111110'
    MOVWF PORTB
    CALL DELAY_SHORT
    BANKSEL PORTB 
    BTFSC PORTB, 4
    GOTO S1_R2
    MOVLW 0x01
    GOTO KEY_FOUND;----------------1
S1_R2:
    BTFSC PORTB, 5
    GOTO S1_R3
    MOVLW 0x04
    GOTO KEY_FOUND;----------------4
S1_R3:
    BTFSC PORTB, 6
    GOTO S1_R4
    MOVLW 0x07
    GOTO KEY_FOUND;----------------7
S1_R4:
    BTFSC PORTB, 7 
    GOTO S2
    MOVLW 0x0A
    GOTO KEY_FOUND;---------------- *  
S2:
    MOVLW B'11111101'
    MOVWF PORTB
    CALL DELAY_SHORT
    BANKSEL PORTB 
    BTFSC PORTB, 4
    GOTO S2_R2
    MOVLW 0x02
    GOTO KEY_FOUND;----------------2
S2_R2:
    BTFSC PORTB, 5
    GOTO S2_R3
    MOVLW 0x05
    GOTO KEY_FOUND;----------------5
S2_R3:
    BTFSC PORTB, 6
    GOTO S2_R4
    MOVLW 0x08
    GOTO KEY_FOUND;----------------8

S2_R4:
    BTFSC PORTB, 7
    GOTO S3
    MOVLW 0x00        
    GOTO KEY_FOUND;----------------0
S3:
      MOVLW B'11111011'
    MOVWF PORTB
    CALL DELAY_SHORT
    BANKSEL PORTB 
    BTFSC PORTB, 4
    GOTO S3_R2
    MOVLW 0x03
    GOTO KEY_FOUND;----------------3
S3_R2:
    
    BTFSC PORTB, 5
    GOTO S3_R3
    MOVLW 0x06
    GOTO KEY_FOUND;----------------6
S3_R3:
    BTFSC PORTB, 6
    GOTO S3_R4
    MOVLW 0x09
    GOTO KEY_FOUND;----------------9
S3_R4:
    BTFSC PORTB, 7
    GOTO S4
    MOVLW 0x0B
    GOTO KEY_FOUND;---------------- #   LOCK
S4:
    MOVLW B'11110111'
    MOVWF PORTB
   CALL DELAY_SHORT
    BANKSEL PORTB 
    BTFSC PORTB, 4
    GOTO S4_R2
    MOVLW 0x0C
    GOTO KEY_FOUND;----------------A   UNLOCK 
S4_R2:
    BTFSC PORTB, 5
    GOTO S4_R3
    MOVLW 0x0D
    GOTO KEY_FOUND;----------------B
S4_R3:
    BTFSC PORTB, 6
    GOTO S4_R4
    MOVLW 0x0E
    GOTO KEY_FOUND;----------------C
S4_R4:
    BTFSC PORTB, 7
    GOTO RE_SCAN
    MOVLW 0x0F
    ;GOTO KEY_FOUND;----------------D
                                     ;-----------------------KEY FOUND
KEY_FOUND:
    BANKSEL KEY_CODE
    MOVWF KEY_CODE
    
   
RE_SCAN: 
    
    
     RETURN 
     
;******************************************KEY PROCESS*********************     
     
KEY_PROCESS:    
    BANKSEL KEY_CODE
    MOVLW 11 
    SUBWF KEY_CODE,W;--------------OTHER KEY PRESSED
    BTFSS STATUS,C
    GOTO COMMAND_PASS1
    BSF CURSOR_COMMAND,2  
COMMAND_PASS1:  
    
    MOVLW 11 
    SUBWF KEY_CODE,W;--------------NUMBER KEY PRESSED
    BTFSC STATUS,C
    GOTO COMMAND_PASS2
    BCF CURSOR_COMMAND,2
    
    
COMMAND_PASS2:  
  
    MOVLW 11 
    SUBWF KEY_CODE,W;--------------LOCK
    BTFSS STATUS,Z
    GOTO COMMAND_PASS3
    BSF CURSOR_COMMAND,1
    
COMMAND_PASS3:
    
    
    MOVLW 12
    SUBWF KEY_CODE,W;--------------INPUT ENABLE
    BTFSS STATUS,Z
    GOTO COMMAND_PASS4
    BCF CURSOR_COMMAND,1
    
COMMAND_PASS4: 
    
   MOVLW 0x0E
   SUBWF KEY_CODE,W;--------------CLEAR DISPLAY
   BTFSS STATUS,Z
   GOTO COMMAND_PASS5
   BSF CURSOR_COMMAND,3  
    
COMMAND_PASS5:   
    
    

    
    MOVFW KEY_CODE_REG
    SUBWF KEY_CODE,W;--------------KEY CHANGED
    BTFSC STATUS,Z
    GOTO COMMAND_PASS6
    BCF CURSOR_COMMAND,0
    
COMMAND_PASS6:     
    
    

RETURN
 

  
;...........................LOADS KEY CODE TO THE DISPLAY REGISTER----------------	
KEY_LOAD:
    
   
    BANKSEL CURSOR_COMMAND
    BTFSC CURSOR_COMMAND,0
    GOTO DISPLAY_LOADING_CANCEL_1
    
    BTFSC CURSOR_COMMAND,1
    GOTO DISPLAY_LOADING_CANCEL_1
   
    BTFSC CURSOR_COMMAND,2
    GOTO DISPLAY_LOADING_CANCEL_1
        
   
    BANKSEL DISP1
    MOVFW DISP2
    MOVWF DISP1
    MOVFW DISP3
    MOVWF DISP2
    MOVFW DISP4
    MOVWF DISP3
    MOVFW KEY_CODE
    MOVWF DISP4
    MOVWF KEY_CODE_REG
    BSF CURSOR_COMMAND,0
  DISPLAY_LOADING_CANCEL_1:
     
     RETURN
;----------------------------------------------------------------------------     

SCAN_SCREEN:   ;..........scan display out  for 4 digits........................
   
   BTFSS CURSOR_COMMAND,3
   GOTO SKIP_CLEAR
   MOVLW 13
   MOVWF DISP1
   MOVWF DISP2 
   MOVWF DISP3 
   MOVWF DISP4 
   BCF CURSOR_COMMAND,3  
SKIP_CLEAR:  
  
    BANKSEL SCAN_CODE   
    MOVFW SCAN_CODE
    SUBLW 1
    BTFSS STATUS,Z
    GOTO J1
    MOVLW 0 
    CALL DIGIT_DISPLAY
    BANKSEL DISP1
    MOVFW DISP1
    CALL UPDATE_DISPLAY
J1: 
    BANKSEL SCAN_CODE
    MOVFW SCAN_CODE
    SUBLW 2
    BTFSS STATUS,Z
    GOTO J2
    MOVLW 1 
    CALL DIGIT_DISPLAY
    BANKSEL DISP2
    MOVFW DISP2
    CALL UPDATE_DISPLAY
J2:   
    BANKSEL SCAN_CODE
    MOVFW SCAN_CODE
    SUBLW 3
    BTFSS STATUS,Z
    GOTO J3
    MOVLW 2 
    CALL DIGIT_DISPLAY
    BANKSEL DISP3
    MOVFW DISP3
    CALL UPDATE_DISPLAY
    BANKSEL SCAN_CODE
J3:   
    MOVFW SCAN_CODE
    SUBLW 4    
    BTFSS STATUS,Z
    GOTO J4
    MOVLW 3 
    CALL DIGIT_DISPLAY
    BANKSEL DISP4
    MOVFW DISP4
    CALL UPDATE_DISPLAY
    J4:   
   BANKSEL SCAN_CODE
   INCF  SCAN_CODE
   MOVLW 5 
   SUBWF SCAN_CODE, W 
   BTFSS STATUS,Z
   GOTO RESET_PASS
   MOVLW 1
   MOVWF SCAN_CODE
RESET_PASS:  
  
  CALL DELAY_SHORT  
   
RETURN     
     
 ;-----------------------------------------------------------------------    
  
 DIGIT_DISPLAY:
    CALL DIGIT_TABLE 
    BANKSEL PORTD
    MOVWF PORTD
    RETURN
    
UPDATE_DISPLAY:
     
    CALL SEVEN_SEG_TABLE
    BANKSEL PORTC
    MOVWF PORTC           
 
   
    RETURN
    
 BLACK_DISPLAY:
      
    BANKSEL PORTD
    CLRF PORTD         
   
    RETURN   
    
    
    
DELAY_SHORT:
     MOVLW 50
    BANKSEL DELAY_COUNT_3
    MOVWF DELAY_COUNT_3
D_LOOP_SHORT:
    BANKSEL DELAY_COUNT_3
    DECFSZ DELAY_COUNT_3, F
    GOTO D_LOOP_SHORT
    
    RETURN
    
    
    
    
    
    
    RETURN
DELAY_LONG:
    MOVLW 255
    BANKSEL DELAY_COUNT_1
    MOVWF DELAY_COUNT_1
D_LOOP_1:
    MOVLW 20
    BANKSEL DELAY_COUNT_2
    MOVWF DELAY_COUNT_2
D_LOOP_2:
    BANKSEL DELAY_COUNT_2
    DECFSZ DELAY_COUNT_2, F
    GOTO D_LOOP_2
    BANKSEL DELAY_COUNT_1
    DECFSZ DELAY_COUNT_1, F
    GOTO D_LOOP_1
    RETURN

END


