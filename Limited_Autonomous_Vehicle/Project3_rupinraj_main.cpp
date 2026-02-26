#include "mbed.h"
#include "lcd1602.h"
#include "string"

//***************************************
//
// Name: Rupin Raj Kumar Pradeep
// Assignment: Project 3 Final Project Autonomous Vehicle
// Summary of Assignment Purpose: Implement all peripherals into an autonomous vehicle
// Date of Initial Creation: 11/20/22
//
// Description of Program Purpose: Take in a coordinate from the matrix keypad using the LCD as a UI component
//                                  Once entered, functionality will be removed from these two components and will
//                                  switch over to the other components: the IR sensors and motors.
//                                  These will be responsible for recording and following a path through obstacles to
//                                  the final destination
//
// Functions and Modules in this file: main(), onClick1(), onClick2(), onClick3(), onClick4(), obstacleDetected(), print(), createPath()
//                                      tryToUpdateEventQueue(), updateEventQueue(), eventTurnRight(), eventTurnLeft(), eventMoveForward()
//
// Additional Required Files/Resources: mbed.h, lcd1602.h
//***************************************
 
//***************************************
//    Declare Global Variables
//***************************************

//an LCD variable to control the LCD
 CSE321_LCD lcd(16,2);

//Interrupts used for the matrix keypad
 InterruptIn col1(PE_3, PullDown);
 InterruptIn col2(PE_4, PullDown);
 InterruptIn col3(PE_5, PullDown);
 InterruptIn col4(PE_6, PullDown);

 //row and column add together to get the key pressed on the keypad
 int row = 0;
 int column = 0;

 //Create the ISRs for each interrupt
 void onClick1();
 void onClick2();
 void onClick3();
 void onClick4();

 //Create the arrays necessary for checking all input values
 //These 16 values are used to set trigger values when an input is pressed and an ISR is triggered
 bool input [16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
 //These 16 values correspond to the matrix keypad inputs
 char out [16] = {'1', '2', '3', 'A', '4', '5', '6', 'B', '7', '8', '9', 'C', '*', '0', '#', 'D'};
 int outNum [16] = {1, 2, 3, 0, 4, 5, 6, 0, 7, 8, 9, 0, 0, 0, 0, 0};
 //These 16 values account for pause functionality to make sure a button is only pressed once over a certain time interval
 int pause [16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

 //another pause variable, but for pausing IR detection
 int pauseIRdetection = 0;

 //variables to hold the motors as global resources
 PwmOut motorLeft(PB_6);
 PwmOut motorRight(PA_3);

 //flag to lock the motors when an obstacle is detected
 bool motorFlag = true;
 //flag to notify the main polling loop that an obstacle was detected
 bool stopped = true;
 //flag to check if the eventQueue thread has already been started because threads can only be started once
 bool started = false;
 //flag to check if the destination has been reached so that the code will end and new IR input will be ignored
 bool reachedDestination = false;

 //global variables necessary to drive the motors
 //pwm values provided by data sheet, change these if necessary
 float leftForward = 0.1;
 float rightForward = 0.05;
 float stop = 0.075;
 float leftReverse = 0.05;
 float rightReverse = 0.1;

 //holds both the orientation and position of the vehicle
 int direction = 1;
 int directioncopy = 1;
 int positionx = 0;
 int positiony = 0;

 //holds the destination provided with the matric keypad
 int destination_x = 0;
 int destination_y = 0;

 //an eventQueue to hold the path traveled
 EventQueue queuedPath(32*EVENTS_QUEUE_SIZE);

 //Instantiate the three movement methods to use in the event constructor
 void eventMoveForward();
 void eventTurnLeft();
 void eventTurnRight();

 //Attach three events to the eventQueue with methods moveForward, turnLeft, and turnRight
 //By creating these events here, they can now be posted to the eventQueue using the .post method
 Event<void()> moveForward(&queuedPath, eventMoveForward);
 Event<void()> turnLeft(&queuedPath, eventTurnLeft);
 Event<void()> turnRight(&queuedPath, eventTurnRight);
 
 //a method to post events into the eventQueue
 void updateEventQueue();

 //stores the correct path after using BFS
 void createPath(int x_start, int y_start, int x_end, int y_end);

 //an interrupt for handling IR sensor input to update the eventqueue
 void obstacleDetected();

 //this method will edit the graph when an obstacle is present in front of the vehicle
 void tryToUpdateEventQueue();

 //this will be run in a thread and therefore must handle critical sections with the eventqueue threads
 InterruptIn IRInput(PD_0, PullUp);

 //this graph represents a 5x5 representation of visible obstacles seen while driving
 bool graph[25] =  {true,true,true,true,true,
                    true,true,true,true,true,
                    true,true,true,true,true,
                    true,true,true,true,true,
                    true,true,true,true,true};
 
 //this path will eventually hold the sequence of nodes that should be traversed to reach the endpoint
 int path[25] = {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1};
 
 //this list is used in BFS to check if a node is visited or not. If it has been visited, it will not be visited again
 bool explored[25] =   {false,false,false,false,false,
                        false,false,false,false,false,
                        false,false,false,false,false,
                        false,false,false,false,false,
                        false,false,false,false,false};

 //this array will act like a map where each location is a node and the value placed will be a connected node that has explored the given node
 //it is necessary for creating the path at the end of BFS
 int mapping[25] = {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1};

 //variables used to enqueue nodes to explore in BFS which acts similar to an array ring buffer
 int indexExplore = 0;
 int indexAddNode = 0;
 int toExplore[25] = {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1};

 //the thread that will start running the eventQueue holding the path directions
 Thread startEventQueue;


//***************************************
//         Extra Files Included
//***************************************
//Name: lcd1602.cpp
//Author: Professor Winikus
//File Use in Project: The base methods available for use with the LCD including the functionality
//Fixes: None

//Name: lcd1602.h
//Author: Professor Winikus & user Yar from LiquidCrystal implementation of LCD
//File Use in Project: Provides the available API for use in this project to operate the LCD
//Fixes: None

//***************************************
//              Main Code
//***************************************

// Method Name: main
// Purpose: Collect input from the matrix keypad and show it on the LCD display
//          After collecting the necessary input, start the eventqueue
// Inputs:  A matrix keypad connected to pins PD_4 to PD_7 and PE_3 to PE_6
// Outputs: An LCD display connected to pins PB_8 and PB_9

int main()
{
    //This is where GPIO configuration will happen including setting the clocks and mode
    //enable the clocks for GPIOD and GPIOE
    RCC->AHB2ENR |= (0x1 << 3);
    RCC->AHB2ENR |= (0x1 << 4);
    //enable the clock for port B which includes the SDA and SCL pin needed to interact with the LCD
    RCC->AHB2ENR |= (0x1 << 1);
    //set pins D4 through D7 as outputs
    GPIOD->MODER &= ~(0xFF << 8);
    GPIOD->MODER |= 0x55 << 8;
    //set pins E3 through E6 as inputs
    GPIOE->MODER &= ~(0xFF << 6);

    //set the ISR for each Interrupt rising functionality
    col1.rise(onClick1);
    col2.rise(onClick2);
    col3.rise(onClick3);
    col4.rise(onClick4);

    //Enable the interrupts internally
    col1.enable_irq();
    col2.enable_irq();
    col3.enable_irq();
    col4.enable_irq();
 
    //Initialize the liquid crystal display and display initial input prompt
    lcd.begin();
    lcd.clear();
    lcd.print("Enter x endpoint");

    //This is where function variables will be set to store input and the state of the current vehicle
    int inputCollected = 0;

    //A watchdog timer will also be setup here
    Watchdog::get_instance().start();
    //This while loop will not be infinite, it will end once all input is collected
    while (inputCollected < 2) {
        //input collection will happen in here
        //Only 0 - 9 will be accepted and a max of one digit may be entered per x or y coordinate
        //No takesie-backsies, once a digit is entered, it's permanent

        //turn on the LED and row associated with the matrix keypad
        GPIOD->ODR |= (0x1 << (4 + row));
        //check if any of the 16 inputs have been triggered
        for(int i = 0; i < 16; i++){
            //if an input has been triggered
            if(i != 3 && i != 7 && i != 11 && i != 12 && i != 14 && i != 15 && input[i]){
                //turn off the trigger for that input
                input[i] = 0;
                //set a pause function so that the trigger will not appear again unless held down for a certain amount of time
                pause[i] = 1;
                //print out the character that was triggered to the serial output
                putchar(out[i]);
                putchar('\n');
                //if a valid input is entered, make sure the data collected is incremented
                inputCollected += 1;
                //LCD output will vary based on the state of data collection
                if(inputCollected == 1){
                    Watchdog::get_instance().kick();
                    destination_x = outNum[i];
                    lcd.clear();
                    lcd.print("Enter y endpoint");
                }
                else{
                    destination_y = outNum[i];
                    lcd.clear();
                    break;
                    lcd.print("Starting path");
                }
            }
            //if an input was triggered and the pause function was enabled
            if(pause[i] > 0){
                //increase the pause for that input
                pause[i] += 1;
            }
        }
        //the polling interval for looping through the rows of the matrix keypad, equal to 0.001 seconds
        wait_us(1000);
        //turn off the LED and output for the row
        GPIOD->ODR &= ~(0x1 << (4 + row));
        //increment the row by 1 and set it back to 0 if row is equal to 4
        row = (row + 1) % 4;
    }

    //after input collection, the GPIO configuration will be turned off for only the matrix keypad and LCD display
    RCC->AHB2ENR &= ~(0x1 << 4);
    RCC->AHB2ENR &= ~(0x1 << 1);

    col1.disable_irq();
    col2.disable_irq();
    col3.disable_irq();
    col4.disable_irq();

    //set up the interrupt for the IR sensor
    GPIOD->MODER &= ~(0x3);
    IRInput.fall(&obstacleDetected);
    IRInput.enable_irq();

    //make sure watchdog hasn't timed out
    Watchdog::get_instance().kick();

    //make sure watchdog hasn't timed out while trying to create a path
    Watchdog::get_instance().kick();

    //a polling loop to run methods out of ISR context when an obstacle has been detected
    int p = 0;
    while(!reachedDestination){
        //the situation where the vehicle has stopped and the interrupt pause time for the IR sensor has not reset yet
        if(stopped && p == 0){
            //increase the pause index so that it starts waiting
            p++;
            //the vehicle is no longer stopped as it will soon have a path to follow
            stopped = false;
            //if the motors are stopped, this indicates it is not the beginning of the program
            if(!motorFlag)
                //update the graph
                tryToUpdateEventQueue();
            //makes a path to follow based on the given graph
            //the graph will initially have no obstacles
            createPath(positionx, positiony, destination_x, destination_y);
            //create an eventQueue of movements out of the path to follow
            updateEventQueue();
        }
        //in the case that the pause time has not reset, increment until it can be reset
        else if (p != 0) {
            p++;
            //this if statement corresponds to about 1000000 us or 1 second
            if(p == 10)
                p = 0;
        }
        //check if the destination has been reached so that the while loop can end
        if(positionx == destination_x && positiony == destination_y){
            reachedDestination = true;
        }
        //the polling time in this case must be large, but not larger than the moving time of any+ single event
        wait_us(100000);
    }
}

// Method Name: onClick1()
// Purpose: turn on the input trigger value for the input pressed from the matrix keypad
// Inputs: matrix keypad press from row 1 and pause[i] for values between 0 and 3
// Outputs: input[i] for values between 0 and 3

void onClick1(){
    //a wait in order to account for bounce
    wait_us(1000);
    //if the input value is still on
    if(GPIOE->IDR & (0x1 << 3)){
        //if this button hasn't been pressed yet or the wait time has completed
        if(pause[row*4 + 0] == 0 || pause[row*4 + 0] > 500){
            //set all other pause functions to 0
            for(int i = 0; i < 16; i++){
                pause[i] = 0;
            }
            //set the input trigger based on the corresponding row and column
            input[row*4 + 0] = 1;
        }
    }
}

// Method Name: onClick2()
// Purpose: turn on the input trigger value for the input pressed from the matrix keypad
// Inputs: matrix keypad press from row 2 and pause[i] for values between 4 and 7
// Outputs: input[i] for values between 4 and 7

void onClick2(){
    //a wait in order to account for bounce
    wait_us(1000);
    //if the input value is still on
    if(GPIOE->IDR & (0x1 << 4)){
        //if this button hasn't been pressed yet or the wait time has completed
        if(pause[row*4 + 1] == 0 || pause[row*4 + 1] > 500){
            //set all other pause functions to 0
            for(int i = 0; i < 16; i++){
                pause[i] = 1;
            }
            //set the input trigger based on the corresponding row and column
            input[row*4 + 1] = 1;
        }
    }
}

// Method Name: onClick3()
// Purpose: turn on the input trigger value for the input pressed from the matrix keypad
// Inputs: matrix keypad press from row 3 and pause[i] for values between 8 and 11
// Outputs: input[i] for values between 8 and 11

void onClick3(){
    //a wait in order to account for bounce
    wait_us(1000);
    //if the input value is still on
    if(GPIOE->IDR & (0x1 << 5)){
        //if this button hasn't been pressed yet or the wait time has completed
        if(pause[row*4 + 2] == 0 || pause[row*4 + 2] > 500){
            //set all other pause functions to 0
            for(int i = 0; i < 16; i++){
                pause[i] = 0;
            }
            //set the input trigger based on the corresponding row and column
            input[row*4 + 2] = 1;
        }
    }
}

// Method Name: onClick4()
// Purpose: turn on the input trigger value for the input pressed from the matrix keypad
// Inputs: matrix keypad press from row 4 and pause[i] for values between 12 and 15
// Outputs: input[i] for values between 12 and 15

void onClick4(){
    //a wait in order to account for bounce
    wait_us(1000);
    //if the input value is still on
    if(GPIOE->IDR & (0x1 << 6)){
        //if this button hasn't been pressed yet or the wait time has completed
        if(pause[row*4 + 3] == 0 || pause[row*4 + 3] > 500){
            //set all other pause functions to 0
            for(int i = 0; i < 16; i++){
                pause[i] = 0;
            }
            //set the input trigger based on the corresponding row and column
            input[row*4 + 3] = 1;
        }
    }
}

// Method Name: print()
// Purpose: A debugging method to ensure the correct path is being traversed by printing it out to the LCD
// Inputs: an integer representing a node value (0 through 24)
// Outputs: an LCD print corresponding to the node value

void print(int x){
    //an if statement for every single value between 0 and 24 was the easiest way to program this section
    //this method is not required, so if edits are made to the size of the graph, I recommend commenting this method out
    if(x == 0){
        lcd.print("0");
    }
    if(x == 1){
        lcd.print("1");
    }
    if(x == 2){
        lcd.print("2");
    }
    if(x == 3){
        lcd.print("3");
    }
    if(x == 4){
        lcd.print("4");
    }
    if(x == 5){
        lcd.print("5");
    }
    if(x == 6){
        lcd.print("6");
    }
    if(x == 7){
        lcd.print("7");
    }
    if(x == 8){
        lcd.print("8");
    }
    if(x == 9){
        lcd.print("9");
    }
    if(x == 10){
        lcd.print("10");
    }
    if(x == 11){
        lcd.print("11");
    }
    if(x == 12){
        lcd.print("12");
    }
    if(x == 13){
        lcd.print("13");
    }
    if(x == 14){
        lcd.print("14");
    }
    if(x == 15){
        lcd.print("15");
    }
    if(x == 16){
        lcd.print("16");
    }
    if(x == 17){
        lcd.print("17");
    }
    if(x == 18){
        lcd.print("18");
    }
    if(x == 19){
        lcd.print("19");
    }
    if(x == 20){
        lcd.print("20");
    }
    if(x == 21){
        lcd.print("21");
    }
    if(x == 22){
        lcd.print("22");
    }
    if(x == 23){
        lcd.print("23");
    }
    if(x == 24){
        lcd.print("24");
    }
}

// Method Name: tryToUpdateEventQueue()
// Purpose: When input is detected from the IR sensor, the path and graph should be updated.
//          The input from the IR sensor must be held constant for the graph to update or it will be ignored.
// Inputs: IR sensor
// Outputs: none

void tryToUpdateEventQueue(){
    //make sure the input is still detecting an object in the way
    //if the input is gone, there is no need to update the graph
    if((GPIOD->IDR & 0x1) == 0x0){

        //stop the motors from moving first
        motorLeft.pulsewidth_us(1500);
        motorRight.pulsewidth_us(1500);

        //after adjusting for bounce and time to clear eventQueue
        wait_us(1000000);

        //based on the direction that the vehicle is facing, determine where to put the obstacle in the graph
        //these if statements determine if the value is within the bounds of the graph and should be added
        //if the size of the graph changes, these values must be changed as well
        if(direction == 1){
            if(positionx != 4)
                graph[(positionx + 1)*5 + positiony] = false;
        }
        else if(direction == 2){
            if(positiony != 4)
                graph[(positionx)*5 + positiony + 1] = false;
        }
        else if(direction == 3){
            if(positionx != 0)
                graph[(positionx - 1)*5 + positiony] = false;
        }
        else{
            if(positiony != 0)
                graph[(positionx)*5 + positiony - 1] = false;
        }
        //make sure the watchdog doesn't time out during this interrupt
        Watchdog::get_instance().kick();
    }
}

// Method Name: obstacleDetected()
// Purpose: When input is detected from the IR sensor, stop the motors first and let the main loop know they have been stopped
// Inputs: IR sensor at the top of the vehicle
// Outputs: none
void obstacleDetected(){
    motorFlag = false;
    stopped = true;
}

// Method Name: createPath()
// Purpose: runs a BFS given the graph of obstacles, the start position and end position.
//          This implementation of BFS uses arrays that were stored globally with initial values
//          Therefore, no new memory allocations are made in this method
// Inputs: a start position (0,0) by default or current position after IR sensor detects an obstacle,
//         an end position coming from the matrix keypad, and the obstacle graph
// Outputs: an array holding a list of nodes to traverse

void createPath(int x_start, int y_start, int x_end, int y_end){
    lcd.clear();
    //reset all values except the graph itself
    indexAddNode = 0;
    indexExplore = 0;
    for(int i = 0; i < 25; i++){
        explored[i] = false;
        toExplore[i] = -1;
        mapping[i] = -1;
    }
    //set the starting point as visited
    explored[x_end*5 + y_end] = true;
    //check if exploring up is valid
    if(x_end != 4 && graph[(x_end + 1) * 5 + y_end]){
        //if it is valid, enqueue it to the exploring list
        toExplore[indexAddNode] = (x_end + 1) * 5 + y_end;
        //set it as explored
        explored[(x_end + 1) * 5 + y_end] = true;
        //set its mapping to the previous value, so its value reverse maps to the node that found it first
        mapping[(x_end + 1) * 5 + y_end] = x_end*5 + y_end;
        indexAddNode++;
    }
    //check if exploring right is valid
    if(y_end != 4 && graph[(x_end) * 5 + y_end + 1]){
        //if it is valid, enqueue it to the exploring list
        toExplore[indexAddNode] = (x_end) * 5 + y_end + 1;
        //set it as explored
        explored[(x_end) * 5 + y_end + 1] = true;
        //set its mapping to the previous value, so its value reverse maps to the node that found it first
        mapping[(x_end) * 5 + y_end + 1] = x_end*5 + y_end;
        indexAddNode++;
    }
    //check if exploring down is valid
    if(x_end != 0 && graph[(x_end - 1) * 5 + y_end]){
        //if it is valid, enqueue it to the exploring list
        toExplore[indexAddNode] = (x_end - 1) * 5 + y_end;
        //set it as explored
        explored[(x_end - 1) * 5 + y_end] = true;
        //set its mapping to the previous value, so its value reverse maps to the node that found it first
        mapping[(x_end - 1) * 5 + y_end] = x_end*5 + y_end;
        indexAddNode++;
    }
    //check if exploring left is valid
    if(y_end != 0 && graph[(x_end) * 5 + y_end - 1]){
        //if it is valid, enqueue it to the exploring list
        toExplore[indexAddNode] = (x_end) * 5 + y_end - 1;
        //set it as explored
        explored[(x_end) * 5 + y_end - 1] = true;
        //set its mapping to the previous value, so its value reverse maps to the node that found it first
        mapping[(x_end) * 5 + y_end - 1] = x_end*5 + y_end;
        indexAddNode++;
    }
    //The BFS loop that goes through until either all nodes in the queue are checked or the destination it found
    while(toExplore[indexExplore] != -1){
        //base case where destination is found
        if(x_start*5 + y_start == toExplore[indexExplore]){
            //simulates clearing the toExplore queue
            toExplore[indexExplore + 1] = -1;
            indexExplore++;
        }
        else{
            //set the current node as the dequeue of the toExplore queue
            int explore = toExplore[indexExplore];
            //convert an int into a coordinate x,y
            int y = explore%5;
            int x = (explore-y)/5;
            //use this new x and y to do the same checks as before the while loop
            if(x != 4 && graph[(x + 1) * 5 + y] && !explored[(x + 1) * 5 + y]){
                toExplore[indexAddNode] = (x + 1) * 5 + y;
                explored[(x + 1) * 5 + y] = true;
                mapping[(x + 1) * 5 + y] = x*5 + y;
                indexAddNode++;
            }
            if(y != 4 && graph[(x) * 5 + y + 1] && !explored[(x) * 5 + y + 1]){
                toExplore[indexAddNode] = (x) * 5 + y + 1;
                explored[(x) * 5 + y + 1] = true;
                mapping[(x) * 5 + y + 1] = x*5 + y;
                indexAddNode++;
            }
            if(x != 0 && graph[(x - 1) * 5 + y] && !explored[(x - 1) * 5 + y]){
                toExplore[indexAddNode] = (x - 1) * 5 + y;
                explored[(x - 1) * 5 + y] = true;
                mapping[(x - 1) * 5 + y] = x*5 + y;
                indexAddNode++;
            }
            if(y != 0 && graph[(x) * 5 + y - 1] && !explored[(x) * 5 + y - 1]){
                toExplore[indexAddNode] = (x) * 5 + y - 1;
                explored[(x) * 5 + y - 1] = true;
                mapping[(x) * 5 + y - 1] = x*5 + y;
                indexAddNode++;
            }
            indexExplore++;
        }
    }
    //start creating the path
    int start = 0;
    //add the beginning node
    path[start++] = x_start * 5 + y_start;

    //application of the reverse mapping finds the next node by plugging in the current node
    int dest = mapping[x_start*5 + y_start];

    //reset the watchdog just in case BFS took a long time
    Watchdog::get_instance().kick();
    //keep adding the reverse mapping into the path until it reaches the end represented by -1
    while(dest != -1){
        print(dest);
        path[start++] = dest;
        dest = mapping[dest];
    }
}

// Method Name: updateEventQueue()
// Purpose: responsible for adding directions into the eventQueue that it will run to reach the destination
// Inputs: a list of nodes that need to be traversed
// Outputs: a full eventQueue with events moveForward, turnLeft, or turnRight based on the list of nodes to traverse

void updateEventQueue(){
    //direction refers to the orientation of the vehicle
    //directioncopy will simulate this direction while placing events in, but making sure not to edit the current orientation
    directioncopy = direction;

    motorFlag = true;
    //loop through all nodes of the path
    //since the graph is a 5x5 grid, the maximum path length can only be 25
    for(int i = 0; i < 24; i++){
        //if the path is done, end the for loop by setting i greater than the conditional
        if(path[i+1] == -1){
            i = 25;
        }
        else{
            //this conditional checks for moving left
            //For example, if path[i+1] = 1 and path[i] = 2, then moving from 2 to 1 is going left
            //Visualization:
            // 20  21  22  23  24

            // 15  16  17  18  19

            // 10  11  12  13  14

            // 5   6   7   8   9

            // 0   1 <-2   3   4
            if(path[i+1] - path[i] == -1){
                //orientation matches movement direction, just move forward
                if(directioncopy == 4){
                    moveForward.post();
                }
                //orientation doesn't match, but is only one direcion off
                else if(directioncopy == 3){
                    directioncopy = 4;
                    turnRight.post();
                    moveForward.post();
                }
                else if(directioncopy == 1){
                    directioncopy = 4;
                    turnLeft.post();
                    moveForward.post();
                }
                //orientation is in opposite direction. Unlikely to ever occur, but kept in as a fail safe
                else{
                    directioncopy = 4;
                    turnLeft.post();
                    turnLeft.post();
                    moveForward.post();
                }
            }
            //this conditional checks for moving right
            //For example, if path[i+1] = 13 and path[i] = 12, then moving from 12 to 13 is going right
            //Visualization:
            // 20  21  22  23  24

            // 15  16  17  18  19

            // 10  11  12->13  14

            // 5   6   7   8   9

            // 0   1   2   3   4
            else if(path[i+1] - path[i] == 1){
                //orientation matches movement direction, just move forward
                if(directioncopy == 2){
                    moveForward.post();
                }
                //orientation doesn't match, but is only one direcion off
                else if(directioncopy == 1){
                    directioncopy = 2;
                    turnRight.post();
                    moveForward.post();
                }
                else if(directioncopy == 3){
                    directioncopy = 2;
                    turnLeft.post();
                    moveForward.post();
                }
                //orientation is in opposite direction. Unlikely to ever occur, but kept in as a fail safe
                else{
                    directioncopy = 2;
                    turnLeft.post();
                    turnLeft.post();
                    moveForward.post();
                }
            }
            //this conditional checks for moving down
            //For example, if path[i+1] = 7 and path[i] = 12, then moving from 12 to 7 is going down
            //Visualization:
            // 20  21  22  23  24

            // 15  16  17  18  19

            // 10  11  12  13  14
            //         V
            // 5   6   7   8   9

            // 0   1   2   3   4
            else if(path[i+1] - path[i] == -5){
                //orientation matches movement direction, just move forward
                if(directioncopy == 3){
                    moveForward.post();
                }
                //orientation doesn't match, but is only one direcion off
                else if(directioncopy == 2){
                    directioncopy = 3;
                    turnRight.post();
                    moveForward.post();
                }
                else if(directioncopy == 4){
                    directioncopy = 3;
                    turnLeft.post();
                    moveForward.post();
                }
                //orientation is in opposite direction. Unlikely to ever occur, but kept in as a fail safe
                else{
                    directioncopy = 3;
                    turnLeft.post();
                    turnLeft.post();
                    moveForward.post();
                }
            }
            //this conditional checks for moving up
            //For example, if path[i+1] = 5 and path[i] = 0, then moving from 0 to 5 is going up
            //Visualization:
            // 20  21  22  23  24

            // 15  16  17  18  19

            // 10  11  12  13  14

            // 5   6   7   8   9
            // ^
            // 0   1   2   3   4
            else{
                //orientation matches movement direction, just move forward
                if(directioncopy == 1){
                    moveForward.post();
                }
                //orientation doesn't match, but is only one direcion off
                else if(directioncopy == 4){
                    directioncopy = 1;
                    turnRight.post();
                    moveForward.post();
                }
                else if(directioncopy == 2){
                    directioncopy = 1;
                    turnLeft.post();
                    moveForward.post();
                }
                //orientation is in opposite direction. Unlikely to ever occur, but kept in as a fail safe
                else{
                    directioncopy = 1;
                    turnLeft.post();
                    turnLeft.post();
                    moveForward.post();
                }
            }
        }
    }
    //reset the watchdog
    Watchdog::get_instance().kick();
    //if the program has not started yet, the thread must be started with the queued path
    if(!started){
        started = true;
        startEventQueue.start(callback(&queuedPath, &EventQueue::dispatch_once));
    }
    //otherwise, just restart the eventQueue
    else{
        queuedPath.dispatch_once();
    }
}

// Method Name: eventTurnRight()
// Purpose: an event to turn the vehicle right using the motors. These values have been tested in a test file for motors.
//          If the vehicle is not making a close to 90 degree right turn, adjust the wait time until it is.
//          It is recommended to test this using the provided motor testing file rather than here.
// Inputs: none
// Outputs: both the left and right motors

void eventTurnRight(){
    if(motorFlag){
        //reset the watchdog
        Watchdog::get_instance().kick();

        //change the orientation of the vehicle
        direction = (direction % 4) + 1;

        //move the motors to turn right which takes .57 seconds
        motorLeft.write(leftForward);
        motorRight.write(rightReverse);
        wait_us(570000);

        //stop the motors
        motorLeft.write(stop);
        motorRight.write(stop);

        //since the above wait time is very large, the watchdog must be reset again at the end
        Watchdog::get_instance().kick();
    }
}

// Method Name: eventTurnLeft()
// Purpose: an event to turn the vehicle left using the motors. These values have been tested in a test file for motors.
//          If the vehicle is not making a close to 90 degree left turn, adjust the wait time until it is.
//          It is recommended to test this using the provided motor testing file rather than here.
// Inputs: none
// Outputs: both the left and right motors

void eventTurnLeft(){
    if(motorFlag){
        //reset the watchdog
        Watchdog::get_instance().kick();

        //change the orientation of the vehicle
        direction = (direction - 1);
        if(direction == 0){
            direction = 4;
        }

        //move the motors to turn left which takes .57 seconds
        motorLeft.write(leftReverse);
        motorRight.write(rightForward);
        wait_us(570000);

        //stop the motors
        motorLeft.write(stop);
        motorRight.write(stop);

        //since the above wait time is very large, the watchdog must be reset again at the end
        Watchdog::get_instance().kick();
    }
}

// Method Name: eventMoveForward()
// Purpose: move the vehicle forward using the motors. The distance of each grid is determined by the distance traveled in this event.
//          Increase wait time to make grid sizes larger, or decrease wait time to reduce the grid size.
//          It also updates the current position of the vehicle in terms of the graph
// Inputs: none
// Outputs: both the left and right motors

void eventMoveForward(){
    if(motorFlag){
        //reset the watchdog
        Watchdog::get_instance().kick();

        //change the position of the vehicle. This will also update createPath if it is called again
        if(direction == 1)
            positionx += 1;
        else if(direction == 2)
        positiony += 1;
        else if(direction == 3)
            positionx -= 1;
        else
            positiony -= 1;
    
        //move the motors to move forward the size of the vehicle (my current grid size) which takes .8 seconds
        //pwm values provided by data sheet, change these if necessary
        motorLeft.pulsewidth_us(2000);
        motorRight.pulsewidth_us(800);
        wait_us(800000);

        //stop the motors
        //pwm values provided by data sheet, change these if necessary
        motorLeft.pulsewidth_us(1500);
        motorRight.pulsewidth_us(1500);

        //since the above wait time is very large, the watchdog must be reset again at the end
        Watchdog::get_instance().kick();
    }
}