/*#include "mbed.h" //import library

//***************************************
//
// Name: Rupin Raj Kumar Pradeep
// Summary of Assignment Purpose: Learn the functionality of the matrix keypad
// Date of Initial Creation: 11/18/22
//
// Description of Program Purpose: Print out to serial output the key pressed on the matrix keypad
//
// Functions and Modules in this file: main(), onClick1(), onClick2(), onClick3(), onClick4()
//
// Additional Required Files/Resources: mbed.h
//***************************************
 
//***************************************
//    Declare Global Variables
//***************************************
 //Create all 4 interrupts for each row of the matrix keypad
 //Set them all to pull down to prevent ghost presses
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
 //These 16 values account for pause functionality to make sure a button is only pressed once over a certain time interval
 int pause [16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};


// Method Name: main
// Purpose: Loop through the rows of the matrix keypad turning on and off each row consecutively
//          Turn on inputs from the matrix keypad and then print out the values corresponding to the value pressed
//          Also enables the interrupts along with the ISRs for the rising edge
// Inputs:  None
// Outputs: Outputs D4 through D7 connected to LEDs and serial output
 
int main() {
    //enable the clocks for GPIOD and GPIOE
    RCC->AHB2ENR |= (0x1 << 3);
    RCC->AHB2ENR |= (0x1 << 4);
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

    //create the infinite while loop for polling
    while(1){
        //turn on the LED and row associated with the matrix keypad
        GPIOD->ODR |= (0x1 << (4 + row));
        //check if any of the 16 inputs have been triggered
        for(int i = 0; i < 16; i++){
            //if an input has been triggered
            if(input[i]){
                //turn off the trigger for that input
                input[i] = 0;
                //set a pause function so that the trigger will not appear again unless held down for a certain amount of time
                pause[i] = 1;
                //print out the character that was triggered to the serial output
                putchar(out[i]);
                putchar('\n');
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
    //prevent leakage
    return 0;
}
 
//***************************************
//        Helper Functions
//***************************************
 
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
*/