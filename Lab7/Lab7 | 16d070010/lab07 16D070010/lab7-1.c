/**
 SPI HOMEWORK2 , LABWORK2 (SAME PROGRAM)
 */

/* @section  I N C L U D E S */
#include "at89c5131.h"
#include "stdio.h"
#define LCD_data  P2	    					// LCD Data port
#define sample 1
void SPI_Init();
void LCD_Init();
void Timer_Init();
void LCD_DataWrite(char dat);
void LCD_CmdWrite(char cmd);
void LCD_StringWrite(char * str, unsigned char len);
void LCD_Ready();
void sdelay(int delay);
void delay_ms(int delay);
char int_to_string(int val);
void sample_data(int no_of_samples);
void binary_to_ascii(int binary);
sbit CS_BAR = P1^4;									// Chip Select for the ADC
sbit LCD_rs = P0^0;  								// LCD Register Select
sbit LCD_rw = P0^1;  								// LCD Read/Write
sbit LCD_en = P0^2;  								// LCD Enable
sbit LCD_busy = P2^7;								// LCD Busy Flag
sbit ONULL = P1^0;
bit transmit_completed= 0;							// To check if spi data transmit is complete
bit offset_null = 0;								// Check if offset nulling is enabled
bit roundoff = 0;
unsigned long data1[10]; 
//unsigned long adcVal=0, voltage= 0 , temp_low,temp_high,try0=0;
unsigned long sum = 0,tempadcVal=0;
//unsigned int avgVal=0, initVal=0, adcValue = 0 , temp=0 ;
unsigned long ans=0;
unsigned char serial_data;
unsigned char data_save_high;
unsigned char data_save_low;
unsigned char count=0, i=0;
float fweight=0;
int a=4;
	int p=10;
	char k;
	int j;
	unsigned long q;
int x=0;
/**

 * FUNCTION_INPUTS:  P1.5(MISO) serial input  
 * FUNCTION_OUTPUTS: P1.7(MOSI) serial output
 *                   P1.4(SSbar)
                     P1.6(SCK)
 */
 
void main(void)
{													
                    
	CS_BAR = 1;
	P1 = P1 | 0x20;
	SPI_Init();
	LCD_Init();
	Timer_Init();
	  TR0= 1;
	a=4;
	p=10;
	while(1){
	while(1)
	{
		CS_BAR = 0;                 							// falling edge of CS bar
		SPDAT= 0x00;											// first 4 bits will be address of the channel
		while(!transmit_completed);								// wait for the transmit complete flag	
		data_save_high = serial_data;  							// save the 
		transmit_completed = 0;    								// make the flag 0
		SPDAT =0x00;	
		while(!transmit_completed);	
		data_save_low = serial_data;
		transmit_completed = 0; 
		CS_BAR = 1;    
		tempadcVal = (data_save_high<<2) + (data_save_low>>6);		// save the 10 bits in one variable
		if (p==0) break;
	}
	P2 = 0x00;
p=10;	// Make Port 2 output 
	LCD_Init();
		q=ans*3.290;
	LCD_CmdWrite(0x83);	
		j=q%10;
		q=q-j;
		k=j+'0';
		LCD_DataWrite(k);
		LCD_CmdWrite(0x82);	
		j=q%100;
		j=j/10;
		q=q-j;
		k=j+'0';
		LCD_DataWrite(k);
		LCD_CmdWrite(0x81);	
		j=q%1000;
	j=j/100;
		q=q-j;
		k=j+'0';
		LCD_DataWrite(k);
		LCD_CmdWrite(0x80);	
		j=q%10000;
		j=j/1000;
		q=q-j;
		k=j+'0';
		LCD_DataWrite(k);
		LCD_CmdWrite(0x086);	
		LCD_StringWrite("mV", 2);
		//delay_ms(5000);
	}}

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

void timer0_ISR (void) interrupt 1
{													TR0= 0;
													TMOD=0x01;
                          TH0=0x0EC;
                          TL0=0x078;
													a--;	
                         
													if (a==0) {
														a=4;
														p--;
														data1[p]=tempadcVal;
													}
													
													if (p==0){
														
														a=4;
														
													for (x=0; x<10; x=x+1){
														ans=ans+data1[x];
													}		
														ans=ans/10;}
	//Initialize TH0
	//Initialize TL0
	//Increment Overflow 
	//Write averaging of 10 samples code here
 TR0= 1;
}

