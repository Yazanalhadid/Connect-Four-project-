
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;ProjectConnectFourCode.c,11 :: 		void interrupt(void){
;ProjectConnectFourCode.c,13 :: 		if(INTCON & 0x04){//TMR0 Overflow ISR, every 1ms
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;ProjectConnectFourCode.c,15 :: 		TMR0=248;
	MOVLW      248
	MOVWF      TMR0+0
;ProjectConnectFourCode.c,16 :: 		tick++; // will increment every 1ms
	INCF       _tick+0, 1
	BTFSC      STATUS+0, 2
	INCF       _tick+1, 1
;ProjectConnectFourCode.c,17 :: 		INTCON = INTCON & 0xFB;// Clear T0IF
	MOVLW      251
	ANDWF      INTCON+0, 1
;ProjectConnectFourCode.c,18 :: 		}
L_interrupt0:
;ProjectConnectFourCode.c,20 :: 		if(PIR1&0x04){//CCP1 interrupt
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt1
;ProjectConnectFourCode.c,21 :: 		if(HL){ //high
	MOVF       _HL+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt2
;ProjectConnectFourCode.c,22 :: 		CCPR1H= angle >>8;
	MOVF       _angle+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;ProjectConnectFourCode.c,23 :: 		CCPR1L= angle;
	MOVF       _angle+0, 0
	MOVWF      CCPR1L+0
;ProjectConnectFourCode.c,24 :: 		HL=0;//next time low
	CLRF       _HL+0
;ProjectConnectFourCode.c,25 :: 		CCP1CON=0x09;//next time Falling edge
	MOVLW      9
	MOVWF      CCP1CON+0
;ProjectConnectFourCode.c,26 :: 		TMR1H=0;
	CLRF       TMR1H+0
;ProjectConnectFourCode.c,27 :: 		TMR1L=0;
	CLRF       TMR1L+0
;ProjectConnectFourCode.c,28 :: 		}
	GOTO       L_interrupt3
L_interrupt2:
;ProjectConnectFourCode.c,30 :: 		CCPR1H= (40000 - angle) >>8;
	MOVF       _angle+0, 0
	SUBLW      64
	MOVWF      R3+0
	MOVF       _angle+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      156
	MOVWF      R3+1
	MOVF       R3+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;ProjectConnectFourCode.c,31 :: 		CCPR1L= (40000 - angle);
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
;ProjectConnectFourCode.c,32 :: 		CCP1CON=0x08; //next time rising edge
	MOVLW      8
	MOVWF      CCP1CON+0
;ProjectConnectFourCode.c,33 :: 		HL=1; //next time High
	MOVLW      1
	MOVWF      _HL+0
;ProjectConnectFourCode.c,34 :: 		TMR1H=0;
	CLRF       TMR1H+0
;ProjectConnectFourCode.c,35 :: 		TMR1L=0;
	CLRF       TMR1L+0
;ProjectConnectFourCode.c,37 :: 		}
L_interrupt3:
;ProjectConnectFourCode.c,39 :: 		PIR1=PIR1&0xFB;
	MOVLW      251
	ANDWF      PIR1+0, 1
;ProjectConnectFourCode.c,40 :: 		}
L_interrupt1:
;ProjectConnectFourCode.c,41 :: 		if(PIR1&0x01){//TMR1 ovwerflow
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt4
;ProjectConnectFourCode.c,44 :: 		PIR1=PIR1&0xFE;
	MOVLW      254
	ANDWF      PIR1+0, 1
;ProjectConnectFourCode.c,45 :: 		}
L_interrupt4:
;ProjectConnectFourCode.c,47 :: 		}
L_end_interrupt:
L__interrupt25:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;ProjectConnectFourCode.c,48 :: 		void main ()
;ProjectConnectFourCode.c,54 :: 		TMR0=248;
	MOVLW      248
	MOVWF      TMR0+0
;ProjectConnectFourCode.c,55 :: 		TRISD=0x00;
	CLRF       TRISD+0
;ProjectConnectFourCode.c,56 :: 		PORTD=0x00;
	CLRF       PORTD+0
;ProjectConnectFourCode.c,57 :: 		TRISC=0x00;
	CLRF       TRISC+0
