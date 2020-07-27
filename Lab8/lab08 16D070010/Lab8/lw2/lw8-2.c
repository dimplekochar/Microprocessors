#include "at89c5131.h"
#include "stdio.h"
#include "Keypad_Updated.c"
#include "lcd_test.c"
unsigned char in_char, temp_psw, input;
int key_en = 0;

void init_serial()
{
	EA = 1;
	ES = 1;
	ET1 = 0;
	SCON = 0xc0;
}

void Timer_Init()
{
	TMOD = TMOD | 0x20;
	TH1 = 204;
}

void ISR_Keyboard(void) interrupt 7
{
	temp_psw = PSW;
	in_char = read_keypad();
	lcd_char(in_char);
	
	ACC = in_char;
	ACC = ACC + 0;
	TB8 = PSW^0;
	SBUF = in_char;
	PSW = temp_psw;
}

void ISR_Serial(void) interrupt 4
{
//ISR for serial interrupt
	temp_psw = PSW;
	
	if(RI==1)
	{
		input = SBUF;
		if(input=='Y')
		{
			key_en = 1;	
		}
		
		if(input=='N')
		{
			key_en = 0;
		}
		
		RI=0;
	}
	
	if(TI==1)
	{
//		LED = !LED;
		TI = 0;
//		out_char = read_keypad();
//		ACC = out_char;
//		ACC = ACC +0;
//		TB8 = PSW^0;
//		SBUF = ACC;
	}
	PSW = temp_psw;
}

void main()
{
	init_serial();
	Timer_init();
	keypad_init();
	port_init;
	lcd_init;
	TR1=1;
	REN = 1;
	RI=0;
	TI=0;
	while(1)
	{
		if(key_en==1)
		{
			IEN1 = 0x01;
		}
		
		if(key_en==0)
		{
			IEN1 = 0x00;
		}
		
	}
}


