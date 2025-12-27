;___________________________________________________________________________________________________________________________
 ;INTRODUCTION TO MICROCOMPUTER 2025-2026 TERMPROJECT HOME AUTOMATION
 ;RUVEYDA OZMEN
 ;151220222126
 ;27.12.2025
 ;ozmenruveyda00@gmail.com
 ;BOARD1-KEYPAD-7SEGMENT
;___________________________________________________________________________________________________________________________    
    
    
    
LIST P=16F877A,R=DEC
#include <P16F877A.INC>
__CONFIG _HS_OSC & _WDT_OFF & _PWRTE_ON & _LVP_OFF 

CBLOCK 0x110
    ;___________________________________________________________________________________________________________________________
    ;-----------------------tu? tak?m? set s?cakl?kve komut giri?  de?i?kenleri--------------------------------------------------------
    ;___________________________________________________________________________________________________________________________
    KEY_CODE  ;output register  for key codes    
    DELAY_COUNT_1 ;0x111
    DELAY_COUNT_2 ;0x112
    DELAY_COUNT_3;0x113
    SCAN_CODE;0x114
    DISP1;0x115
    DISP2;0x116
    DISP3;0x117
    DISP4;0x118
    ACTIVE_CURSOR;0x119
    CURSOR_COMMAND;0x11A
    KEY_CODE_REG;0x11B
    DISP_TO_INT1;0x11C
    DISP_TO_INT2 ;0x11D
    DISP_TO_INT3 ;0x11E
    DISP_TO_INT4;0x11F
    DISP_TO_INT1_1;0x120
    DISP_TO_INT2_1 ;0x121
    DISP_TO_INT3_1 ;0x122
    DISP_TO_INT4_1;0x123
    ;______________________________________________________________________________________________________________________________
    ;t?mer1 ?nterrupt control de?i?kenleri
    ;______________________________________________________________________________________________________________________________
    INDICATOR_TIMER_1H;0x124  
    INDICATOR_TIMER_1L;0x125
    DISPLAY_SEQ_REG;0x126
    INTERRUPT_STATUS_REG;0x127    TIMER1 INTERRUPT SIRASINDA STATUS REGISTER DEPOLAMA DE???KEN?
    ;_______________________________________________________________________________________________________________________________
    ;---------------------------------Di?er yaz?lama gidecek olan s?cakl?k set de?erinin tamsay? ve ondal?k de?erleri
    ;______________________________________________________________________________________________________________________________
    SET_TEMP_INT;0x128
    SET_TEMP_DEC;0x129
    
    spare1;  0x12A
    spare2;  0x12B
    spare3;  0x12C
    INTERRUPT_WREG;0x12D ;TIMER1 INTERRUPT SIRASINDA WREG DEPOLAMA DE???KEN?
    ;_________________________________________________________________________________________________________________________________
    ;--------------------------..TU? TAKIMINDAN G?R?LEN  SICAKLIK  D?G?T DE???KENLER?.............-----------------------------
    ;_________________________________________________________________________________________________________________________________
    KEY_TO_DISP1;0x12E
    KEY_TO_DISP2;0x12F
    KEY_TO_DISP3;0x130
    KEY_TO_DISP4;0x131
    ;_________________________________________________________________________________________________________________________________
    ;--------------------------DI?ER YAZILIMCININ GÖDERD??? SICAKLIK VE FN DEVR? ?Ç?N ÇEVR?M DE???KENLER?-----------------------------
    ;_________________________________________________________________________________________________________________________________
    INT_TO_DISP;0x132        D??ER YAZILIMDAN GELEN SICAKLIK YADA HIZ B?LG?S? INTEGER DEGER?
    INT_TO_DISP_REG;0x133     YARDIMCI REG?STER
    DEC_TO_DISP;0x134        D??ER YAZILIMDAN GELEN SICAKLIK YADA HIZ B?LG?S? INTEGER DEGER?
    ;D??ER YAZILIMDAN GELEN SICAKLIK VE FAN DEVR? 4 D?G?TE BU DE???KENLERDE ÇEVR?L?R
    INT_TO_DISP1;0x135
    INT_TO_DISP2;0x136
    INT_TO_DISP3;0x137
    INT_TO_DISP4;0x138
    