;ProjectConnectFourCode.c,58 :: 		PORTC =0x00;
	CLRF       PORTC+0
;ProjectConnectFourCode.c,59 :: 		TRISB = 0xFF ;
	MOVLW      255
	MOVWF      TRISB+0
;ProjectConnectFourCode.c,60 :: 		PORTB = 0xFF ;
	MOVLW      255
	MOVWF      PORTB+0
;ProjectConnectFourCode.c,61 :: 		while(1)
L_main5:
;ProjectConnectFourCode.c,64 :: 		if(PORTB = 0xff ){
	MOVLW      255
	MOVWF      PORTB+0
	MOVF       PORTB+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main7
;ProjectConnectFourCode.c,65 :: 		PORTD =0x00;
	CLRF       PORTD+0
;ProjectConnectFourCode.c,66 :: 		}
	GOTO       L_main8
L_main7:
;ProjectConnectFourCode.c,67 :: 		else if( PORTB == 0x00 )
	MOVF       PORTB+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main9
;ProjectConnectFourCode.c,69 :: 		rd = (rand () %7)+1 ;
	CALL       _rand+0
	MOVLW      7
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	INCF       R0+0, 0
	MOVWF      main_rd_L0+0
;ProjectConnectFourCode.c,72 :: 		PORTD =0x01;
	MOVLW      1
	MOVWF      PORTD+0
;ProjectConnectFourCode.c,73 :: 		for( st1=0 ;st1 <rd;st1++)
	CLRF       main_st1_L0+0
L_main10:
	MOVF       main_rd_L0+0, 0
	SUBWF      main_st1_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main11
;ProjectConnectFourCode.c,75 :: 		for( st2=0 ;st2 <240;st2++)
	CLRF       main_st2_L0+0
L_main13:
	MOVLW      240
	SUBWF      main_st2_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main14
;ProjectConnectFourCode.c,77 :: 		PORTD=0x03;
	MOVLW      3
	MOVWF      PORTD+0
;ProjectConnectFourCode.c,78 :: 		mymsDelay(1);
	MOVLW      1
	MOVWF      FARG_mymsDelay+0
	MOVLW      0
	MOVWF      FARG_mymsDelay+1
	CALL       _mymsDelay+0
;ProjectConnectFourCode.c,79 :: 		PORTD=0x01;
	MOVLW      1
	MOVWF      PORTD+0
;ProjectConnectFourCode.c,80 :: 		mymsDelay(1);
	MOVLW      1
	MOVWF      FARG_mymsDelay+0
	MOVLW      0
	MOVWF      FARG_mymsDelay+1
	CALL       _mymsDelay+0
;ProjectConnectFourCode.c,75 :: 		for( st2=0 ;st2 <240;st2++)
	INCF       main_st2_L0+0, 1
;ProjectConnectFourCode.c,82 :: 		}
	GOTO       L_main13
L_main14:
;ProjectConnectFourCode.c,73 :: 		for( st1=0 ;st1 <rd;st1++)
	INCF       main_st1_L0+0, 1
;ProjectConnectFourCode.c,83 :: 		}
	GOTO       L_main10
L_main11:
;ProjectConnectFourCode.c,86 :: 		TMR1H=0;
	CLRF       TMR1H+0
;ProjectConnectFourCode.c,87 :: 		TMR1L=0;
	CLRF       TMR1L+0
;ProjectConnectFourCode.c,90 :: 		HL=1; //start high
	MOVLW      1
	MOVWF      _HL+0
;ProjectConnectFourCode.c,91 :: 		CCP1CON=0x08;//
	MOVLW      8
	MOVWF      CCP1CON+0
;ProjectConnectFourCode.c,95 :: 		T1CON=0x01;//TMR1 On Fosc/4 (inc 0.5uS) with 0 prescaler (TMR1 overflow after 0xFFFF counts ==65535)==> 32.767ms
	MOVLW      1
	MOVWF      T1CON+0
;ProjectConnectFourCode.c,97 :: 		INTCON=0x20;//enable TMR0 overflow, TMR1 overflow, External interrupts and peripheral interrupts;
	MOVLW      32
	MOVWF      INTCON+0
;ProjectConnectFourCode.c,98 :: 		PIE1=PIE1|0x04;// Enable CCP1 interrupts
	BSF        PIE1+0, 2
