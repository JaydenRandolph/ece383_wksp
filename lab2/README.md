# Lab 02: Data Acquisition, Storage, and Display

**Name:** C2C Jayden Randolph  
**Course / Section:** ECE 383 / T1  
**Instructor:** LtCol James Trimble  
**Date Submitted:** 5 Mar 2026  

## Introduction
In this lab, I integrated the video display controller developed in Lab 1 with the audio codec on the Nexys Video board to build a basic 2-channel oscilloscope. This report provides an overview of the design, implementation, testing, and results of my project.

## Design/Implementation

### Block Diagram
![alt text](<Lab 2 Updated Block Diagram 1 - Randolph-1.png>)
![alt text](<Lab 2 Updated Block Diagram 2 - Randolph-1.png>)
Block diagrams showing all components and (pretty much) every wire in this project

### State Transition Diagram
![alt text](<Lab 2 FSM - Randolph-1.png>)
State transition for Lab2_cu (the FSM)

### Verifying Functionality
To verify functionality, I primarily used the FPGA board. Through each gate check, I generated a bitstream and uploaded the bitstream to the FPGA board. Once on the board, I attempted to complete the each gate check's/the final functionality's requirements. If the bitstream failed to generate, the I would first check the component that caused the bitstream to fail. If I still could not get the bitstream to generate, I utilized Vivado's Integrated Logic Analyzer to determine which signal in my code was not processing correctly. Through all of these resources, I was able to achieve full functionality in this lab.

### Components

#### lab2
**Purpose:**
Overarching file that contains the all components.
**Inputs:**
clk : in std_logic
reset_n : in std_logic
ac_adc_sdata : in std_logic
scl : inout std_logic
sda : inout std_logic
switch: in std_logic_vector(7 downto 0)
btn: in	std_logic_vector(4 downto 0) 
**Outputs:**
ac_mclk : out std_logic
ac_dac_sdata : out std_logic
ac_bclk : out std_logic
ac_lrclk : out std_logic 
ac_dac_sdata : out std_logic
ac_bclk : out std_logic
ac_lrclk : out std_logic
tmds : out std_logic_vector(3 downto 0)
tmdsb : out std_logic_vector(3 downto 0)
oled_sdin : out std_logic
oled_sclk : out std_logic
oled_dc : out std_logic
oled_res : out std_logic
oled_vbat : out std_logic
oled_vdd : out std_logic 
**Behavior:**
Utilizes datapath component and control component (fsm) to set up the oscilloscope via the FPGA.

#### lab2_dp
**Purpose:**
Contains all of Lab2's BBB and component files.
**Inputs:**
clk : in std_logic
reset_n : in std_logic
ac_adc_sdata : in std_logic
scl : inout std_logic
sda : inout std_logic   
cw: in std_logic_vector(2 downto 0)
btn: in std_logic_vector(4 downto 0)
switch: in std_logic_vector(3 downto 0)
exWrAddr: in std_logic_vector(9 downto 0)
exWen: in std_logic
exSel: in std_logic
exLbus : in std_logic_vector(15 downto 0)
exRbus : in std_logic_vector(15 downto 0)
flagClear: in std_logic
**Outputs:**
ac_mclk : out std_logic
ac_dac_sdata : out std_logic
ac_bclk : out std_logic
ac_lrclk : out std_logic
tmds : out std_logic_vector(3 downto 0)
tmdsb : out std_logic_vector(3 downto 0)
sw: out std_logic_vector(2 downto 0)
Lbus_out : out std_logic_vector(15 downto 0)
Rbus_out : out std_logic_vector(15 downto 0)
flagQ : out std_logic
**Behavior:**
Provides intermediate logic and connects all BBB components. See block diagram for more information.

#### lab2_cu
**Purpose:**
Finite State Machine for Lab 2. Works in tandem with the datapath component.
**Inputs:**
clk : in std_logic
reset_n : in std_logic
sw : in std_logic_vector(2 downto 0)
**Outputs:**
cw : out std_logic_vector(2 downto 0)
**Behavior:**
Utilizes control words and status words to control the datapath BBBs. See state diagram for more detailed information.