ENDC  
    
 
    ORG 0x0000
    
   
    GOTO MAIN  
    
    ORG 0x0004   ;INTERRUPT VECTOR  
    ;GOTO INTERRUPT_CONTROL
    
 ;********************************************************************************
 ;*INTERRUPT FOR TIMER1 COMPARE 
 ;********************************************************************************
    
 INTERRUPT_CONTROL:
  BANKSEL INTERRUPT_WREG  
  MOVWF INTERRUPT_WREG 
  
  MOVFW STATUS
  MOVWF INTERRUPT_STATUS_REG
     
  BANKSEL TMR1H
  CLRF TMR1H 
  CLRF TMR1L
   
  BANKSEL INDICATOR_TIMER_1L
    
  MOVLW 10        ;SETREGL
  SUBWF  INDICATOR_TIMER_1L,W
  BTFSC STATUS,C
  GOTO  INC_CANCEL1
  INCF INDICATOR_TIMER_1L,F
  GOTO INC_CANCEL4
INC_CANCEL1:
   
  BANKSEL INDICATOR_TIMER_1H 
  MOVLW 10       ;SETREGH
  SUBWF  INDICATOR_TIMER_1H,W
  BTFSC STATUS,C
  GOTO  INC_CANCEL3
  INCF INDICATOR_TIMER_1H,F
  CLRF INDICATOR_TIMER_1L
  GOTO  INC_CANCEL4
INC_CANCEL3:
  CLRF INDICATOR_TIMER_1L
  CLRF INDICATOR_TIMER_1H
  INCF DISPLAY_SEQ_REG,F
INC_CANCEL4: 
  
    MOVLW 35
    SUBWF DISPLAY_SEQ_REG,W
    BTFSC STATUS,C
    CLRF DISPLAY_SEQ_REG
    
    
     
  BANKSEL PIR1
  BCF PIR1,CCP1IF;CLEAR INTERRUPT OCCURED FLAG 
  BANKSEL INTERRUPT_STATUS_REG
  MOVFW INTERRUPT_STATUS_REG
  MOVWF STATUS 
  BANKSEL INTERRUPT_WREG
  MOVFW INTERRUPT_WREG
RETFIE
   
;*********************************************************************************    
   
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
    RETLW B'00010000'  ; 0
    RETLW B'00100000' ; 1
    RETLW B'01000000' ; 2
    RETLW B'10000000'  ; 3
    

;*********************************************************************************************************
;*TIMER1 INITIALIZATION
;*********************************************************************************************************
 COUNT_2_SECOND_TIMER_CALIBRATION: 
    
    BANKSEL T1CON  ;  ASYNCHRONOUS  MODE
    BSF T1CON,T1SYNC
    BCF T1CON,TMR1CS; INT SLOCK SOURCE
    
    BSF T1CON,T1CKPS1; 1/8 PRESCALE OSC
    BSF T1CON,T1CKPS0
    BCF T1CON,T1OSCEN  ;TMR1 OSC PINS DISABLE
    BSF T1CON,TMR1ON  ;TMR1 ENABLE
    
    BANKSEL CCPR1L
    MOVLW 50
    MOVWF CCPR1L
    BANKSEL CCPR1H
    MOVLW 2
    MOVWF CCPR1H
    
    BANKSEL CCP1CON;   =Compare mode, generate software interrupt on match (CCPxIF bit is set, CCPx pin is
                     ;               unaffected)
    BCF CCP1CON,CCP1M0
    BSF CCP1CON,CCP1M1
    BCF CCP1CON,CCP1M2
    BSF CCP1CON,CCP1M3      
   
    BANKSEL PIE1
    BSF PIE1,CCP1IE ;CAPTURE COMPARE INTERRUT ENABLE
    BSF INTCON,PEIE
    BSF INTCON,GIE
    
    RETURN
    
 ;********************************************************************************************************
 ;*CCONVERTS THE 4 DIGIT DATA TO THE DECIMAL  INDICATION
 ;********************************************************************************************************
DISPLAY_CONVERT:
   
    MOVLW 0x0A
    SUBWF DISP3,W
    BTFSS STATUS,Z
    GOTO DISPLAY_RESET
