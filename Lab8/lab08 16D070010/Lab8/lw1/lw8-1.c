#include "at89c5131.h"
#include "stdio.h"
#include "Keypad_Updated.c"
#include "lcd_test.c"
unsigned char in_char, temp_psw, input;
int key_en = 0;

void keypad_interrupt(void) interrupt 7
	
{
	
		lcd_char(read_keypad());
		msdelay(1000);
		lcd_cmd(0x01);
		
		KBF = 0x00;

}

void main()
{
	keypad_init();
	port_init();
	
	P2 = 0x00;											// Make Port 2 output 
	lcd_init();
	
	while(1){
		lcd_cmd(0x80);
	}
	
}
