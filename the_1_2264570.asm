; When you press and relase the RB0 then the four top most LEDs connected to PORTC will be turned on
; Then when you press the RB0 the other four LEDs connected to PORTC  will be turned on
; To execute this program The jumper J13 should be ground side

LIST    P=18F8722

#INCLUDE <p18f8722.inc> 
; CONFIG1H
  CONFIG  OSC = HSPLL, FCMEN = OFF, IESO = OFF
; CONFIG2L
  CONFIG  PWRT = OFF, BOREN = OFF, BORV = 3
; CONFIG2H
  CONFIG  WDT = OFF, WDTPS = 32768
; CONFIG3L
  CONFIG  MODE = MC, ADDRBW = ADDR20BIT, DATABW = DATA16BIT, WAIT = OFF
; CONFIG3H
  CONFIG  CCP2MX = PORTC, ECCPMX = PORTE, LPT1OSC = OFF, MCLRE = ON
; CONFIG4L
  CONFIG  STVREN = ON, LVP = OFF, BBSIZ = BB2K, XINST = OFF
; CONFIG5L
  CONFIG  CP0 = OFF, CP1 = OFF, CP2 = OFF, CP3 = OFF, CP4 = OFF, CP5 = OFF
  CONFIG  CP6 = OFF, CP7 = OFF
; CONFIG5H
  CONFIG  CPB = OFF, CPD = OFF
; CONFIG6L
  CONFIG  WRT0 = OFF, WRT1 = OFF, WRT2 = OFF, WRT3 = OFF, WRT4 = OFF
  CONFIG  WRT5 = OFF, WRT6 = OFF, WRT7 = OFF
; CONFIG6H
  CONFIG  WRTC = OFF, WRTB = OFF, WRTD = OFF
; CONFIG7L
  CONFIG  EBTR0 = OFF, EBTR1 = OFF, EBTR2 = OFF, EBTR3 = OFF, EBTR4 = OFF
  CONFIG  EBTR5 = OFF, EBTR6 = OFF, EBTR7 = OFF
; CONFIG7H
  CONFIG  EBTRB = OFF
  
 led_flag        udata 0X20
 led_flag
 button_counter  udata 0X21
 button_counter
 button_pressed  udata 0X22
 button_pressed
 count_a	 udata 0X23
 count_a
 
 numb		udata 0x24
 numb
 numc		udata 0X25
 numc		
 button_counter_c udata 0X26
 button_counter_c
 
 UDATA_ACS
  t1	res 1	; used in delay
  t2	res 1	; used in delay
  t3	res 1	; used in delay
  ;state res 1	; controlled by RB0 button

ORG     0x00
goto    main
 
DELAY	; Time Delay Routine with 3 nested loops
    MOVLW 82	; Copy desired value to W
    MOVWF t3	; Copy W into t3
    _loop3:
	MOVLW 0xA0  ; Copy desired value to W
	MOVWF t2    ; Copy W into t2
	_loop2:
	    MOVLW 0x9F	; Copy desired value to W
	    MOVWF t1	; Copy W into t1
	    _loop1:
		decfsz t1,F ; Decrement t1. If 0 Skip next instruction
		GOTO _loop1 ; ELSE Keep counting down
		decfsz t2,F ; Decrement t2. If 0 Skip next instruction
		GOTO _loop2 ; ELSE Keep counting down
		decfsz t3,F ; Decrement t3. If 0 Skip next instruction
		GOTO _loop3 ; ELSE Keep counting down
		return

init
movlw b'00010000' ;RA4 is an input
movwf TRISA
clrf LATA
clrf PORTA
 
movlw b'00011000' ;RE3 and RE4 are input
movwf TRISE
clrf LATE
clrf PORTE

movlw h'00' ;B C D are output
movwf TRISB
clrf  LATB
movwf TRISC
clrf  LATC
movwf TRISD
clrf  LATD
return

onesec		
movlw h'0F'
movwf LATB
movwf LATC
movlw h'FF'
movwf LATD
call DELAY

clrf PORTB
clrf PORTC
clrf PORTD
		
return
		
select		
    clrf PORTB
    clrf PORTC
    clrf PORTD  
		
pressa:
    btfss   PORTA, 4	;check if ra4 pressed
    goto    pressa	;skip if pressed
releasea:
    btfsc   PORTA, 4	;check if ra4 released
    goto    releasea	;skip if released
    INCF    count_a
    
pressa_2:
    btfss   PORTA, 4	;check if ra4 pressed
    goto    pressE3	;skip if pressed
release_2:
    btfsc   PORTA ,4
    goto release_2
    INCF    count_a
    goto pressa_2

    
pressE3:
    btfss PORTE,3
    goto pressa_2
releaseE3:
    btfsc PORTE,3
    goto releaseE3