POINT_CONTROL_CANCEL:
 ;-------------------------------------------------------
  BANKSEL SET_TEMP_INT
 CLRF   SET_TEMP_INT 
 MOVFW KEY_TO_DISP1
 SUBLW 0x0F
 BTFSC STATUS,Z
 GOTO DISP1_LOAD_CANCEL
 MOVFW KEY_TO_DISP1
 MOVWF DISP_TO_INT1
DISP1_LOAD_CANCEL:
 INCF DISP_TO_INT1,W
 MOVWF DISP_TO_INT1_1

    
 MOVFW KEY_TO_DISP2
 SUBLW 0x0F
 BTFSC STATUS,Z
 GOTO DISP2_LOAD_CANCEL
 MOVFW KEY_TO_DISP2
 MOVWF DISP_TO_INT2
DISP2_LOAD_CANCEL: 
 INCF DISP_TO_INT2,W
 MOVWF DISP_TO_INT2_1

 MOVFW KEY_TO_DISP3
 SUBLW 0x0F
 BTFSC STATUS,Z
 GOTO DISP3_LOAD_CANCEL
 MOVFW KEY_TO_DISP3
 MOVWF DISP_TO_INT3 
DISP3_LOAD_CANCEL:
 INCF DISP_TO_INT3,W
 MOVWF DISP_TO_INT3_1
 
 MOVFW KEY_TO_DISP4
 SUBLW 0x0F
 BTFSC STATUS,Z
 GOTO DISP4_LOAD_CANCEL
 MOVFW KEY_TO_DISP4
 MOVWF DISP_TO_INT4
DISP4_LOAD_CANCEL: 
 INCF DISP_TO_INT4,W
 MOVWF DISP_TO_INT4_1
 
 

 
LOOP_DISP1:              ;---------------xX.X
  MOVLW 0
  SUBWF DISP_TO_INT1,W
  BTFSC STATUS,Z
  GOTO DISP1_CANCEL
  
  MOVLW 13
  SUBWF DISP_TO_INT1,W
  BTFSC STATUS,Z
  GOTO DISP1_CANCEL
 
  
  DECF DISP_TO_INT1_1,F
  BTFSC STATUS,Z
  GOTO DISP1_CANCEL
  MOVLW 10
  ADDWF  SET_TEMP_INT,F 
  GOTO LOOP_DISP1
 
 DISP1_CANCEL:
  ;......  
LOOP_DISP2:             ;---------------Xx.X
 MOVLW 0
 SUBWF DISP_TO_INT2,W
 BTFSC STATUS,Z
 GOTO DISP2_CANCEL 
 
  MOVLW 13
  SUBWF DISP_TO_INT2,W
  BTFSC STATUS,Z
  GOTO DISP2_CANCEL
  
 DECF DISP_TO_INT2_1,F
 BTFSC STATUS,Z
 GOTO DISP2_CANCEL
 MOVLW 1
 ADDWF  SET_TEMP_INT,F 
 GOTO LOOP_DISP2
 
DISP2_CANCEL: 
    
    
 MOVFW KEY_TO_DISP4
 MOVWF SET_TEMP_DEC  
    
GOTO DISPLAY_RESET_CANCEL    
 ;------------------------------------------------------
DISPLAY_RESET:   
    MOVFW DISP_TO_INT1
    MOVWF KEY_TO_DISP1
    MOVFW DISP_TO_INT2
    MOVWF KEY_TO_DISP2
    MOVFW DISP_TO_INT3
    MOVWF KEY_TO_DISP3
    MOVFW DISP_TO_INT4
    MOVWF KEY_TO_DISP4
    BCF CURSOR_COMMAND,1
DISPLAY_RESET_CANCEL:
      
RETURN
  
 ;**************************************FAN SPEED CONVERTION*********************************************
 ;*CCONVERTS THE DECIMAL VALUE TO 4 DIGIT DATA
 ;INT_TO_DISP 0XXX                
 ;********************************************************************************************************
 
INT_CONVERT_FAN: 
    BANKSEL INT_TO_DISP1
    CLRF INT_TO_DISP1
    CLRF INT_TO_DISP2
    CLRF INT_TO_DISP3
    CLRF INT_TO_DISP4
    BANKSEL INT_TO_DISP_REG    
    MOVFW INT_TO_DISP
    MOVWF INT_TO_DISP_REG
    
    