#### BRAM_SDP
**Purpose:**
FPGA memory built into the FPGA
**Inputs:**
See block diagram  
**Outputs:**
See block diagram  
**Behavior:**
This component was not edited by me. Did not touch this file in the datapath file. 

#### video
**Purpose:**
Structural component to connect clock_wiz, VGA, and DVID  
**Inputs:**
clk : in std_logic  
reset_n : in std_logic  
trigger : in trigger_t  
ch1: in channel_t  
ch2: in channel_t  
**Outputs:**
tmds : out std_logic_vector(3 downto 0)  
tmdsb : out std_logic_vector(3 downto 0)  
position : out coordinate_t  
**Behavior:**
This component was not edited by me. Essentially instantiates vga and DVID components to allow output to the monitor.

#### DVID
**Purpose:**
Converts VGA signals into DVID bitstreams.  
**Inputs:**
clk : in std_logic  
clk_n : in std_logic    
clk_pixel : in std_logic  
red_p : in std_logic_vector(7 downto 0)  
green_p : in std_logic_vector(7 downto 0)  
blue_p : in std_logic_vector(7 downto 0)  
blank : in std_logic  
hsync : in std_logic  
vsync : in std_logic    
**Outputs:**
red_s : out std_logic  
green_s : out std_logic  
blue_s : out std_logic   
clock_s : out std_logic    
**Behavior:**
This component was not edited by me. Just converts the vga signals into DVID bitstreams so we can use the HDMI cable for our monitors.  

#### vga
**Purpose:**
Generates VGA signal with graphics  
**Inputs:**
clk: in STD_LOGIC  
reset_n : in STD_LOGIC  
trigger : in trigger_t  
ch1 : in channel_t  
ch2 : in channel_t   
**Outputs:**
vga : out vga_t  
pixel : out pixel_t  
**Behavior:**
Instantiates and connects vga_signal_generator and color_mapper. Also relays position information for higher-level components such as lab1. 

#### audio_codec_wrapper
**Purpose:**
File added to this project to monitor and relay incoming sound samples' data.
**Inputs:**
See block diagram  
**Outputs:**
See block diagram  
**Behavior:**
This component was not edited by me. Did not touch this file in the datapath file. 

#### clock_wiz_1
**Purpose:**
File added to this project for use in audio_codec_wrapper.  
**Inputs:**
See block diagram  
**Outputs:**
See block diagram  
**Behavior:**
This component was not edited by me. Did not touch this file in audio_codec_wrapper. 

#### trigger_detector
**Purpose:**
Utilizes the trigger to intercept the oscilloscope's waveform on the trigger.
**Inputs:**
clk : in std_logic
reset_n : in std_logic
threshold : in unsigned
ready : in std_logic
monitored_signal : in  unsigned
**Outputs:**
crossed_trigger : out std_logic
**Behavior:**
Monitors incoming oscilloscope data to intersect the oscilloscope with the left side of the screen (on the trigger).

#### counter
**Purpose:**
Synchronous counter based on a clock.  
**Inputs:**
clk : in std_logic  
reset_n : in std_logic  
ctrl : in std_logic  
**Outputs:**
roll : out std_logic  
Q : out unsigned (num_bits-1 downto 0)  
**Behavior:**
Counts on the rising edge of a clock until a max value is met. Then, the counter is reset and the rollover bit is triggered. Synchronously resets. 

#### numeric_stepper
**Purpose:**
Holds a value and increments or decrements it based on button presses. 
**Inputs:**
clk : in std_logic  
reset_n : in std_logic  
en : in std_logic  
up : in std_logic  
down : in std_logic  
**Outputs:**
q : out signed(num_bits-1 downto 0)  
**Behavior:**
Utilizes 2 debouncers to move the trigger triangle's location on the x and y axis. Implements logic to prevent the trigger triangle from going out of bounds and only change on the rising edge of the clock. 

