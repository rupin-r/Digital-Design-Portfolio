/*#include "mbed.h"

// main() runs in its own thread in the OS
int main()
{
    PwmOut motorLeft(PB_6);
    PwmOut motorRight(PA_3);

    //changing = 0.05 for reverse
    //changing = 0.1 for forward
    //changing = 0.075 for stop
    float leftForward = 0.1;
    float rightForward = 0.05;
    float stop = 0.075;
    float leftReverse = 0.05;
    float rightReverse = 0.1;

    motorLeft.period_ms(20);
    motorRight.period_ms(20);

    //turning right
    //motorLeft.write(leftForward);
    //motorRight.write(rightReverse);
    //wait_us(570000);
    //motorLeft.write(stop);
    //motorRight.write(stop);

    //turning left
    //motorLeft.write(leftReverse);
    //motorRight.write(rightForward);
    //wait_us(570000);
    //motorLeft.write(stop);
    //motorRight.write(stop);

    //going straight
    //motorLeft.pulsewidth_us(2000);
    //motorRight.pulsewidth_us(800);
    //wait_us(800000);
    //motorLeft.pulsewidth_us(1500);
    //motorRight.pulsewidth_us(1500);

    while (true) {
        motorLeft.pulsewidth_us(1500);
        motorRight.pulsewidth_us(1500);
        wait_us(800000);
        motorLeft.pulsewidth_us(2000);
        motorRight.pulsewidth_us(800);
        wait_us(800000);
        motorLeft.pulsewidth_us(1500);
        motorRight.pulsewidth_us(1500);
        wait_us(800000);
        motorLeft.write(leftForward);
        motorRight.write(rightReverse);
        wait_us(570000);
        motorLeft.write(stop);
        motorRight.write(stop);
        wait_us(800000);
        motorLeft.pulsewidth_us(800);
        motorRight.pulsewidth_us(2000);
        wait_us(800000);
        motorLeft.pulsewidth_us(1500);
        motorRight.pulsewidth_us(1500);
        wait_us(800000);
        break;
    }
}
*/