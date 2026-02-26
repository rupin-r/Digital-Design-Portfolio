# TivaC DDR
An assembly implementation of an old rhythm game with Arduino communication for playing music on the computer.

## Setup
1. Download Code Composer Studio
2. Download Putty
3. Download Arduino
4. Download Processing
5. Buy a Tiva C Series TM4C123GH6PM
6. Create a new assembly with main.c project in Code Composer Studio with Target being Tiva C Series TM4C123GH6PM and Stellaris In Circuit Debugger
7. Drag and drop files "lab7_ADClibrary.s," "lab_7.s," "lab_7_library.s," "GameLoop.s," "main.c," "tm4c123gh6pm.cmd," and "tm4c123gh6pm_startup_ccs.c" into the new project and allow overwriting
8. Create a new Putty terminal with window appearance of 600 columns and 300 rows as well as font 2-point Courier New. Also, set the baud rate to 460,828 and type in the correct COM port on the serial line.
9. Upload the Arduino code to the Arduino
10. Copy and paste the processsing code into Processing. Then change the com port in the processing code to the same port as the Arduino and then click play
11. Build and load the Code Composer Studio code onto the Tiva C processor
12. SW1 is Start, up (w) and down (s) change selections, left (a) is back, and right (s) is select
13. In case a pad with variable resistance is hooked up to pins D0 to D3, these pins implement an ADC to act as inputs for up, down, left, and right. Otherwise, just use WASD input.
14. Play the game!

## Copyright
This project may be used for any purpose besides UB CSE 379. This code is easily identifiable as my own as the logic implemented, label names, and pixel resolution are generally unique. If you are caught using this repository for UB CSE 379, it will result in a 0. This code has no relevance to the class anyway as it is at a much higher level than what is expected. Additionally, for those attempting to distribute or sell this code, I highly advise against it as there are still several glitches that have not been fully fixed yet. Also, it would be highly beneficialy to change the animation style as there is significant lag printing in a console for animation.