#### debouncer
**Purpose:**
Allow every button input to register once, not hundreds of times per press.  
**Inputs:**
clk : in std_logic  
reset_n : in std_logic  
btn_in : in std_logic  
**Outputs:**
btn_out : out std_logic  
**Behavior:**
Delays the button inputs by 20ms. Since clock operates at 100MHz, set delay counter to 2,000,000 and increment by 1 every clock cycle. This value will reach 2,000,000 at ~20ms, and then if a button input change is detected after then, then the debouncer allows that to happen. 

#### flag_register
**Purpose:**
Logic to be used in Lab 3 for flag
**Inputs:**
clk : in std_logic
set : in std_logic
clear : in std_logic
**Outputs:**
Q : out std_logic
**Behavior:**
Transfers information in a "2-line handshake" between components and processors. Sends data, waits for processors to pick up data, then sends more data to the processor.

#### Lab2_OLED
**Purpose:**
Displays a tiny screen on the FPGA to help debug. I did not make this file.
**Inputs:**
clk : in std_logic
reset_n : in std_logic;        
switch : in std_logic_vector(7 downto 0)
**Outputs:**
oled_sdin : out std_logic
oled_sclk : out std_logic
oled_dc : out std_logic
oled_res : out std_logic
oled_vbat : out std_logic
oled_vdd : out std_logic  
**Behavior:**
I did not make this file. I inverted one of the switches in this file to properly show the live/sim.


## Test/Debug
As discussed earlier, I debugged using the FPGA board and the Vivado's Integrated Logic Analyzer. The FGPA verified functionality whereas Vivado's ILA verified my FSM.

### Major Problems

#### Trigger memory problems
Since I applied an offset of 25 to my trigger to sync up the triangle and the waveform, the waveform would write again on the left side of the screen (ie continue writing from the waveform on the right side of the graph). Since about 5 pixels were redrawing on the left side of the screen, I changed my offset from 20 to 25. This made the "extra pixels" "draw" on the left side of the screen where my vga was not drawing. This fixed the problem.

#### OLED inverted controls
During testing, I realized my OLED controls were inverted. When the FPGA was live, the OLED was on SIM. To fix this, I edited the OLED file to invert switch's third bit to help with debugging.

#### Incorrect FSM
Around gate check 3, my finite state machine appeared right, but was not working. This is because my FSM was waiting for trigger inputs, but I had not yet implemented my trigger. To solve this problem, I utilizied Vivado's ILA to run my code on a virtual FPGA board and analyze where my FSM went wrong. After doing this a few times, I found the trigger problem and updated my FSM to ignore this input for gate check 3.


## Results

### Gate Check 1
Fully achieved required functionality at 1355 on 12 Feb 2026. Submitted via instructor demo. Both waveforms show up. Uploaded all code to Github.

### Gate Check 2
Fully achieved required functionality at 2359 on 16 Feb 2026. Submitted via instructor demo. Scrolling achieved. Achieved functionality of drawing ch1 but not ch2. Also managed to draw the hash marks and grid but not the trigger triangls. Uploaded all code to Github.

### Gate Check 3
Fully achieved required functionality at 1001 on 19 Feb 2026. Submitted via instructor demo. Live audio input achieved. Uploaded all code to Github.

### Final Submission
Achieved full functionality on 05 March 2026. Submitted via video demo in gradescope. Fully triggered live and simulated audio works, trigger's work, flag register component added, and debouncers implemented. Uploaded all code to Github.

## Conclusion
I learned a lot more about Vivado and VHDL in this lab. I got even better at VHDL coding while learning how memory is used with FPGAs. In future labs, I would have the FSM be a homework so we could receive feedback on it prior to starting the lab. I will use these components such as my debouncer, counter, and numeric stepper in future labs.