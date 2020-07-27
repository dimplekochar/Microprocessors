#include "at89c5131.h"
#include "stdio.h"

void keypad_init(void)
{
      P1=0xF0;
      P1|=0x0F;
      KBE=0xF0;  //MOV 0x9D,#0xF0  ;KBE
      KBLS=0x0F;   //MOV 0x9C,#0x0F  ;KBLS
		  KBF=00; //0x9E,#00    ;KBF
      IEN1=0x01;   //MOV 0xB1,#0x01  ;IE1
		  EA=1;
}	
void delay_in_ms(unsigned int time)
{
	int i,j;
	for(i=0;i<time;i++)
	{
		for(j=0;j<382;j++);
	}
}
unsigned char read_keypad(void)
{
   unsigned char key=0,row=0,col=0,no=0,no_1=0,temp=0;
	 unsigned int i=0;
	 unsigned char final_val=0;
   key=KBF;
	 P1=0xF0;
   temp=((~P1) & 0xF0)>>4; //row
	 i=0;
	 while(i<=3)
	 {
      if(((temp>>i)&0x01)==1)
      {
				row=i;
				break;
			}
      i++;			
   }
   P1=0x0F;
   temp=((~P1) & 0x0F); //col 
   i=0;
	 while(i<=3)
	 {
      if(((temp>>i) & 0x01)==1)
      {
				col=i;			
				break;
			}
      i++;			
   }
	 //col=i;
	 no=(4*row)+col;
	 delay_in_ms(10);
	 P1=0xF0;
   temp=((~P1) & 0xF0)>>4; //row 
	 i=0;
	 while(i<=3)
	 {
      if(((temp>>i) & 0x01)==1)
      {
				row=i;	
			  break;
			}
      i++;			
   }
   P1=0x0F;
	 temp=((~P1)&0x0F);
   i=0;
	 while(i<=3)
	 {
      if(((temp>>i) & 0x01)==1)
      {
				col=i;	
				break;
			}
      i++;			
   }	 
	 //col=i;
   no_1=4*row+col;
   if(no==no_1)
	 {
		  final_val=no;
	 }
	 KBF=0x00;
	 return final_val;
}	