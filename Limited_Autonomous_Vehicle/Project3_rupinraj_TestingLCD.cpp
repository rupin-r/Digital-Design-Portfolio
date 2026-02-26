/*#include "mbed.h"
#include "lcd1602.h"

//***************************************
//
// Name: Rupin Raj Kumar Pradeep
// Summary of Assignment Purpose: Learn the functionality of the LCD
// Date of Initial Creation: 11/18/22
//
// Description of Program Purpose: Print out to the LCD
//
// Functions and Modules in this file: main()
//
// Constraints: must use provided LCD API
//
// Additional Required Files/Resources: mbed.h, lcd1602.h
//***************************************
 
//***************************************
//         Extra Files Included
//***************************************
//Name: lcd1602.cpp
//Author: Professor Winikus
//File Use in Project: The base methods available for use with the LCD including the functionality

//Name: lcd1602.h
//Author: Professor Winikus & user Yar from LiquidCrystal implementation of LCD
//File Use in Project: Provides the available API for use in this project to operate the LCD

//***************************************
//    Declare Global Variables
//***************************************

//Creates an object of the provided API in order to operate the LCD
CSE321_LCD lcd(16,2);

// Method Name: main
// Purpose: Turn on the LCD display and print out "Hello World"
// Inputs:  
// Outputs: An LCD display connected to pins PB_8 and PB_9

int main()
{
    //enable the clock for port B which includes the SDA and SCL pin needed to interact with the LCD
    RCC->AHB2ENR |= 0x2;

    //preset the LCD to starting values. It also includes tests to make sure it works before use
    lcd.begin();

    //Clear the first line for use
    lcd.clear();

    while (true) {
        //Clear the previous "Hello World"
        lcd.clear();
        //Print to the LCD display and make sure this text is outputted
        lcd.print("Hello World");
        //A wait of about 10 seconds to ensure the LCD isn't updating too fast
        wait_us(10000000);
    }
}
*/