# Digital Design Porfolio

A compilation of projects I have worked on individually or as part of a team and am allowed to release without the possibility of academic disintegrity at University at Buffalo or Worcester Polytechnic Institute.

## Project Descriptions

**Tensor Coprocessor**

This folder contains a 32-bit IEEE 754 floating point implementation of a TPU with 2x2 and 4x4 for integration with CROC SoC.

While not included, these files were used with the CROC SoC cells into the Cadence design flow for synthesis and layout onto a 2mm padframe with 180nm TSMS cells for tapeout.

The 2x2 and 4x4 folders have the System Verilog implementation of the TPU and the README presents more information on results of synthesis and layout.

**Haptic Reality**

This folder contains research done during undergrad in creating a haptic reality system on an Altera FPGA with a PCB of 256 ultrasonic emitters. 

It is separated into four parts:

the Verilog code for the FPGA including phase alignment and UART receiving,

the ESP32 code for receiving WiFi transmissions from the Quest 2 and sending through UART to the FPGA,

the python code for determining phase offset for point or multi-point convergence,

and the Unity code for visualization and hand tracking.

**32-bit Processor SV**

A combination of 3 different folders, this project contains: 

a 32-bit implementation of a MIPS processor in System Verilog,

a 32-bit implementation of a MIPS processor without write-back or memory in System Verilog, 

and a 32-bit skeleton of the MIPS processor without write-back or memory for class project use, also in System Verilog. 

Additionally, these MIPS processors do not contain the full instruction set, but have the necessary pieces to add instructions.

These processors were coded and tested in edaplayground using Icarus Verilog 12.0

**Tiva DDR Assembly**

This folder contains the assembly implementation of Dance Dance Revolution with 32x32 bit character displays in terminal and high speed refresh rate.

Due to the large output stream for display, this code features many optimizations for extremely fast processing in order to reduce lag to the minimum possible.

Other features of this project include:

Assembly setup of an onboard ADC for input processing of "pad" steps,

Arduino and Processing code for music compatibility with the TIVA processor,

and replacement input keys of WASD instead of button peripherals.

**Limited Autonomous Vehicle**

This folder contains code for a Nucleo L4R5ZI (stm32) board with instructions in assembling and running a small autonomous vehicle with short range infrared object detection. It has a limited range and a grid coordinate system for movement and autonomy. 

Key parts of this project include:

An I2C LCD,

a serial dot display,

two PWM motors,

and a really bad IR sensor.

**Teaching Assistant Work**

This folder contains work I personally created in order to assist in teaching students concepts for the given class.

## Projects with Separate GitHub links

Bluetooth Internal Positioning System Senior Design Project:

https://github.com/CPompey1/Wayfinder

Motion Tracking with Cheap IMUs Using Embedded Deep Learning Proof-of-Concept:

https://github.com/rupin-r/MPU6050_MotionTracking_ProofofConcept

## Additional Work

Additional projects I have completed, but can't add to this repository are:

* VLSI design using Cadence Virtuoso for an automated Cruise Control System

* Pruning and Quantization of a Neural Network

* Neural Architecture Search

* 8 bit single-cycle processor in Verilog programmed to Basys FPGA

* Traffic Light System implemented with hardware and SystemVerilog

* Hamming Code using MIPS assembly

* Atari Breakout using ARM assembly on the TIVA C Series
