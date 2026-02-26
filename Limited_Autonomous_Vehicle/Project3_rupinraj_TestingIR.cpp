/*#include "mbed.h"

//***************************************
//
// Name: Rupin Raj Kumar Pradeep
// Summary of Assignment Purpose: Learn the functionality of the IR sensor
// Date of Initial Creation: 11/18/22
//
// Description of Program Purpose: Turn on an LED when an obstacle is detected
//
// Functions and Modules in this file: main()
//
// Additional Required Files/Resources: mbed.h
//***************************************

// Method Name: main
// Purpose: Whenever the IR sensor detects an object, turn on the LED
// Inputs:  An IR sensor connected to pin D0
// Outputs: A breadboarded LED connected to pin D1

int main()
{
    //Turn on the clock for GPIOD
    RCC->AHB2ENR |= (0x1 << 3);
    //Set pin D0 and D1 as inputs
    GPIOD->MODER &= ~(0xF);
    //set pin D1 as an output
    GPIOD->MODER |= (0x1 << 2);

    //The IR sensor is active low which means that when the IR sensor detects an object, it responds with a 0V (low) signal
    while (true) {
        //when the input of the sensor is low, turn on the LED
        if((GPIOD->IDR & (0x1)) != 0x1)
        {
            GPIOD->ODR |= 0x2;
        }
        //when the input of the sensor is high, turn off the LED
        //This means when the second red LED on the IR sensor is off, the breadboarded LED should also be off
        else{
            GPIOD->ODR &= ~(0x2);
        }
    }
}
*/