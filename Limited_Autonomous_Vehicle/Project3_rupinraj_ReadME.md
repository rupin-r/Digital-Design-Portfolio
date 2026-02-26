# Project3 AutonomousVehicle
-------------------
About
-------------------

Contributors: Rupin Raj Kumar Pradeep

Project Description: C++ projects that implement several inputs and outputs to create an autonomous vehicle

--------------------
Features
--------------------

Includes several different files that show working progress towards the final solution incorporating a matrix keypad, an LCD display, a matrix dot display, IR sensors,
and motors.

The main code solution will allow a user to enter two values into the matrix keypad signifying the end x and y coordinate to travel to from a starting 0,0 position.
The vehicle will then disregard further user input and attempt to drive to the location without bumping into obstacles around it. It should also perform pathfinding with obstacles found in the way stored as nodes.

--------------------
Required Materials
--------------------

-1 Nucleo L4R5ZI

-1 Breadboard

-1 Matrix Keypad

-1 LCD Display model 1602

-1 Matrix Dot Display (not necessary)

-1 IR sensor

-3 servo motors with screws

-6 smaller screws for holding servos in place

-1 cross piece for servo

-2 wheels for servo

-14 male to male wires

-7 female to male wires

-1 roll of strong tape

-A small cardboard box or spare cardboard as a base of the vehicle

--------------------
Resources and References
--------------------

Code formatting and header courtesy of Dr. Farshad Ghanei

Nucleo pinout from the datasheet at https://www.st.com/resource/en/reference_manual/dm00310109-stm32l4-series-advanced-armbased-32bit-mcus-stmicroelectronics.pdf

