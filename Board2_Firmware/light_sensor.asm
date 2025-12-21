LIST p=16f877a ;PIC16F877 device is selected.
INCLUDE "p16f877a.inc" ;assume this line as adding library of MCU.
__CONFIG h'3F31' ;configuration bits are assigned.

    ; ------------------------
    ; Efe Burak Östünda?
    ; 20 Dec 2025
    ; efe.ostundag@gmail.com
    ; ------------------------
    
    ; Program Memory
    ; [0x400 - 0x500]  (256 byte)
    
    ; Memory Management
    ; [140h - 160h] claimed
    
    ; PORT Management
    ; PORTD - AN1
    
   CBLOCK 0x140
   ; 0.1 lux 1111 1010 | 100k lux 0000 0000
   ; night 0.25 lux
   ; day 10k to 100k
   ; Vth selected 4.2k lux 1100 1001
   light_intensity_raw 
   
   ENDC
    
ORG 0x400
    GOTO START
    START:
    ; INIT
    
    ; dev
    ; portd output for leds
    banksel TRISD
    CLRF TRISD 
    ;end dev
    
     ; right justified ADRESH:ADRESL[7-6]
    ; 0000 PCFG3:PCFG0
    MOVLW b'00000000'
    MOVWF ADCON1
    
    banksel ADCON0
    ; channel AN1
    MOVLW b'11001101'
    MOVWF ADCON0
    
    
 MAIN_LOOP:
    BSF ADCON0, GO
 WAIT_ADC:
    BTFSC ADCON0, GO 
    GOTO WAIT_ADC
    MOVF ADRESH, W
    ; W = light_intensity_raw
    
    ; set values
    MOVWF PORTD ; DEV
    banksel 0x140
    MOVWF light_intensity_raw
    
    ; if W > 1100 1001 : W = 111 1111 
    SUBLW b'11001001'
    BTFSC STATUS, C
    GOTO G1
    MOVLW b'11111111'
    MOVWF light_intensity_raw
 G1:
    
    ; dev
    banksel 0x140
    MOVF light_intensity_raw , W
    banksel PORTD
    MOVWF PORTD
    ; end dev
    
    GOTO MAIN_LOOP 
END
    
    
    ; DONE LIST
    ; 2.2.2-1
    ; 2.2.2-2