/* @section  I N C L U D E S */
#include "at89c5131.h"
#include "stdio.h"
#define LCD_data  P2	    					// LCD Data port
#define sample 1
void Timer_Init();
void ISR_Serial();
void init_serial();
unsigned char output;
unsigned char input;
unsigned char temp;
// sfr ACC = 0xE0; 
sbit parity = PSW^0;
sbit LED = P1^4;

void ISR_Serial(void) interrupt 4
{
//ISR for serial interrupt
	
	temp = PSW;
	if(RI==1)
	{
		input = SBUF;
		RI=0;
	}
	if(TI==1)
	{output = 'A';
	ACC = output;
		ACC = ACC +0;
		TB8 = parity;
		SBUF = ACC;
		
		LED = !LED; 
		TI = 0;
	}
	PSW = temp;

}

void Timer_Init()
{
	TMOD = TMOD | 0x20;
	TH1 = 204;	
}

void init_serial()
{
//Initialize serial communication and interrupts
	EA=1;
	ES=1;
	ET1=0;
	SCON = SCON | 0x0c0;
}

void delay_ms(int delay)
{
	int d=0;
	while(delay>0)
	{
		for(d=0;d<382;d++);
		delay--;
	}
}

void main()
{	
	init_serial();
	Timer_Init();
	TR1=1;
	RI=0;
	TI=0;
	LED = 0;

	output = 'A';
	ACC = output;
		ACC = ACC +0;
		TB8 = parity;
		SBUF = ACC;
		while(1){
	}
}