CONVRT_LOOP2:             ; CONVERT FOR DIGIT2
    MOVLW 100
    SUBWF INT_TO_DISP_REG,F
    BTFSS STATUS,C
    GOTO CONVRT_LOOP2_END
    INCF INT_TO_DISP2,f
    MOVLW 100
    SUBWF INT_TO_DISP,F
    GOTO CONVRT_LOOP2
CONVRT_LOOP2_END: 
    
    NOP
    MOVFW INT_TO_DISP
    MOVWF INT_TO_DISP_REG
CONVRT_LOOP3:           ; CONVERT FOR DIGIT3
    MOVLW 10
    SUBWF INT_TO_DISP_REG,F
    BTFSS STATUS,C
    GOTO CONVRT_LOOP3_END
    INCF INT_TO_DISP3
    MOVLW 10
    SUBWF INT_TO_DISP,F
    GOTO CONVRT_LOOP3
CONVRT_LOOP3_END: 
    
    NOP
    MOVFW INT_TO_DISP
    MOVWF INT_TO_DISP_REG
CONVRT_LOOP4:           ; CONVERT FOR DIGIT4
    MOVLW 1
    SUBWF INT_TO_DISP_REG,F
    BTFSS STATUS,C
    GOTO CONVRT_LOOP4_END
    INCF INT_TO_DISP4
    MOVLW 1
    SUBWF INT_TO_DISP,F
    GOTO CONVRT_LOOP4
CONVRT_LOOP4_END:   
    MOVLW 15
    MOVWF INT_TO_DISP1  
    
RETURN
;**************************************TEMPRATURE  CONVERTION*********************************************
 ;*CCONVERTS THE DECIMAL VALUE TO 4 DIGIT DATA
 ;INT_TO_DISP    XX               
 ;DEC_TO_DIS        X
 ;...............XX.X
 ;********************************************************************************************************
 
INT_CONVERT_TEMPR: 
    BANKSEL INT_TO_DISP1
    CLRF INT_TO_DISP1
    CLRF INT_TO_DISP2
    CLRF INT_TO_DISP3
    CLRF INT_TO_DISP4
    BANKSEL INT_TO_DISP_REG    ; CONVERT FOR DIGIT1
    MOVFW INT_TO_DISP
    MOVWF INT_TO_DISP_REG
CONVRT_LOOP11:  
    MOVLW 10
    SUBWF INT_TO_DISP_REG,F
    BTFSS STATUS,C
    GOTO CONVRT_LOOP11_END
    INCF INT_TO_DISP1
    MOVLW 10
    SUBWF INT_TO_DISP,F
    GOTO CONVRT_LOOP11
CONVRT_LOOP11_END: 
    
    NOP
    MOVFW INT_TO_DISP
    MOVWF INT_TO_DISP_REG
CONVRT_LOOP12:           ; CONVERT FOR DIGIT2
    MOVLW 1
    SUBWF INT_TO_DISP_REG,F
    BTFSS STATUS,C
    GOTO CONVRT_LOOP12_END
    INCF INT_TO_DISP2
    MOVLW 1
    SUBWF INT_TO_DISP,F
    GOTO CONVRT_LOOP12
CONVRT_LOOP12_END:
    
    NOP
    
    MOVLW 10
    MOVWF INT_TO_DISP3
    
    MOVFW DEC_TO_DISP
    MOVWF INT_TO_DISP4

  RETURN    
  
  
 ;************************************************************************************** 
  

  
   
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
    CALL COUNT_2_SECOND_TIMER_CALIBRATION  
    BANKSEL SCAN_CODE
    MOVLW 13
    MOVWF KEY_CODE
    MOVWF ACTIVE_CURSOR
    MOVLW 0xF
    MOVWF KEY_TO_DISP1
    MOVLW 0xF
    MOVWF KEY_TO_DISP2
    MOVLW 0xF
    MOVWF KEY_TO_DISP3
    MOVLW 0xF
    MOVWF KEY_TO_DISP4
 ;.......................................................................
 ;............main loop..................................................
 
      
    
LOOP_MAIN:
 
    
    CALL SCAN_KEYPAD   
    CALL KEY_PROCESS
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
    GOTO KEY_NOT_FOUND
    MOVLW 0x0F
    
                                     ;-----------------------KEY FOUND
