/**
 SPI HOMEWORK2 , LABWORK2 (SAME PROGRAM)
 */

/* @section  I N C L U D E S */
#include "at89c5131.h"
#include "stdio.h"
#define sample 1
void SPI_Init();
void sdelay(int delay);
void delay_ms(int delay);
void Timer_Init();
sbit CS_BAR = P3^4;									// Chip Select for the ADC
sbit FS=P3^5;
sbit ONULL = P1^0;
sbit led=P1^4;
bit transmit_completed= 0;							// To check if spi data transmit is complete
bit offset_null = 0;								// Check if offset nulling is enabled
bit roundoff = 0;
unsigned char xx, x, lupt[]={0x08, 0x00, 0x09, 0x8f, 0x0B, 0x0F, 0x0c, 0x71, 0x0d, 0xa7, 0x0e, 0xa6, 0x0f, 0x63, 0x0f, 0xd8, 0x0f, 0xff, 0x0f, 0xd8, 0x0f, 0x63, 0x0e, 0xa6, 0x0d, 0xa7, 0x0c, 0x71, 0x0B, 0x0F, 0x09, 0x8f, 0x08, 0x00, 0x06, 0x70, 0x04, 0xf0,  0x03, 0x8e, 0x02, 0x58, 0x01, 0x59, 0x00, 0x9c, 0x00, 0x27, 0x00, 0x00, 0x00, 0x27,  0x00, 0x9c, 0x01, 0x59, 0x02, 0x58, 0x03, 0x8e, 0x04, 0xf0, 0x06, 0x70};
//unsigned long adcVal=0, voltage= 0 , sum = 0,tempadcVal=0 ,temp_low,temp_high,try0=0;
//unsigned int avgVal=0, initVal=0, adcValue = 0 , temp=0 ;
int l=0;
unsigned char serial_data;
//unsigned char data_save_high;
//unsigned char data_save_low;
int i=0, j=31, d, k, m=40;
/**

 * FUNCTION_INPUTS:  P1.5(MISO) serial input  
 * FUNCTION_OUTPUTS: P1.7(MOSI) serial output
 *                   P1.4(SSbar)
                     P1.6(SCK)
 */
 
void main(void)
{
	FS=1;
	CS_BAR = 1;
	SPI_Init();
	Timer_Init();
	TR0=1;
	while(1)
	{i=0;
	while(i<64){
		CS_BAR = 0;                 							// falling edge of CS bar
		FS=0;
		//xx=(lupt[i]<<4)+(lupt[i+1]>>4);
		SPDAT= lupt[i];											// first 4 bits will be address of the channel
		while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
		SPDAT= lupt[i+1];											// first 4 bits will be address of the channel
		while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
		FS=1;	
		CS_BAR = 1; 
	}
	i=64;	
	}
}
/**
 * FUNCTION_PURPOSE:interrupt
 * FUNCTION_INPUTS: void
 * FUNCTION_OUTPUTS: transmit_complete is software transfert flag
 */
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





/**
 * FUNCTION_PURPOSE: A delay of 15us for a 24 MHz crystal
 * FUNCTION_INPUTS: void
 * FUNCTION_OUTPUTS: none
 */
void sdelay(int delay)
{
	char d=0;
	while(delay>0)
	{
		for(d=0;d<5;d++);
		delay--;
	}
}

/**
 * FUNCTION_PURPOSE: A delay of around 1000us for a 24MHz crystel
 * FUNCTION_INPUTS: void
 * FUNCTION_OUTPUTS: none
 */
void delay_ms(int delay)
{
	int d=0;
	while(delay>0)
	{
		for(d=0;d<382;d++);
		delay--;
	}
}

void Timer_Init()
{
	TMOD = TMOD | 0x11;
	ET0=1;
//	ET1=1;
	EA=1;
	TH0=0xFE;
TL0=0xFC;
	//TH1=0x3C;
//TL1=0xB0;
}

void timer0_int() interrupt 1{

TR0=0;
TH0=0xFE;
TL0=0xFC;
	led=~led;
i=i+2;
	TR0=1;
	
}


