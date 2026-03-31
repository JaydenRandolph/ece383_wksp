/*--------------------------------------------------------------------
-- Name:	Jake Miller and Jayden Randolph
-- Date:	Mar 18, 2026
-- File:	lab3.c
-- Event:	Lab 3
-- Crs:		ECE 383
--
-- Purp:	MicroBlaze Tutorial that implements a custom IP with interrupt
--			to MicroBlaze.
--
-- Documentation:	MicroBlaze Tutorial
--
-- Academic Integrity Statement: I certify that, while others may have
-- assisted me in brain storming, debugging and validating this program,
-- the program itself is my own work. I understand that submitting code
-- which is the work of other individuals is a violation of the honor
-- code.  I also understand that if I knowingly give my original work to
-- another individual is also a violation of the honor code.
-------------------------------------------------------------------------*/
/***************************** Include Files ********************************/

#include "xparameters.h"
#include "stdio.h"
#include "xstatus.h"

#include "platform.h"
#include "xil_printf.h"						// Contains xil_printf
#include <xuartlite_l.h>					// Contains XUartLite_RecvByte
#include <xil_io.h>							// Contains Xil_Out8 and its variations
#include <xil_exception.h>

/************************** Constant Definitions ****************************/

/*
 * The following constants define the slave registers
 */
#define baseRegister        0x44a00000



// Write registers
#define exWrAddr            (baseRegister + (4*1))   // slv_reg1[9:0]
#define exLbus              (baseRegister + (4*2))   // slv_reg2[15:0]
#define exRbus              (baseRegister + (4*3))   // slv_reg3[15:0]
#define exWen               (baseRegister + (4*6))   // slv_reg6[0]
#define flagClear           (baseRegister + (4*8))   // slv_reg8[0]

// Read registers
#define L_Bus_Out           (baseRegister + (4*4))   // slv_reg4[15:0]
#define R_Bus_Out           (baseRegister + (4*5))   // slv_reg5[15:0]
#define tr_volt             (baseRegister + (4*9))   // slv_reg9[10:0]
#define tr_time             (baseRegister + (4*10))  // slv_reg10[10:0]
/*
 * The following constants define the Counter commands
 */
#define count_HOLD		0x00		// The control bits are defined in the VHDL
#define	count_COUNT		0x01		// code contained in lec18.vhdl.  They are
#define	count_LOAD		0x02		// added here to centralize the bit values in
#define count_RESET		0x03		// a single place.

#define printf xil_printf			/* A smaller footprint printf */

#define	uartRegAddr			0x40600000		// read <= RX, write => TX

/*
* Creates array to store audio values
*/
int audioLValue[1024];
int audioRValue[1024];

/************************** Function Prototypes ****************************/
void myISR(void);
void isrIncrementer(void);

/************************** Variable Definitions **************************/
/*
 * The following are declared globally so they are zeroed and so they are
 * easily accessible from a debugger
 */
u16 isrCount = 0;
char isFull = 'f';

// example of write Xil_Out8(countCtrlReg,count_RESET);
/* example of loading from user input and giving command to component through register and control bits:
 * printf("Enter a 0-9 value to store in the counter: ");
            	c=XUartLite_RecvByte(uartRegAddr) - 0x30;
        		Xil_Out8(countQReg,c);						// put value into slv_reg1
        		Xil_Out8(countCtrlReg,count_LOAD);			// load command
    			printf("%c\r\n",c+0x30);
 */