KEY_FOUND:
    
    BANKSEL KEY_CODE
    MOVWF KEY_CODE
    MOVLW 1
    SUBWF KEY_CODE_REG,W
    BTFSS STATUS,Z
    CALL KEY_LOAD
    CALL DELAY_LONG
    RETURN
    
KEY_NOT_FOUND: 
    
   MOVLW 0
   movwf KEY_CODE_REG 
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
    BANKSEL KEY_CODE
    MOVLW 11 
    SUBWF KEY_CODE,W;--------------NUMBER KEY PRESSED
    BTFSC STATUS,C
    GOTO COMMAND_PASS2
    BCF CURSOR_COMMAND,2
    
    
COMMAND_PASS2:  
    BANKSEL KEY_CODE
    MOVLW 11 
    SUBWF KEY_CODE,W;--------------LOCK
    BTFSS STATUS,Z
    GOTO COMMAND_PASS3
    BANKSEL DISPLAY_SEQ_REG
    CLRF  DISPLAY_SEQ_REG
    BANKSEL CURSOR_COMMAND
    BSF CURSOR_COMMAND,1
    CALL DISPLAY_CONVERT
    BANKSEL PIE1
    CALL COUNT_2_SECOND_TIMER_CALIBRATION
    
COMMAND_PASS3:
    
    BANKSEL KEY_CODE
    MOVLW 12
    SUBWF KEY_CODE,W;--------------INPUT ENABLE
    BTFSS STATUS,Z
    GOTO COMMAND_PASS4
    BCF CURSOR_COMMAND,1
    MOVLW 0xF
    MOVWF KEY_TO_DISP1
    MOVLW 0xF
    MOVWF KEY_TO_DISP2
    MOVLW 0xF
    MOVWF KEY_TO_DISP3
    MOVLW 0xF
    MOVWF KEY_TO_DISP4
   
    
COMMAND_PASS4: 
   BANKSEL KEY_CODE
   BTFSC  CURSOR_COMMAND,1
   GOTO COMMAND_PASS5
   MOVLW 0x0E
   SUBWF KEY_CODE,W;--------------CLEAR DISPLAY
   BTFSS STATUS,Z
   GOTO COMMAND_PASS5
   BSF CURSOR_COMMAND,3
COMMAND_PASS5:   

RETURN
;...........................LOADS KEY CODE TO THE DISPLAY REGISTER----------------	
KEY_LOAD:
    
   
    BANKSEL KEY_CODE_REG
    MOVLW 1
    SUBWF KEY_CODE_REG,W
    BTFSC STATUS,Z
    GOTO  DISPLAY_LOADING_CANCEL_1
    
    BTFSC CURSOR_COMMAND,1
    GOTO DISPLAY_LOADING_CANCEL_1
   
    BTFSC CURSOR_COMMAND,2
    GOTO DISPLAY_LOADING_CANCEL_1
        
   
    BANKSEL KEY_TO_DISP1
    MOVFW KEY_TO_DISP3
    SUBLW 0x0A
    BTFSC STATUS,Z
    GOTO DISPLAY_LOADING_CANCEL_1
    MOVFW KEY_TO_DISP2
    MOVWF KEY_TO_DISP1
    MOVFW KEY_TO_DISP3
    MOVWF KEY_TO_DISP2
    MOVFW KEY_TO_DISP4
    MOVWF KEY_TO_DISP3
    BANKSEL KEY_CODE
    MOVFW KEY_CODE
    BANKSEL KEY_TO_DISP4
    MOVWF KEY_TO_DISP4
    BANKSEL KEY_CODE_REG
    MOVLW 1
    MOVWF KEY_CODE_REG
   
DISPLAY_LOADING_CANCEL_1:
     
     RETURN
;----------------------------------------------------------------------------     
;*************************************************************************************
;*  DISPLAY OUTPUT    
;*************************************************************************************
SCAN_SCREEN:   ;..........scan display out  for 4 digits........................
   BANKSEL CURSOR_COMMAND
   BTFSS CURSOR_COMMAND,3
   GOTO SKIP_CLEAR_DISPLAY
   MOVLW 13
   MOVWF KEY_TO_DISP1
   MOVWF KEY_TO_DISP2 
   MOVWF KEY_TO_DISP3 
   MOVWF KEY_TO_DISP4 
   BCF  CURSOR_COMMAND,3  