;ProjectConnectFourCode.c,99 :: 		CCPR1H=2000>>8;
	MOVLW      7
	MOVWF      CCPR1H+0
;ProjectConnectFourCode.c,100 :: 		CCPR1L=2000;
	MOVLW      208
	MOVWF      CCPR1L+0
;ProjectConnectFourCode.c,105 :: 		angle=4800;
	MOVLW      192
	MOVWF      _angle+0
	MOVLW      18
	MOVWF      _angle+1
;ProjectConnectFourCode.c,106 :: 		mymsDelay(900);
	MOVLW      132
	MOVWF      FARG_mymsDelay+0
	MOVLW      3
	MOVWF      FARG_mymsDelay+1
	CALL       _mymsDelay+0
;ProjectConnectFourCode.c,107 :: 		angle=2400;
	MOVLW      96
	MOVWF      _angle+0
	MOVLW      9
	MOVWF      _angle+1
;ProjectConnectFourCode.c,108 :: 		mymsDelay(900);
	MOVLW      132
	MOVWF      FARG_mymsDelay+0
	MOVLW      3
	MOVWF      FARG_mymsDelay+1
	CALL       _mymsDelay+0
;ProjectConnectFourCode.c,111 :: 		PORTD =0x00;
	CLRF       PORTD+0
;ProjectConnectFourCode.c,113 :: 		for( st1=0 ;st1 <rd;st1++)
	CLRF       main_st1_L0+0
L_main16:
	MOVF       main_rd_L0+0, 0
	SUBWF      main_st1_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main17
;ProjectConnectFourCode.c,115 :: 		for( st2=0 ;st2 <240;st2++)
	CLRF       main_st2_L0+0
L_main19:
	MOVLW      240
	SUBWF      main_st2_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main20
;ProjectConnectFourCode.c,118 :: 		PORTD=0x02;
	MOVLW      2
	MOVWF      PORTD+0
;ProjectConnectFourCode.c,119 :: 		mymsDelay(1);
	MOVLW      1
	MOVWF      FARG_mymsDelay+0
	MOVLW      0
	MOVWF      FARG_mymsDelay+1
	CALL       _mymsDelay+0
;ProjectConnectFourCode.c,120 :: 		PORTD=0x00;
	CLRF       PORTD+0
;ProjectConnectFourCode.c,121 :: 		mymsDelay(1);
	MOVLW      1
	MOVWF      FARG_mymsDelay+0
	MOVLW      0
	MOVWF      FARG_mymsDelay+1
	CALL       _mymsDelay+0
;ProjectConnectFourCode.c,115 :: 		for( st2=0 ;st2 <240;st2++)
	INCF       main_st2_L0+0, 1
;ProjectConnectFourCode.c,123 :: 		}
	GOTO       L_main19
L_main20:
;ProjectConnectFourCode.c,113 :: 		for( st1=0 ;st1 <rd;st1++)
	INCF       main_st1_L0+0, 1
;ProjectConnectFourCode.c,124 :: 		}
	GOTO       L_main16
L_main17:
;ProjectConnectFourCode.c,125 :: 		}
L_main9:
L_main8:
;ProjectConnectFourCode.c,126 :: 		}
	GOTO       L_main5
;ProjectConnectFourCode.c,128 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_mymsDelay:

;ProjectConnectFourCode.c,130 :: 		void mymsDelay(unsigned int dcntr){
;ProjectConnectFourCode.c,131 :: 		tick=0;
	CLRF       _tick+0
	CLRF       _tick+1
;ProjectConnectFourCode.c,132 :: 		while(tick< dcntr);
L_mymsDelay22:
	MOVF       FARG_mymsDelay_dcntr+1, 0
	SUBWF      _tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__mymsDelay28
	MOVF       FARG_mymsDelay_dcntr+0, 0
	SUBWF      _tick+0, 0
L__mymsDelay28:
	BTFSC      STATUS+0, 0
	GOTO       L_mymsDelay23
	GOTO       L_mymsDelay22
L_mymsDelay23:
;ProjectConnectFourCode.c,133 :: 		}
L_end_mymsDelay:
	RETURN
; end of _mymsDelay