portB:    
    
    checke4_b:
	movlw h'05'    
	cpfseq button_counter  ;---Compare f with 4  .. Skip if f = W.
	goto pressE3_b
	clrf button_counter
	clrf numb
	clrf PORTB

    pressE3_b:	;check E3 one more time in portB
	
	btfss PORTE,3
	goto pressE4_b
	
    releaseE3_b:	    
	btfsc PORTE,3
	goto releaseE3_b
	goto portC
	
    pressE4_b:		    ;start press E4...
	btfss	PORTE,4
	goto	pressE3_b
	
    
    releaseE4_b:
	btfsc	PORTE,4
	goto	releaseE4_b
	incf	button_counter
	goto	ledB

portC:
    
    checke4_c:
	movlw h'05'    
	cpfseq button_counter_c  ;---Compare f with 4  .. Skip if f = W.
	goto pressE3_c
	clrf button_counter_c
	clrf numc
	clrf PORTC
	
    pressE3_c:		    ;check E3 one more time in portC
	btfss PORTE,3	    
	goto pressE4_c
    releaseE3_c:	    
	btfsc PORTE,3
	goto releaseE3_c
	goto result
	
    pressE4_c:		    ;start press E4...
	btfss PORTE,4
	goto pressE3_c
    releaseE4_c:
	btfsc PORTE,4
	goto releaseE4_c
	incf button_counter_c
	goto ledC
	
    
    
ledB:
    
    btfss PORTB,0
    goto b_1
    btfss PORTB,1
    goto b_2
    btfss PORTB,2
    goto b_3
    btfss PORTB,3
    goto b_4
 
    
    b_1:
	movlw b'00000001'
	movwf LATB
	movlw h'01'
	movwf numb
	goto checke4_b
    b_2:
	movlw b'00000011'
	movwf LATB
	movlw h'02'
	movwf numb
	goto checke4_b
    b_3:
	movlw b'00000111'
	movwf LATB
	movlw h'03'
	movwf numb
	goto checke4_b
    b_4:
	movlw b'00001111'
	movwf LATB
	movlw h'04'
	movwf numb
	goto checke4_b
   
	
ledC:
    btfss PORTC,0
    goto c_1
    btfss PORTC,1
    goto c_2
    btfss PORTC,2
    goto c_3
    btfss PORTC,3
    goto c_4
   
    
    c_1:
	movlw b'00000001'
	movwf LATC
	movlw h'01'
	movwf numc
	goto checke4_c
    c_2:
	movlw b'00000011'
	movwf LATC
	movlw h'02'
	movwf numc
	goto checke4_c
    c_3:
	movlw b'00000111'
	movwf LATC
	movlw h'03'
	movwf numc
	goto checke4_c
    c_4:
	movlw b'00001111'
	movwf LATC
	movlw h'04'
	movwf numc
	goto checke4_c
	
	
result:
    btfss count_a,0
    goto subtraction
    goto addition
    
portD:
    
    nn0:                      ;---Compare f with W .. Skip if f = W. 
	movlw h'00'		; ----- Then Select LED----
	cpfseq numb
	goto nn1
	goto led0
    
    nn1:
	movlw h'01'
	cpfseq numb
	goto nn2
	goto led1
    nn2:
	movlw h'02'
	cpfseq numb
	goto nn3
	goto led2
    nn3:
	movlw h'03'
	cpfseq numb
	goto nn4
	goto led3
    nn4:
	movlw h'04'
	cpfseq numb
	goto nn5
	goto led4
    nn5:
	movlw h'05'
	cpfseq numb
	goto nn6
	goto led5
    nn6:
	movlw h'06'
	cpfseq numb
	goto nn7
	goto led6
    nn7:
	movlw h'07'
	cpfseq numb
	goto led8
	goto led7         ;----- End of selecting LED
    
    
    led0:
	movlw b'00000000'   ;----PortD LEDS
	movwf LATD
	call DELAY
	call select
    led1:
	movlw b'00000001'
	movwf LATD
	call DELAY
	call select
    led2:
	movlw b'00000011'
	movwf LATD
	call DELAY
	call select
    led3:
	movlw b'00000111'
	movwf LATD
	call DELAY
	call select
    led4:
	movlw b'00001111'
	movwf LATD
	call DELAY
	call select
    led5:
	movlw b'00011111'
	movwf LATD
	call DELAY
	call select
    led6:
	movlw b'00111111'
	movwf LATD
	call select
    led7:
	movlw b'01111111'
	movwf LATD
	call DELAY

	call select
    led8:
	movlw b'11111111'
	movwf LATD
	call DELAY
	call select           ;---- END PortD LEDS
	
	
addition:
    movf numc,w
    addwf numb
    movf numb ,w
    goto portD
    
subtraction:  	      
    
    movf numc,w
    cpfsgt numb	    ;-- cpfsgt Compare f with W, GO negative if numb < numc  ---
    goto negative    ; ----------- ---------- --- GO positive Otherwise !!
    goto positive
    
    negative:       ;-- if portB less than portC
	     ; W  currently holds numc
	    movf numb,w
	    subwf numc,0   ;Subtract W from f , 0 holds in W
	    movwf numb
	    goto portD
    positive:
	  ; W  currently holds numc
	    subwf numb,1    ;Subtract W from f ,1 holds in REG
	    goto portD
	    


main:
call init
call onesec
call select

end



