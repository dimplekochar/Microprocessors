#include <at89c5131.h>
sbit RS=P0^0;
sbit RW=P0^1;
sbit EN=P0^2;
void lcd_init(void);
void lcd_cmd(unsigned int i);
void lcd_char(unsigned char ch);
void lcd_write_string(unsigned char *s);
void port_init(void);

void msdelay(unsigned int time)
{
	int i,j;
	for(i=0;i<time;i++)
	{
		for(j=0;j<382;j++);
	}
}
void lcd_cmd(unsigned int i)
{
	RS=0;
	RW=0;
	EN=1;
	P2=i;
	msdelay(10);
	EN=0;
}
void lcd_char(unsigned char ch)
{
	RS=1;
	RW=0;
	EN=1;
	P2=ch;
	msdelay(10);
	EN=0;
}
void lcd_write_string(unsigned char *s)
{
	while(*s!='\0')
	{
		lcd_char(*s++);
	}
}
void lcd_init(void)
{
	//port_init();
	lcd_cmd(0x38);
	msdelay(4);
	lcd_cmd(0x06);
	msdelay(4);
	lcd_cmd(0x0C);
	msdelay(4);
	lcd_cmd(0x01);
	msdelay(4);
	lcd_cmd(0x80);
}
void port_init(void)
{
	P2=0x00;
	EN=0;
	RS=0;
	RW=0;
}
	
