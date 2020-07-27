//Generate waveform at P3_6

#include "at89c5131.h"
#include "stdio.h"
#define sample 1
void SPI_Init();
void sdelay(int delay);
void delay_ms(int delay);
bit transmit_completed= 0;	
sbit CS_BAR = P3^4;									// Chip Select for the ADC
sbit FS=P3^5;
sbit led1=P1^4;
sbit led2=P1^5;
void timer_init();
unsigned char serial_data;
sbit C0 = P1^7;	
char high=239,low=190;
int m=0;							




int x=40;

unsigned char count=0, i=2;
char test [] = {0xEF,0xBE,  0xF1,0x8C,  0xF2,0xFE,  0xF3,0xCE,
								0xF5,0x29,  0xF6,0x3F,  0xF7,0x50,  0xF7,0xDF,
								0xF7,0xDF,  0xF7,0x50,  0xF6,0x3F,  0xF5,0x29,
								0xF3,0xCE,  0xF2,0xFE,  0xF1,0x8C,  0xEF,0xBE 
								
};

								
									
 
void main(void)
{
	FS=1;
	CS_BAR = 1;
	SPI_Init();
	timer_init();
	TR0=1;
	TR1=1;
	while(1)
	{	while(m==0){
		CS_BAR = 0;                 							// falling edge of CS bar
		FS=0;
		SPDAT= 0x0F;											// first 4 bits will be address of the channel
		while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
		SPDAT= 0xFF;											// first 4 bits will be address of the channel
		while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
		FS=1;	
		CS_BAR = 1; 
	}
	while(m==1){
	CS_BAR = 0;                 							// falling edge of CS bar
		FS=0;
		SPDAT= 0x00;											// first 4 bits will be address of the channel
	while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
		SPDAT= 0x00;											// first 4 bits will be address of the channel
	while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
		FS=1;	
		CS_BAR = 1; 
	
	}
		
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
led2=~led2;
	TR1=1;
	m=1-m;
  
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
		led1=~led1;
	  high= test[i];
 		low= test[i+1];
	i=i+2;
		x=40;
	TR1=1;
		}
	}
	
	TR0=1;

	
}

void SPI_Init()
{
	CS_BAR = 1;	                  	// DISABLE ADC SLAVE SELECT-CS 
	FS=1;
	SPCON |= 0x75;                	// CPHA=1; transmit mode example 
//	SPCON |= 0x01;                	// CPHA=1; transmit mode example 
//	SPCON |= 0x10;                	// CPHA=1; transmit mode example 
//	SPCON &= ~0x08;                	// CPHA=1; transmit mode example 
//	SPCON |= 0x04;                	// CPHA=1; transmit mode example 
	IEN1 |= 0x04;                	 	// enable spi interrupt 
	EA=1;                         	// enable interrupts 
//	SPCON |= 0x40;                	// CPHA=1; transmit mode example 
//	SPCON |= 0x40;                	// run spi;ENABLE SPI INTERFACE SPEN= 1 
//	IPH0 |=0x10;
//	IPL0 |=0x10;
}
void it_SPI(void) interrupt 9 /* interrupt address is 0x004B, (Address -3)/8 = interrupt no.*/
{
	switch	( SPSTA )         /* read and clear spi status register */
	{
		case 0x80:	
			serial_data=SPDAT;   /* read receive data */
			transmit_completed=1;/* set software flag */
 		break;

		case 0x10:
			
		break;
	
		case 0x40:
		break;
	}
}
