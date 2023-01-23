#line 1 "C:/Users/omar shawish/Desktop/ProjectConnectFourCode.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/stdlib.h"







 typedef struct divstruct {
 int quot;
 int rem;
 } div_t;

 typedef struct ldivstruct {
 long quot;
 long rem;
 } ldiv_t;

 typedef struct uldivstruct {
 unsigned long quot;
 unsigned long rem;
 } uldiv_t;

int abs(int a);
float atof(char * s);
int atoi(char * s);
long atol(char * s);
div_t div(int number, int denom);
ldiv_t ldiv(long number, long denom);
uldiv_t uldiv(unsigned long number, unsigned long denom);
long labs(long x);
int max(int a, int b);
int min(int a, int b);
void srand(unsigned x);
int rand();
int xtoi(char * s);
#line 3 "C:/Users/omar shawish/Desktop/ProjectConnectFourCode.c"
 unsigned int angle;
unsigned int tick;
unsigned char cntr;
unsigned char HL;
void mymsDelay(unsigned int);



void interrupt(void){

if(INTCON & 0x04){

 TMR0=248;
 tick++;
 INTCON = INTCON & 0xFB;
}

 if(PIR1&0x04){
 if(HL){
 CCPR1H= angle >>8;
 CCPR1L= angle;
 HL=0;
 CCP1CON=0x09;
 TMR1H=0;
 TMR1L=0;
 }
 else{
 CCPR1H= (40000 - angle) >>8;
 CCPR1L= (40000 - angle);
 CCP1CON=0x08;
 HL=1;
 TMR1H=0;
 TMR1L=0;

 }

 PIR1=PIR1&0xFB;
 }
 if(PIR1&0x01){


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


 HL=1;
 CCP1CON=0x08;



 T1CON=0x01;

 INTCON=0x20;
 PIE1=PIE1|0x04;
 CCPR1H=2000>>8;
 CCPR1L=2000;




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