LCD API provided by Dr. Winikus seen as files [lcd1602.cpp](https://github.com/rupin-r/CSE321-Project2-Lock-Unlock/blob/main/lcd1602.cpp) and [lcd1602.h](https://github.com/rupin-r/CSE321-Project2-Lock-Unlock/blob/main/lcd1602.h)

LCD instructions also provided by Dr. Winikus in file ["The CSE321 LCD Library Files"](https://github.com/rupin-r/CSE321-Project2-Lock-Unlock/blob/main/The%20CSE321%20LCD%20Library%20Files.pdf)

Matrix dot display API found here: [https://github.com/niklauslee/max7219](https://github.com/niklauslee/max7219). This code was edited to be supported in mbed
and with the L4R5ZI

--------------------
Getting Started
--------------------

***Matrix Keypad***

Connect the ground rail to GND of the nucleo L4R5ZI. Connect pins E3 through E6 to the first four pins of the matrix keypad. Then, connect
pins D4 through D7 to the 4 different rails of the breadboard. Connect the last 4 pins of the matrix keypad in the same 4 rails, the first pin
corresponding to D4 and so on. With these two pins, connect the positive end of the LED in the same rails and the negative end to ground.
Run the program to see the column of the button you pressed light up as well as the value printed to the screen.

***LCD***

Connect the VCC pin of the LCD to the 5V pin on the nucleo L4R5ZI. Connect the GND pin on the LCD to GND. Connect the SDA pin on the LCD to PB_9
and the SCL to PB_8. Run the program. Adjust the contrast potentiometer on the LCD until the phrase "Hello World" shows up on the screen.

***IR Sensor***

Connect the IR sensors pin VCC to 5V on the nucleo L4R5ZI and the ground pin to GND. Connect the Out pin of the IR sensor to PD_0. Connect PD_1 of the nucleo to the positive edge of a breadboarded LED. The negative edge should go to the second GND on the nucleo. Run the program and the breadboarded LED will light up if the IR
sensor detects an obstacle. Adjust the IR sensor distance with the potentiometer on top of the sensor.

***Matrix Dot Display***

Connect the VCC pin of the max 7219 to the 3V3 pin of the nucleo L4R5ZI and the GND pin to ground. Then, connect the cs pin of the max 7219 to PC_10, connect the clk pin to PC_9, and the din pin to PC_8. Run the program and something like a Pacman red ghost should appear on the matrix dot display. If the display doesn't appear, try changing the VCC to 5V instead of 3V3.

***Building the Chassis***

The base of the chassis will be the cardboard material. The requirements of the cardboard structure must be that it can hold the nucleo, the breadboard, and all three servos. Two of the servos will go out the sides, so the minimum height of the chassis is the sum of the breadboard, the nucleo, the width of a motor, and the height of a motor. The minimum length should be the maximum distance of either the nucleo or the breadboard and the minimum width should be the sum of the width of the nucleo and the height of two motors. Using these general dimensions, a box should be constructed from the cardboard and it will be able to hold all the parts. For easy building, buying the motors and wheels from parallax provided a box that was the perfect size for construction.

Cut out a rectangle the exact size of the base of each motor on either side (the longer length side) of the cardboard box. These cutouts should be the exact same height and length away from each other or the vehicle won't drive straight. The exact location of these rectangles should be very close to the bottom, or at the bottom of the box and a little more than half of the length. At half length, the vehicle will tip while driving, so don't cut at exactly halfway. While not at halfway, the weight imbalance after placing all the componenets will keep the vehicle from tipping. Cut three sides of the top off so it forms a flap. Put the motors into the rectangle cutouts on the side such that the wires face the same direction going towards the back end of the box. This means to go straight, one motor will be going clockwise and the other going counterclockwise. Make sure your motors move very little after being placed inside these cutouts. If they move a lot, figure out how to make them stabilized. Then add wheels to these two motors.

Cut out a small, thin section, the size of the matrix keypad bus, on to the back top of the chassis. The matrix keypad bus will go through this section. The size doesn't matter as long as the wires will stay inside the vehicle. Cut out another rectangle shape, the same size as the two previous motors ones, but on the top of the chassis. Place the third motor into this slot with the wires going back again. Attach the cross shape piece to his motor and have one pin of the IR sensor go through one of the holes of this cross piece. Connect wires to the IR sensor and then heavily tape it down to the cross piece. It should be angled down slightly so it can see ahead of the vehicle, but not too far down so it only sees the vehicle. Cut one last piece from the top the size of just the bottom of the LCD display. The bottom will go through the top of the chassis while the rest will fall under so it can connect to the wires.

Finally, connect VCC to one red line of the breadboard, GND to the black line, 3V3 to the other red line, and the other GND to the other black line. Connect both the motors to the red line with VCC and the corresponding black line. Then have the left side motor input connection go to PB_6 while the right side goes to PA_3. Connect the four inputs of the matrix keypad to PE_3 through PE_6 in that order. Then connect the outputs to PD_4 through PD_7. Connect the LCD VCC to the 3V3 red line and the GND to the corresponding black line. Then connect SDA to PB_9 and SCL to PB_8. Lastly, connect the IR sensor VCC and GND to the 3V3 red line and its corresponding ground and connect the output signal to PD_0.

In order to seal everything in place the breadboard and nucleo inside the box, close the top flap, and tape it down once all the wire connections are made. If there are flaps in the front, tape those shut as well. Tape the matrix keypad down to the top of the chassis. Secure the LCD display on to the top. Use any other materials necessary to make sure all the motors are secured in place.

***Motors***

After building the chassis (directions above), run the program TestingMotors and your vehicle should move forward, turn right, then move backward and stop. If the left turn is not a 90 degree in place turn for your vehicle, adjust the values until it does. These values will need to be used in the main file. You can also adjust the PWM values to increase the distance traversed. The current distance traversed was the size of my vehicle. Changes made to this value should also be made to the main file.

***Main***

Make sure you complete the previous two test plans first before starting this one. Once you have determined the correct motor values, replace them in this file at both the beginning in the global variables and at the end in the event methods. Then run the program. Using 3,0 as input, the vehicle will drive straight forward 3 spaces and then stop. Running 3,0 again, if you place your hand in the way close to when it starts moving, it will move around your hand to positions 1,1 ; 2,1 ; 3,1 ; and then 3,0. Other input can be tried as well. The exception where the destination is blocked is not handled and should not be tested as it could break the vehicle.

--------------------
**CSE321_Project3_rupinraj_TestingLCD.cpp:**
--------------------
 
This file includes the main loop that refreshes the LED screen to "Hello World" every iteration

***Things Declared***

CSE321_LCD lcd: The object necessary to implement the given API to control the LCD display

***API and Built In Elements Used***

Included the mbed.h import for basic functions provided by mbed studio

Included lcd1602.h which provided the available methods for use in the project from the API

Inputs: The number of display columns and the number of display rows. The rest of the inputs are preset.

***Custom Functions***

none


--------------------
**CSE321_Project3_rupinraj_TestingMatrixKeypad.cpp:**
--------------------

This file includes a main loop to iterate through the rows of the matrix keypad as input and several interrupts combined with ISRs for each column output.
Based on the value pressed, an LED will light up and the value will be printed to the serial output

***Things Declared***

InterruptIn col1: Interrupt set to pin E3 which will run onClick1()

InterruptIn col2: Interrupt set to pin E4 which will run onClick2()

InterruptIn col3: Interrupt set to pin E5 which will run onClick3()

InterruptIn col4: Interrupt set to pin E6 which will run onClick4()

int row: represents the row of the matrix keypad that will be on at a given time

int column: represents the column the key value was pressed in

void onClick1(): ISR for an input from column 1

void onClick2(): ISR for an input from column 2

void onClick3(): ISR for an input from column 3

void onClick4(): ISR for an input from column 4

bool input [16]: These 16 values are used to set trigger values when an input is pressed and an ISR is triggered

char out [16]: These 16 values correspond to the matrix keypad inputs

int pause [16]: These 16 values account for pause functionality to make sure a button is only pressed once over a certain time interval

***API and Built In Elements Used***

Included the mbed.h import for basic functions provided by mbed studio

***Custom Functions***

*Method Name: onClick1()*

Purpose: turn on the input trigger value for the input pressed from the matrix keypad

Inputs: matrix keypad press from row 1 and pause[i] for values between 0 and 3

Outputs: input[i] for values between 0 and 3




*Method Name: onClick2()*

Purpose: turn on the input trigger value for the input pressed from the matrix keypad

Inputs: matrix keypad press from row 2 and pause[i] for values between 4 and 7

Outputs: input[i] for values between 4 and 7




*Method Name: onClick3()*

Purpose: turn on the input trigger value for the input pressed from the matrix keypad

Inputs: matrix keypad press from row 3 and pause[i] for values between 8 and 11

Outputs: input[i] for values between 8 and 11




*Method Name: onClick4()*

Purpose: turn on the input trigger value for the input pressed from the matrix keypad

Inputs: matrix keypad press from row 4 and pause[i] for values between 12 and 15

Outputs: input[i] for values between 12 and 15


--------------------
**CSE321_Project3_rupinraj_TestingIR.cpp:**
--------------------
This file includes a main loop to spin poll whether the IR sensor has detected an obstacle. If an obstacle is detected, the onboard LED is turned on, otherwise, it is turned off.

***Things Declared***

none

***API and Built In Elements Used***

Included the mbed.h import for basic functions provided by mbed studio

***Custom Functions***

none

--------------------
**CSE321_Project3_rupinraj_TestingMatrixDotDisplay.cpp:**
--------------------
This file includes setup of a matrix dot display and then a display to be shown

***Things Declared***

MAX7219 m: the object necessary to control the matrix dot display

***API and Built In Elements Used***

Included the mbed.h import for basic functions provided by mbed studio

Included Max7219.h import to include API necessary for controlling the matrux dot display

***Custom Functions***

none


--------------------
**CSE321_Project3_rupinraj_TestingMotors.cpp:**
--------------------
This file includes the setup for the motors using PWMout. It will drive a given vehicle configured as above forward, turn left, and then backwards.

***Things Declared***

PwmOut motorLeft: the object to control the left motor using pulse width modulation

PwmOut motorRight: the object to control the right motor using pulse width modulation

***API and Built In Elements Used***

Included the mbed.h import for basic functions provided by mbed studio

***Custom Functions***

none

--------------------
**CSE321_Project3_rupinraj_main.cpp:**
--------------------
The main code for this project which will run a pathfinding solution for a vehicle configured as above in the Getting Started section.

***Things Declared***

 CSE321_LCD lcd: an LCD variable to control the LCD
 
 

 InterruptIn col1: an interrupt associated to the first column of the matrix keypad
 
 InterruptIn col2: an interrupt associated to the second column of the matrix keypad
 
 InterruptIn col3: an interrupt associated to the third column of the matrix keypad
 
 InterruptIn col4: an interrupt associated to the fourth column of the matrix keypad



 int row: the row in which a key was pressed on the keypad
 
 int column: the column in which a key was pressed on the keypad
 
 

 void onClick1(): the ISR to run for the interrupt triggered when a button on the first column of the matrix keypad is pressed
 
 void onClick2(): the ISR to run for the interrupt triggered when a button on the seond column of the matrix keypad is pressed
 
 void onClick3(): the ISR to run for the interrupt triggered when a button on the third column of the matrix keypad is pressed
 
 void onClick4(): the ISR to run for the interrupt triggered when a button on the fourth column of the matrix keypad is pressed

 bool input [16]: 16 booleans are used to set trigger values when an input is pressed and an ISR is triggered
 
 char out [16]: string values corresponding to the matrix keypad inputs
 
 int outNum [16]: allowed inputs from the matrix keypad for this project
 
 int pause [16]: 16 values to account for pause functionality that ensures a button is only pressed once over a certain time interval

 
 
 int pauseIRdetection: another pause variable, but for pausing IR detection

 
 
 PwmOut motorLeft: variable to control the functionality of the left motor
 
 PwmOut motorRight: variable to control the functionality of the left motor

 bool motorFlag: flag to lock the motors when an obstacle is detected

 bool stopped: flag to notify the main polling loop that an obstacle was detected

 bool started: flag to check if the eventQueue thread has already been started because threads can only be started once

 bool reachedDestination: flag to check if the destination has been reached so that the code will end and new IR input will be ignored



 float leftForward: decimal value used in rotating the left motor in the left direction

 float rightForward: decimal value used in rotating the right motor in the right direction

 float stop: decimal value used in stopping a motor

 float leftReverse: decimal value used in rotating the left motor in the right direction

 float rightReverse: decimal value used in rotating the right motor in the left direction



 int direction: orientation of the vehicle
 
 int directioncopy: orientation of the vehicle used for path translation
 
 int positionx: x position of the vehicle
 
 int positiony: y position of the vehicle

 int destination_x: x destination of the vehicle taken as first input from the matrix keypad
 
 int destination_y: y destination of the vehicle taken as second input from the matrix keypad



 EventQueue queuedPath: an eventQueue to hold the directions to follow the path to travel

 void eventMoveForward(): movement method that acts as an event to add into the eventQueue causing the vehicle to move forward
 
 void eventTurnLeft(): movement method that acts as an event to add into the eventQueue causing the vehicle to turn left 90 degrees
 
 void eventTurnRight(): movement method that acts as an event to add into the eventQueue causing the vehicle to turn right 90 degrees

 Event<void()> moveForward: method casted as an event to add to the eventQueue using post
 
 Event<void()> turnLeft: method casted as an event to add to the eventQueue using post
 
 Event<void()> turnRight: method casted as an event to add to the eventQueue using post
 


 void updateEventQueue(): a method to post events into the eventQueue

 void createPath(int x_start, int y_start, int x_end, int y_end): stores the correct path after using BFS

 void obstacleDetected(): an interrupt for handling IR sensor input to notify the main polling loop an obstacle has been detected
 
 void tryToUpdateEventQueue(): edit the graph when an obstacle is present in front of the vehicle

 InterruptIn IRInput: the interrupt associated to whenever the IR sensor goes low (detects an obstacle in the way)



 bool graph[25]: a graph that represents a 5x5 representation of visible obstacles seen while driving
 
 int path[25]: a path that will hold the sequence of nodes that should be traversed to reach the endpoint
 
 bool explored[25]: list used in BFS to check if a node is visited or not. If it has been visited, it will not be visited again.

 int mapping[25]: a map where each location is a node and the value placed will be a connected node that has explored the given node

 
 
 int indexExplore: holds the last location explored in the queue to explore
 
 int indexAddNode: holds the last location added to the queue to explore
 
 int toExplore[25]: a list of nodes to explore in BFS

 
 
 Thread startEventQueue: the thread that will start running the eventQueue holding the path directions

***API and Built In Elements Used***

Included the mbed.h import for basic functions provided by mbed studio

Included lcd1602.h which provided the available methods for use in the project from the API

***Custom Functions***

*Method Name: onClick1():*

Purpose: turn on the input trigger value for the input pressed from the matrix keypad

Inputs: matrix keypad press from row 1 and pause[i] for values between 0 and 3

Outputs: input[i] for values between 0 and 3



*Method Name: onClick2():*

Purpose: turn on the input trigger value for the input pressed from the matrix keypad

Inputs: matrix keypad press from row 2 and pause[i] for values between 4 and 7

Outputs: input[i] for values between 4 and 7



*Method Name: onClick3():*

Purpose: turn on the input trigger value for the input pressed from the matrix keypad

Inputs: matrix keypad press from row 3 and pause[i] for values between 8 and 11

Outputs: input[i] for values between 8 and 11



*Method Name: onClick4():*

Purpose: turn on the input trigger value for the input pressed from the matrix keypad

Inputs: matrix keypad press from row 4 and pause[i] for values between 12 and 15

Outputs: input[i] for values between 12 and 15



*Method Name: print():*

Purpose: A debugging method to ensure the correct path is being traversed by printing it out to the LCD

Inputs: an integer representing a node value (0 through 24)

Outputs: an LCD print corresponding to the node value



*Method Name: tryToUpdateEventQueue():*

Purpose: When input is detected from the IR sensor, the path and graph should be updated. The input from the IR sensor must be held constant for the graph to update or it will be ignored.

Inputs: IR sensor

Outputs: none



*Method Name: obstacleDetected():*

Purpose: When input is detected from the IR sensor, stop the motors first and let the main loop know they have been stopped

Inputs: IR sensor at the top of the vehicle

Outputs: none



*Method Name: createPath():*

Purpose: runs a BFS given the graph of obstacles, the start position and end position. This implementation of BFS uses arrays that were stored globally with initial values. Therefore, no new memory allocations are made in this method

Inputs: a start position (0,0) by default or current position after IR sensor detects an obstacle, an end position coming from the matrix keypad, and the obstacle graph

Outputs: an array holding a list of nodes to traverse



*Method Name: updateEventQueue():*

Purpose: responsible for adding directions into the eventQueue that it will run to reach the destination

Inputs: a list of nodes that need to be traversed

Outputs: a full eventQueue with events moveForward, turnLeft, or turnRight based on the list of nodes to traverse



*Method Name: eventTurnRight():*

Purpose: an event to turn the vehicle right using the motors. These values have been tested in a test file for motors. If the vehicle is not making a close to 90 degree right turn, adjust the wait time until it is. It is recommended to test this using the provided motor testing file rather than here.

Inputs: none

Outputs: both the left and right motors



*Method Name: eventTurnLeft():*

Purpose: an event to turn the vehicle left using the motors. These values have been tested in a test file for motors. If the vehicle is not making a close to 90 degree left turn, adjust the wait time until it is. It is recommended to test this using the provided motor testing file rather than here.

Inputs: none

Outputs: both the left and right motors



*Method Name: eventMoveForward():*

Purpose: move the vehicle forward using the motors. The distance of each grid is determined by the distance traveled in this event. Increase wait time to make grid sizes larger, or decrease wait time to reduce the grid size. It also updates the current position of the vehicle in terms of the graph

Inputs: none

Outputs: both the left and right motors
