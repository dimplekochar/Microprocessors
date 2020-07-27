/**
 SPI HOMEWORK2 , LABWORK2 (SAME PROGRAM)
 */

/* @section  I N C L U D E S */
#include "at89c5131.h"
#include "stdio.h"
#define sample 1
void SPI_Init();
void Timer_Init();
void delay_ms(int delay);
sbit CS_BAR = P3^4;									// Chip Select for the ADC
sbit FS=P3^5;
bit transmit_completed= 0;							// To check if spi data transmit is complete
sbit led2=P1^5;
sbit led1=P1^4;
//unsigned long adcVal=0, voltage= 0 , sum = 0,tempadcVal=0 ,temp_low,temp_high,try0=0;
//unsigned char avgVal=0, initVal=0, adcValue = 0 , temp=0;
//unsigned short x=0;
unsigned char x, lupt[]={0x0, 0x00, 0x01, 0x04,  0x02, 0x08,  0x03, 0x0c, 
0x04, 0x10, 0x05, 0x14, 0x06, 0x18, 0x07, 0x1c, 0x08,
	0x20, 0x09, 0x25, 0x0a, 0x29,  0x0b, 0x2d, 0x0c, 0x31,  0x0d, 0x35,  0x0e, 0x39,  0x0f, 0x3d};

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
	{
		FS=0;
		CS_BAR = 0;                 							// falling edge of CS bar
		while (i<31){
			FS=0;
		CS_BAR = 0; 
SPDAT=lupt[i];										// first 4 bits will be address of the channel
	//		ACC=SPDAT;
	while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
			k=i+1;
			SPDAT=lupt[k];
//			ACC=SPDAT;
	while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
		FS=1;	
		CS_BAR = 1; 
			led2=~led2;
		//	for (d=0; d<6; d++);
		//	i=i+2;
			
		}
		i=0;
		j=31;
		while (j>0){
			FS=0;
		CS_BAR = 0; 
			k=j-1;
			SPDAT=lupt[k];										// first 4 bits will be address of the channel
//			ACC=SPDAT;
	while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
	SPDAT=lupt[j];									// first 4 bits will be address of the channel
	//		ACC=SPDAT;
	while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
		FS=1;	
		CS_BAR = 1; 
			led1=~led1;
	//		for (d=0; d<6; d++);
	//		j=j-2;
		}
		i=0;
		j=31;
		
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
	IEN1 |= 0x04;                	 	// enable spi interrupt 
	EA=1;                         	// enable interrupts 
//	SPCON |= 0x40;                	// run spi;ENABLE SPI INTERFACE SPEN= 1 
//	IPH0 |=0x10;
//	IPL0 |=0x10;
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

void Timer_Init()
{
	TMOD = TMOD | 0x01;

	EA=1;
		ET0=1;
	TH0=0x00;
TL0=0xF7;
}

void timer0_int() interrupt 1{
	TR0=0;
	if (m==0){
i=i+2;
j=j-2;
m=40;	}
	m--;
TH0=0x00;
TL0=0xF7;
	TR0=1;
	
	
}
