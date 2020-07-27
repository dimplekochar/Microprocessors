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
void delay_mms(int delay);
sbit CS_BAR = P3^4;									// Chip Select for the ADC
sbit FS=P3^5;
sbit ONULL = P1^0;
sbit led=P1^4;
bit transmit_completed= 0;							// To check if spi data transmit is complete
bit offset_null = 0;								// Check if offset nulling is enabled
bit roundoff = 0;
unsigned char x, i=0x00, j=0xff, xx;
unsigned long adcVal=0, voltage= 0 , sum = 0,tempadcVal=0 ,temp_low,temp_high,try0=0;
unsigned int avgVal=0, initVal=0, adcValue = 0 , temp=0 ;
int l=0, p;
unsigned char serial_data;
unsigned char data_save_high;
unsigned char data_save_low;
void timer_init();
unsigned char serial_data;
sbit C0 = P1^7;	
char high=239,low=190;
int m=0; 
double z;							
int y=40;
unsigned char count=0, ii=2;
char test [] = {0xEF,0xBE,  0xF1,0x8C,  0xF2,0xFE,  0xF3,0xCE,
								0xF5,0x29,  0xF6,0x3F,  0xF7,0x50,  0xF7,0xDF,
								0xF7,0xDF,  0xF7,0x50,  0xF6,0x3F,  0xF5,0x29,
								0xF3,0xCE,  0xF2,0xFE,  0xF1,0x8C,  0xEF,0xBE 
								
};


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
	timer_init();
	TR0=1;
	TR1=1;
	
	while(1){
		i=0x00;
	while(i<0xff){
		for (z=0; z<3; z++)
		{CS_BAR = 0;                 							// falling edge of CS bar
		FS=0;
			if (m==0){
				xx=i;
			x=(i>>4);
		SPDAT=x;								// first 4 bits will be address of the channel
		while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
			x=(i<<4);
SPDAT=x;	
		while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
		FS=1;	
		CS_BAR = 1; 
		delay_mms(2);}
		else if (m==1){
				xx=0x00;
		SPDAT=0x00;								// first 4 bits will be address of the channel
		while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
SPDAT=0x00;	
		while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
		FS=1;	
		CS_BAR = 1; 
		delay_mms(2);}
		
		}
		i++;
	}

i=0x00;
		
	while(i<0xff){
		for (z=0; z<3; z++)
		{CS_BAR = 0;                 							// falling edge of CS bar
		FS=0;
			if (m==0){
		SPDAT=0x0f;								// first 4 bits will be address of the channel
		while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
SPDAT=0xff;	
		while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
		FS=1;	
		CS_BAR = 1; 
		delay_mms(2);}
		else if (m==1){
		SPDAT=0x00;								// first 4 bits will be address of the channel
		while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
SPDAT=0x00;	
		while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
		FS=1;	
		CS_BAR = 1; 
		delay_mms(2);}
		
		}
		i++;
	}
	
	
i=0xff;
	while(i>0){
		for (z=0; z<10; z++)
		{CS_BAR = 0;                 							// falling edge of CS bar
		FS=0;
			if (m==0){
				xx=i;
			x=(i>>4);
		SPDAT=x;								// first 4 bits will be address of the channel
		while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
			x=(i<<4);
SPDAT=x;	
		while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
		FS=1;	
		CS_BAR = 1; 
		delay_mms(2);}
		else if (m==1){
				xx=0x00;
		SPDAT=0x00;								// first 4 bits will be address of the channel
		while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
SPDAT=0x00;	
		while(!transmit_completed);								// wait for the transmit complete flag		
		transmit_completed = 0; 
		FS=1;	
		CS_BAR = 1; 
		delay_mms(2);}
		
		}
		i--;
	}
		
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

void delay_mms(int delay)
{
	int d=0;
	while(delay>0)
	{
		for(d=0;d<4;d++);
		delay--;
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
//led2=~led2;
	TR1=1;
	m=1-m;
  led=~led;
}

void TIMER0_ISR (void) interrupt 1

{
	TR0=0;
	TL0 =0x61;
	TH0 =0x3C;
	y--;
	if(y==0)
	{
			if(ii==32)
		{
			TR0=0;
			TR1=0;
		}
		else
		{
	//	led1=~led1;
	  high= test[ii];
 		low= test[ii+1];
	ii=ii+2;
		y=40;
	TR1=1;
		}
	}
	
	TR0=1;

	
}

