# Welcome

### Haptic Research Team
Andy, Alex, Rupin, Tam, U Shin

### Project description
The project will make a haptic reality platform with an ultrasonic emitter array (at least 8 by 8, and ideally 16 * 16) that simulates the sense of touch and can be used for a range of applications such as enhanced gestures, producing tactile effects, like virtual lines and shapes, working with textures, as well as 3D models and controls.
The ultrasonic emitter array will be created using a printed circuit board (PCB), with one side having the ultrasonic emitters, and the other having the mounted field programmable gate array (FPGA) that controls the signals of the emitters, shift registers, drivers, and coupling capacitors. The algorithm for the emitter array will control each individual emitter so that they get triggered at different times so that all the waves coincide, the focal point. 

### Instructional guide to function the board

### Quest 2
1. Run the game
2. The Oculus Quest 2 shows a 16 x 16 array of spheres where the spheres are used as emitters.
3. The red cube in the middle of the 16 x 16 array allow you to position the 16 x 16 array to be fit inside the PCB in the real environment.
4. There will be red spheres on your left hand going from your fingertip to your palm allowing you to see and feel the focal point from the emitters.
5. It will keep constantly looping through your fingertip to the palm of your left hand.
6. The script that is run in the quest is to find the relative position of the red cube to all of the red spheres inside your hand and using that x, y, z position to be used as a input for the single point alogirthm allowing a 16 x 16 array of data to calculate where to emit the single focal point.
7. This 16 x 16 array of data will be transmitted to the esp32 by first connecting the quest 2 to the wifi of the esp32 allowing data to be transfer by wifi.

### FPGA
8. Open Quartus II
9. Load Verilog files and assign pins using Pin Planner
10. Run Python algorithm to generate phases
11. Ensure pwm.txt is set up
12. Run the entire process
    
### ESP32
13. Open VS code
14. Run main.c using Espressif IDF extension
15. Flash ESP32 for TCP server setup
16. Connect Quest 2 TCP socket to the server 
17. Receive 16x16 angle matrices from Quest 2
18. Send angle data through UART to FPGA (Rx)