SKIP_CLEAR_DISPLAY:  
    
   BANKSEL CURSOR_COMMAND
   BTFSC CURSOR_COMMAND,1
   GOTO SKIP_SCREEN0
   MOVFW  KEY_TO_DISP1
   MOVWF DISP1
   MOVFW  KEY_TO_DISP2
   MOVWF DISP2 
   MOVFW  KEY_TO_DISP3
   MOVWF DISP3 
   MOVFW  KEY_TO_DISP4
   MOVWF DISP4
   
   CLRF DISPLAY_SEQ_REG
   GOTO SKIP_SCREEN3
    
SKIP_SCREEN0:    
    
   BANKSEL CURSOR_COMMAND
   BTFSS CURSOR_COMMAND,1
   GOTO SKIP_SCREEN3
  
   BANKSEL DISPLAY_SEQ_REG
   MOVLW 10
   SUBWF DISPLAY_SEQ_REG,W
   BTFSS STATUS,Z
   GOTO SKIP_SCREEN1
   MOVFW  DISP_TO_INT1
   MOVWF DISP1
   MOVFW  DISP_TO_INT2
   MOVWF DISP2 
   MOVFW  DISP_TO_INT3
   MOVWF DISP3 
   MOVFW  DISP_TO_INT4
   MOVWF DISP4
   GOTO SKIP_SCREEN3
SKIP_SCREEN1: 
  
    
   BANKSEL DISPLAY_SEQ_REG
   MOVLW 20
   SUBWF DISPLAY_SEQ_REG,W
   BTFSS STATUS,Z
   GOTO SKIP_SCREEN2
    ;----------!!!!!!!!!!!!!----------d??arden gelen s?cakl??? burada giriniz
   BANKSEL  INT_TO_DISP
   MOVLW 23 
   MOVWF INT_TO_DISP 
    MOVLW 5
    MOVWF DEC_TO_DISP
    ;_________________________________________________________________________
   CALL INT_CONVERT_TEMPR
   MOVFW  INT_TO_DISP1
   MOVWF DISP1
   MOVFW  INT_TO_DISP2
   MOVWF DISP2 
   MOVFW  INT_TO_DISP3
   MOVWF DISP3 
   MOVFW  INT_TO_DISP4
   MOVWF DISP4
   GOTO SKIP_SCREEN3
SKIP_SCREEN2: 
  
 
 BANKSEL DISPLAY_SEQ_REG
   MOVLW 30
   SUBWF DISPLAY_SEQ_REG,W
   BTFSS STATUS,C
   GOTO SKIP_SCREEN3
   ;-----------!!!!!!!!!!!!!----------d??arden gelen fan devrini burada giriniz 
   BANKSEL  INT_TO_DISP
   MOVLW 234 
   MOVWF INT_TO_DISP 
  ;_________________________________________________________________________  
   CALL INT_CONVERT_FAN
   MOVFW  INT_TO_DISP1
   MOVWF DISP1
   MOVFW  INT_TO_DISP2
   MOVWF DISP2 
   MOVFW  INT_TO_DISP3
   MOVWF DISP3 
   MOVFW  INT_TO_DISP4
   MOVWF DISP4
  
SKIP_SCREEN3: 
  ;__________________________ekrada 4 digit yazd?rma prosedürü---------------
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
     

 ;*************************************************************************
 
DIGIT_DISPLAY:
    CALL DIGIT_TABLE 
    BANKSEL PORTD
    MOVWF PORTD
    RETURN
;-------------------------------------------------    
UPDATE_DISPLAY:
     
    CALL SEVEN_SEG_TABLE
    BANKSEL PORTC
    MOVWF PORTC           
 
   
    RETURN
    
 ;------------------------------------------------   
BLACK_DISPLAY:
      
    BANKSEL PORTD
    CLRF PORTD         
   
    RETURN   
    
;-------------------------------------------------   
DELAY_SHORT:
     MOVLW 1
    BANKSEL DELAY_COUNT_3
    MOVWF DELAY_COUNT_3
D_LOOP_SHORT:
    BANKSEL DELAY_COUNT_3
    DECFSZ DELAY_COUNT_3, F
    GOTO D_LOOP_SHORT
    
    RETURN
    
  ;---------------------------------------------
    
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
    
    ;-----------------------------------------------------------------------  

    

END
