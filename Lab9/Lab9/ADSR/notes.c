//Generate waveform at P3_6

#include "at89c5131.h"


void timer_init();

sbit C0 = P1^7;	
char high=239,low=190;
									




unsigned char x=1;

unsigned char count=0, i=0;
char test [] = {0xEF,0xBE,  0xF1,0x8C,  0xF2,0xFE,  0xF3,0xCE,
								0xF5,0x29,  0xF6,0x3F,  0xF7,0x50,  0xF7,0xDF,
								0xF7,0xDF,  0xF7,0x50,  0xF6,0x3F,  0xF5,0x29,
								0xF3,0xCE,  0xF2,0xFE,  0xF1,0x8C,  0xEF,0xBE 
								
};

								
									
 
void main(void)
{
	
timer_init();
	while(1)												// endless 
	{
	}
	
}


void timer_init()
{
 TMOD=0x11;		
 TL1 =190;	
 TH1 =239;		
 TL0 =0x61; 		
 TH0 =0x3C;
	EA=1;
	ET0=1;
	ET1=1;
	TR0=1;
	//TR1=1;
	
}	


void TIMER1_ISR (void) interrupt 3
{

	TR1=0;
	TL1 = low ;
	TH1 = high;
    P3_6  = ~ P3_6;
	TR1=1;
  
}

void TIMER0_ISR (void) interrupt 1

{
	TR0=0;
	TL0 =0x61;
	TH0 =0x3C;
	x--;
	if(x==0)
	{
			if(i==32)
		{
			TR0=0;
			TR1=0;
		}
		else
		{
		P3_7 = ~P3_7;
	  high= test[i];
 		low= test[i+1];
	i=i+2;
		x=40;
	TR1=1;
		}
	}
	
	TR0=1;

	
}