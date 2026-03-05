# Lab 02: Data Acquisition, Storage, and Display

**Name:** C2C Jayden Randolph  
**Course / Section:** ECE 383 / T1  
**Instructor:** LtCol James Trimble  
**Date Submitted:** 4 Mar 2026  

## Introduction
In this lab, I created a VGA controller in VHDL on our FPGA boards using counters, triggers, processes, and combinational logic. This report provides an overview of the design, implementation, testing, and results of our project.

## Design/Implementation
### VGA Diagram
![alt text](VGA_Diagram.jpeg)  
Diagram of the VGA screen

### Block Diagram
![alt text](<Lab01 Block Diagram - Randolph-1.jpeg>)  
Block diagram showing all components and (pretty much) every wire in this project

### Verifying Functionality
To verify functionality, I used a variety of resources during this lab. The first resources I used were instructor-given testbenches to verify the functionality of my counter, numeric_stepper, and vga_signal_generator files. If the testbenches passed and the resulting waveform looked correct, then I could be confident that my components worked properly. Additionally, I used https://madlittlemods.github.io/vga-simulator/ to verify my color_mapper was drawing everything correctly. This saved me a lot of time since I only had to simulate my design, not generate a bitstream, to test everything since bitstreams take significantly longer than simulations to generate. Finally, I generated a bitstream to my FPGA board to troubleshoot errors on the display. Through the use of these resources, I was able to verify the functionality of my lab.

### Components

#### lab1
**Purpose:**
Overarching file that contains the numeric steppers and video components. Also codes ch1 and ch2 logic.  
**Inputs:**
clk : in std_logic  
reset_n : in std_logic  
btn: in	std_logic_vector(4 downto 0)  
led: out std_logic_vector(1 downto 0)  
sw: in std_logic_vector(1 downto 0)  
**Outputs:**
tmds : out std_logic_vector(3 downto 0)  
tmdsb : out std_logic_vector(3 downto 0)  
**Behavior:**
Utilizes 2 numeric steppers (with debouncers) to iterate trigger triangle locations. Also instantiates the video component to output to the monitor. Codes the logic to determine when ch1 and ch2 are enabled (along with their respective LEDs).  

**Ch1/Ch2 Logic**
ch1.active <= '1' when (ch1.en = '1' and is_within_grid and (abs(to_integer(pixel.coordinate.row) - to_integer(pixel.coordinate.col)) = 0)) else --whole screen goes yellow if I don't have  is_within_grid '0';  
      
ch2.active <= '1' when (ch2.en = '1' and is_within_grid and (abs(to_integer(pixel.coordinate.row) - (440 - to_integer(pixel.coordinate.col))) = 0)) else '0';  

#### numeric_stepper
**Purpose:**
Holds a value and increments or decrements it based on button presses  
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


#### clock_wiz_0
**Purpose:**
File added to this project for use in video.  
**Inputs:**
See block diagram  
**Outputs:**
See block diagram  
**Behavior:**
This component was not edited by me. Did not touch this file in video.  

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

#### color_mapper
**Purpose:**
Determines the pixel color value based on the row, column, triggers, and channel inputs  
**Inputs:**
position: in coordinate_t  
trigger : in trigger_t  
ch1 : in channel_t  
ch2 : in channel_t    
**Outputs:**
color : out color_t  
**Behavior:**
Utilizes complex grid logic to determine when the VGA needs to activate/color the pixels for the trigger triangles, ch1, ch2, gridlines, and background. Views where the position is as well as the trigger triangle.  


#### vga_signal_generator
**Purpose:**
Generates the hsync, vsync, blank, and row, col for the VGA signal  
**Inputs:**
clk : in std_logic  
reset_n : in std_logic  
**Outputs:**
position: out coordinate_t  
vga : out vga_t  
**Behavior:**
Using 2 counters, implements logic to to code when the hsync, vsync, and blank should change while also determining the row and column for the VGA signal.  

**hsync/vsync/blank Logic**
h_sync_is_low <= (current_pos.col >= 655 and current_pos.col < 751);  
v_sync_is_low <= (current_pos.row >= 489 and current_pos.row < 491);  
h_blank_is_low <= (current_pos.col >= 0 and current_pos.col < 639) or (current_pos.col = 799);  
v_blank_is_low <= (current_pos.row >= 0 and current_pos.row < 479) or (current_pos.row = 524);  

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

## Test/Debug

### hsync Triggered  
![alt text](hsync_image-1.jpeg)  
See columns 656-752  

### vsync Triggered (column + row)
![alt text](vsync_image.png)  
See rows 489-491

### Blank triggered in relation to column count and row count

#### Blank triggered (column)
![alt text](hsync_image-2.jpeg)  
See columns 1-640

#### Blank triggered (row)
![alt text](blank_row.png)  
See row 524

### Column count rolling over causing row count to increment and max counts for both counters
![alt text](rollover.jpeg)  
See rollover occur at 524,799 to 0,0

### Major Problems

#### Ch1 and Ch2 not appearing on screen
Ch1 and Ch2 kept failing to appear on screen for most of the lab. A few issues caused this. First, the given .xdc file did not have the switches enabled. Additionally, I forgot to wire pixel.coordinate in my vga.vhd file causing the position to never register. After fixing these two issues, the lines finally appeared correctly on my display.

#### Triggers not initializing at center axises
The trigger triangles repeatedly failed to generate on the center axis and would generate off screen. Since they generated off screen, the deltas were off causing the triangles to not line up with the hash marks. I solved this by going into my numeric_stepper file and initializing/changing the reset values of process_q to the midpoints on the graph.

#### Bitstream taking forever to generate
In the past, I've used "trial and error" to get my code to work. This is extremely inefficient to do, and I learned throughout this lab that the bitstream takes at least 5 minutes to generate. In the future, I need to use more testbenches to streamline the debugging process and not waste so much time waiting for a bit stream to generate.

## Results

### Gate Check 1
Fully achieved required functionality at 2248 on 26 Jan 2026. Submitted 3 waveforms demonstrating proper implementation of hsync, vsync, and blanks to prove the VGA counters worked properly. Uploaded all code to Github and submitted images to Gradescope.

### Gate Check 2
Fully achieved required functionality at 2303 on 28 Jan 2026. Submitted code to an autograder to confirm hsync, vsync, and blanks worked while also implementing color mapper. Achieved functionality of drawing ch1 but not ch2. Also managed to draw the hash marks and grid but not the trigger triangls. Uploaded all code to Github and submitted images to Gradescope.

### Final Submission
Fully achieved required functionality at ~2200 on 31 Jan 2026. Uploaded bitstream to FPGA and sent video to LtCol Trimble verifying switches worked, buttons worked, and everything displayed properly. Uploaded all code to Github and sent video to LtCol Trimble via Teams.

## Conclusion
I learned a lot more about Vivado and VHDL in this lab. I knocked the dust off my VHDL coding abilities while learning how to implement a VGA controller on my FPGA board. In future years, I would add a third gate check verifying the triggers worked since there was a massive jump between gate check 2 and the final submission. In future labs, I will use components such as my debouncer, counter, and numeric stepper made in this lab.