/**

 * FUNCTION_INPUTS:  P1.5(MISO) serial input  
 * FUNCTION_OUTPUTS: P1.7(MOSI) serial output
 *                   P1.4(SSbar)
                     P1.6(SCK)
 */ 
void SPI_Init()
{
	CS_BAR = 1;	                  	// DISABLE ADC SLAVE SELECT-CS 
	SPCON |= 0x20;               	 	// P1.1(SSBAR) is available as standard I/O pin 
	SPCON |= 0x01;                	// Fclk Periph/4 AND Fclk Periph=12MHz ,HENCE SCK IE. BAUD RATE=3000KHz 
	SPCON |= 0x10;               	 	// Master mode 
	SPCON &= ~0x08;               	// CPOL=0; transmit mode example|| SCK is 0 at idle state
	SPCON |= 0x04;                	// CPHA=1; transmit mode example 
	IEN1 |= 0x04;                	 	// enable spi interrupt 
	EA=1;                         	// enable interrupts 
	SPCON |= 0x40;                	// run spi;ENABLE SPI INTERFACE SPEN= 1 
//	IPH0 |=0x10;
//	IPL0 |=0x10;
}

void Timer_Init(void)
{
	// Set Timer0 to work in up counting 16 bit mode. Counts upto 
	// 65536 depending upon the calues of TH0 and TL0
	// The timer counts 65536 processor cycles. A processor cycle is 
	// 12 clocks. FOr 24 MHz, it takes 65536/2 uS to overflow
    
	//Initialize TH0
	//Initialize TL0
	//Configure TMOD 
	//Set ET0
	//Set TR0
	
													TMOD=0x01;
                          TH0=0x0EC;
                          TL0=0x078;
													ET0=1;
													EA=1;
	
}
/**
 * FUNCTION_PURPOSE:LCD Initialization
 * FUNCTION_INPUTS: void
 * FUNCTION_OUTPUTS: none
 */
void LCD_Init()
{
  sdelay(100);
  LCD_CmdWrite(0x38);   	// LCD 2lines, 5*7 matrix
  LCD_CmdWrite(0x0C);			// Display ON cursor ON  Blinking off
  LCD_CmdWrite(0x01);			// Clear the LCD
  LCD_CmdWrite(0x80);			// Cursor to First line First Position
}

/**
 * FUNCTION_PURPOSE: Write Command to LCD
 * FUNCTION_INPUTS: cmd- command to be written
 * FUNCTION_OUTPUTS: none
 */
void LCD_CmdWrite(char cmd)
{
	LCD_Ready();
	LCD_data=cmd;     			// Send the command to LCD
	LCD_rs=0;         	 		// Select the Command Register by pulling LCD_rs LOW
  LCD_rw=0;          			// Select the Write Operation  by pulling RW LOW
  LCD_en=1;          			// Send a High-to-Low Pusle at Enable Pin
  sdelay(5);
  LCD_en=0;
	sdelay(5);
}

/**
 * FUNCTION_PURPOSE: Write Command to LCD
 * FUNCTION_INPUTS: dat- data to be written
 * FUNCTION_OUTPUTS: none
 */
void LCD_DataWrite( char dat)
{
	LCD_Ready();
  LCD_data=dat;	   				// Send the data to LCD
  LCD_rs=1;	   						// Select the Data Register by pulling LCD_rs HIGH
  LCD_rw=0;    	     			// Select the Write Operation by pulling RW LOW
  LCD_en=1;	   						// Send a High-to-Low Pusle at Enable Pin
  sdelay(5);
  LCD_en=0;
	sdelay(5);
}
/**
 * FUNCTION_PURPOSE: Write a string on the LCD Screen
 * FUNCTION_INPUTS: 1. str - pointer to the string to be written, 
										2. length - length of the array
 * FUNCTION_OUTPUTS: none
 */
void LCD_StringWrite( char * str, unsigned char length)
{
    while(length>0)
    {
        LCD_DataWrite(*str);
        str++;
        length--;
    }
}

/**
 * FUNCTION_PURPOSE: To check if the LCD is ready to communicate
 * FUNCTION_INPUTS: void
 * FUNCTION_OUTPUTS: none
 */
void LCD_Ready()
{
	LCD_data = 0xFF;
	LCD_rs = 0;
	LCD_rw = 1;
	LCD_en = 0;
	sdelay(5);
	LCD_en = 1;
//	while(LCD_busy == 1)
//	{
//		LCD_en = 0;
//		LCD_en = 1;
//	}
	LCD_en = 0;
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
