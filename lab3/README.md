# Lab 03: Software Control of a Datapath

**Name:** C1C Jake Miller and C2C Jayden Randolph  
**Course / Section:** ECE 383 / T1  
**Instructor:** LtCol James Trimble  
**Date Submitted:** 3 Apr 2026  

## Introduction
In this lab, we integrated the basic 2-channel oscilloscope with a microblaze controller and the ability to toggle between the FSM and microblaze to control the 2-channel oscilloscope while adding trigger time control. This report provides an overview of the design, functionality, and conclusion of the lab.

## Design/Implementation

### Block Diagram
![alt text](AXI_Map-Miller_Randolph.jpeg)
Block diagrams showing all components and (pretty much) every wire in this project

### Map of 32 AXI Registers to Lab 2 Signals
![alt text](Lab3_Block_Diagram_1-Miller_Randolph.jpeg)
![alt text](Lab3_Block_Diagram_2-Miller_Randolph.png)
![alt text](Lab3_Block_Diagram_3-Miller_Randolph.png) 
Map of the registers used with the Lab 2 signals

### Verifying Functionality
To verify functionality, we primarily used the FPGA board. Through each gate check, we generated a bitstream and uploaded the bitstream to the FPGA board. For the first two gatechecks, we just confirmed Lab 2 functionality on the FPGA board. For gatecheck 3 and final testing, we converted the bitstream into Vitis hardware and used C code to program the FPGA board. If the bitstream or C code failed to compile, we would check the line/location of the error and debug from there. Once everything compiled but we had logic errors, we used an abundance of print statements to determine the sources of our errors. Through all of these resources, we were able to achieve full functionality in this lab.

## Results

### Gate Check 1
Fully achieved required functionality at 1620 on 12 Mar 2026. Submitted diagrams via gradescope and achieved the required "baby step" from the "Implementation and Testing" section. Uploaded all code to Jake's Github.

### Gate Check 2
Fully achieved required functionality at 1620 on 12 Mar 2026. Submitted via instructor demo. Generated a bitstream, and Lab 2 functionality still works on our new bitstream. Uploaded all code to Jake's Github.

### Gate Check 3
Fully achieved required functionality at 1419 on 9 Mar 2026. Submitted via instructor demo. First part of instructions ("baby step") completed. Uploaded all code to Jake's Github.

### Required Functionality
Fully achieved required lab functionality at 1500 on 2 Apr 2026. Submitted via instructor demo. Moved audio samples into buffers, triggered properly, provided user menu, and the system operates in continuous mode. Uploaded all code to Jake's Github.

### A Functionality
Fully achieved required A functionality at 1500 on 2 Apr 2026. Submitted via instructor demo. Properly used triggering and ISR to transfer samples to the BRAM with the trigger_time logic. Controlled Ch1_enb and Ch2_enb via the FPGA switches. Uploaded all code to Jake's Github.

## Conclusion
We learned a lot more about Vitis, VHDL, and C in this lab. We got even better learning Vivado's capabilities and how to use C code in Vitis. We learned the importance of utilizing print statements to determine where logic errors lied and verify correct C code execution. In future labs, we would like the pseudocode explained a little more in-depth - especially after the third gate check. We're not sure if we'll use Vitis again in the next lab, but understanding how to sync the microblaze to the FPGA board was extremely helpful for the final project where we will likely use C code.