int main(void) {

	unsigned char c;

	init_platform();

	print("Welcome to Lab 3\n\r");

    microblaze_register_handler((XInterruptHandler) myISR, (void *) 0);
    microblaze_enable_interrupts();
	microblaze_disable_interrupts();

	//enable interrupt, wait for isrCount to increase, disable interrupt

    while(1) {

    	c=XUartLite_RecvByte(uartRegAddr);

		switch(c) {
    		/*-------------------------------------------------
    		 * Reply with the help menu
    		 *-------------------------------------------------
			 */
    		case '?':
    			printf("--------------------------\r\n");
    			printf("isr count = %x\r\n",isrCount);
    			printf("--------------------------\r\n");
    			printf("?: help menu\r\n");
				printf("v: read trigger volt\r\n");
				printf("t: read trigger time\r\n");
    			printf("o: k\r\n");
    			printf("f: flush terminal\r\n");
				printf("a: read audio samples\r\n");
				printf("h: horizontal line\r\n");
    			break;

			/*-------------------------------------------------
    		 * allow user to print horizontal line to screen
    		 *-------------------------------------------------
			 */
			case 'h':
				for (int i=0;i<1024;i++) {
					Xil_Out16(exWrAddr,i); // set BRAM address
					Xil_Out16(exLbus, (uint16_t)((185 + 36) << 7)); // write to row 185
					Xil_Out8(exWen, 1); // write data to address in BRAM
					Xil_Out8(exWen, 0); // turn off write
            }
				break;


			/*-------------------------------------------------
    		 * allow user to print volt trigger
    		 *-------------------------------------------------
			 */
			case 'v':
				printf("volt trigger = %d\r\n",Xil_In16(tr_volt));
				break;

			/*-------------------------------------------------
    		 * allow user to print time trigger
    		 *-------------------------------------------------
			 */
			case 't':
				printf("time trigger = %d\r\n",Xil_In16(tr_time));
				break;

			/*-------------------------------------------------
			 * When prompted from the user, stores the audio
             * samples in an array and prints the array. Samples
             * stored  in LBusOut and RBusOut registers
			 *-------------------------------------------------
			 */
            case 'a':
				int trigLLocation;
				int trigRLocation;
				int sizeL;
				int sizeR;
				int tempAudioL[1024];
				int tempAudioR[1024];
				int LCounter;
				int RCounter;
				isrIncrementer();

				//checks for trigger. resets array to start there
				for(int i = 0; i < 1024; i++) {
					if(audioLValue[i] == tr_volt) {
						trigLLocation = i;
						sizeL = 1024 - i;
					}
					if(audioRValue[i] == tr_time) {
						trigRLocation = i;
						sizeR = 1024 - i;
					}
				}
				LCounter = 0;
				for(int i = trigLLocation; i < sizeL; i++) {
					tempAudioL[j] = audioLValue[i];
					LCounter++;
				}
				RCounter = 0;
				for(int i = trigRLocation; i < sizeR; i++) {
					tempAudioR[j] = audioRValue[i];
					RCounter++;
				}
				for(int i = 0; i < trigLLocation; i++) {
					tempAudioL[LCounter] = audioLValue[i];
					LCounter++;
				}
				for(int i = 0; i < trigRLocation; i++) {
					tempAudioR[RCounter] = audioRValue[i];
					RCounter++;
				}

				for (int i=0;i<1024;i++) {
					Xil_Out16(exWrAddr,i); // set BRAM address
					Xil_Out16(exLbus, (uint16_t)((tempAudioL[i] + 36) << 7)); // write to row 185
					Xil_Out16(exRbus, (uint16_t)((tempAudioR[i] + 36) << 7)); // write to row 185
					Xil_Out8(exWen, 1); // write data to address in BRAM
					Xil_Out8(exWen, 0); // turn off write

					//prints audiovalue arrays
					printf("%d, ", tempAudioL[i]);
					printf("%d\n", tempAudioR[i]);
            	}
                break;

			/*-------------------------------------------------
			 * Basic I/O loopback
			 *-------------------------------------------------
			 */
    		case 'o':
    			printf("k \r\n");
    			break;

			/*-------------------------------------------------
			 * Clear the ISR counter
			 *-------------------------------------------------
			 */
			case 'i':
				isrCount = 0;				// clear ISR Count
				isFull = 'f';
				break;

			/*-------------------------------------------------
			 * Clear the terminal window
			 *-------------------------------------------------
			 */
            case 'f':
            	for (c=0; c<40; c++) printf("\r\n");
               	break;

			/*-------------------------------------------------
			 * Unknown character was
			 *-------------------------------------------------
			 */
    		default:
    			printf("unrecognized character: %c\r\n",c);
    			break;
    	} // end case

    } // end while 1

    cleanup_platform();

    return 0;
} // end main


void myISR(void) {
	isrCount = isrCount + 1;
}




void isrIncrementer(void) {
int isrTemp = isrCount;
for(int i = 0; i < 1024; i++) {
		audioLValue[i] = L_Bus_Out;
		audioRValue[i] = R_Bus_Out;
		flagClear = 1;
		while(isrTemp == isrCount & isFull != 't') {
			microblaze_enable_interrupts();
		}
		microblaze_disable_interrupts();
	}
	isFull = 't'
}
