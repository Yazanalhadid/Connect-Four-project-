
 #include <stdlib.h>
 unsigned int angle;
unsigned int tick;
unsigned char cntr;
unsigned char HL;//High Low
void mymsDelay(unsigned int);



void interrupt(void){

if(INTCON & 0x04){//TMR0 Overflow ISR, every 1ms

   TMR0=248;
   tick++; // will increment every 1ms
   INTCON = INTCON & 0xFB;// Clear T0IF
}

 if(PIR1&0x04){//CCP1 interrupt
   if(HL){ //high
     CCPR1H= angle >>8;
     CCPR1L= angle;
     HL=0;//next time low
     CCP1CON=0x09;//next time Falling edge
     TMR1H=0;
     TMR1L=0;
   }
   else{  //low
     CCPR1H= (40000 - angle) >>8;
     CCPR1L= (40000 - angle);
     CCP1CON=0x08; //next time rising edge
     HL=1; //next time High
     TMR1H=0;
     TMR1L=0;

   }

 PIR1=PIR1&0xFB;
 }
 if(PIR1&0x01){//TMR1 ovwerflow


   PIR1=PIR1&0xFE;
 }

 }
void main ()
{
   unsigned char st1;
   unsigned char st2;
   unsigned char rd;
   unsigned char srd;
TMR0=248;
  TRISD=0x00;
  PORTD=0x00;
  TRISC=0x00;
  PORTC =0x00;
  TRISB = 0xFF ;
  PORTB = 0xFF ;
  while(1)
  {

     if(PORTB = 0xff ){
     PORTD =0x00;
     }
    else if( PORTB == 0x00 )
    {
       rd = (rand () %7)+1 ;

       //srd=200*2 ; ///////////
      PORTD =0x01;
      for( st1=0 ;st1 <rd;st1++)
      {
        for( st2=0 ;st2 <240;st2++)
        {
          PORTD=0x03;
          mymsDelay(1);
          PORTD=0x01;
          mymsDelay(1);

        }
      }


       TMR1H=0;
       TMR1L=0;


       HL=1; //start high
       CCP1CON=0x08;//

      //OPTION_REG = 0x87;//Fosc/4 with 256 prescaler => incremetn every 0.5us*256=128us ==> overflow 8count*128us=1ms to overflow

       T1CON=0x01;//TMR1 On Fosc/4 (inc 0.5uS) with 0 prescaler (TMR1 overflow after 0xFFFF counts ==65535)==> 32.767ms

       INTCON=0x20;//enable TMR0 overflow, TMR1 overflow, External interrupts and peripheral interrupts;
       PIE1=PIE1|0x04;// Enable CCP1 interrupts
       CCPR1H=2000>>8;
       CCPR1L=2000;

       //angle=1100; //600us initially == 1000*0.5=500


       angle=4800;
       mymsDelay(900);
       angle=2400;
       mymsDelay(900);


      PORTD =0x00;

       for( st1=0 ;st1 <rd;st1++)
      {
        for( st2=0 ;st2 <240;st2++)
        {

          PORTD=0x02;
          mymsDelay(1);
          PORTD=0x00;
          mymsDelay(1);

         }
       }
    }
  }

}

void mymsDelay(unsigned int dcntr){
   tick=0;
   while(tick< dcntr);
}
