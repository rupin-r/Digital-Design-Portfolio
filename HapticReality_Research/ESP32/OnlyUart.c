#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"
#include "driver/spi_master.h"
#include "driver/gpio.h"
#include "driver/uart.h"

#include "esp_system.h"
#include "esp_wifi.h"
#include "esp_event.h"
#include "esp_log.h"
#include "nvs_flash.h"

#include "lwip/sockets.h"
#include "lwip/dns.h"
#include "lwip/netdb.h"
#include "lwip/err.h"
#include "lwip/sys.h"

#define FRAME_SIZE 256

//phase offset
char phase_offsets[256] = {0, 37, 37, 76, 36, 35, 34, 128, 0, 37, 44, 32, 128, 128, 73, 0, 78, 40, 36, 78, 34, 36, 68, 128, 36, 75, 76, 77, 22, 67, 74, 128, 31, 78, 30, 31, 70, 34, 30, 128, 76, 77, 36, 68, 31, 72, 73, 128, 77, 77, 27, 74, 62, 35, 27, 73, 128, 128, 128, 128, 128, 128, 128, 128, 71, 21, 73, 73, 27, 66, 72, 128, 34, 71, 25, 68, 71, 30, 30, 34, 30, 76, 72, 66, 70, 9, 74, 33, 35, 76, 32, 28, 27, 73, 22, 128, 74, 32, 73, 71, 34, 34, 32, 23, 65, 34, 27, 69, 31, 36, 30, 30, 78, 66, 31, 32, 26, 24, 64, 128, 32, 66, 71, 32, 74, 36, 71, 128, 41, 77, 35, 69, 73, 128, 76, 34, 30, 32, 128, 32, 29, 29, 34, 34, 31, 34, 36, 38, 36, 73, 22, 68, 69, 71, 67, 74, 23, 30, 33, 34, 78, 73, 69, 69, 31, 73, 68, 73, 128, 128, 128, 128, 128, 128, 128, 128, 34, 35, 36, 128, 26, 61, 27, 24, 31, 24, 74, 36, 24, 64, 30, 36, 128, 128, 128, 128, 70, 128, 32, 128, 71, 34, 128, 128, 32, 32, 32, 76, 37, 39, 128, 71, 33, 29, 128, 128, 36, 71, 35, 33, 29, 70, 73, 36, 37, 69, 28, 71, 31, 31, 68, 29, 73, 33, 33, 36, 70, 33, 76, 27, 27, 31, 30, 32, 32, 128, 66, 77, 74, 31, 33, 35, 72, 25, 71, 33};
//the buffer to edit that should contain raw data from focal point.
char test_buffer[256] = {16, 65, 28, 64, 14, 36, 51, 58, 58, 51, 36, 14, 64, 28, 65, 16, 65, 35, 79, 36, 66, 8, 23, 31, 31, 23, 8, 66, 36, 79, 35, 65, 28, 79, 43, 0, 31, 54, 69, 76, 76, 69, 54, 31, 0, 43, 79, 28, 64, 36, 0, 38, 69, 12, 28, 35, 35, 28, 12, 69, 38, 0, 36, 64, 14, 66, 31, 69, 20, 43, 59, 67, 67, 59, 43, 20, 69, 31, 66, 14, 36, 8, 54, 12, 43, 67, 2, 10, 10, 2, 67, 43, 12, 54, 8, 36, 51, 23, 69, 28, 59, 2, 18, 26, 26, 18,  2, 59, 28, 69, 23, 51, 58, 31, 76, 35, 67, 10, 26, 34, 34, 26, 10, 67, 35, 76, 31, 58, 58, 31, 76, 35, 67, 10, 26, 34, 34, 26, 10, 67, 35, 76, 31, 58, 51, 23, 69, 28, 59, 2, 18, 26, 26, 18,  2, 59, 28, 69, 23, 51, 36, 8, 54, 12, 43, 67, 2, 10, 10, 2, 67, 43, 12, 54, 8, 36, 14, 66, 31, 69, 20, 43, 59, 67, 67, 59, 43, 20, 69, 31, 66, 14, 64, 36, 0, 38, 69, 12, 28, 35, 35, 28, 12, 69, 38, 0, 36, 64, 28, 79, 43, 0, 31, 54, 69, 76, 76, 69, 54, 31,  0, 43, 79, 28, 65, 35, 79, 36, 66, 8, 23, 31, 31, 23, 8, 66, 36, 79, 35, 65, 16, 65, 28, 64, 14, 36, 51, 58, 58, 51, 36, 14, 64, 28, 65, 16};
//the buffer that combines the phase offsets and test buffer to send over UART
char send_buffer[257] = {126, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
//uart clocks for the verilog code to be able to handle UART
char clock_buffer[512] = {85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85};

void sendData();

void sendClock();

void sendNegativeClock();

uart_config_t uart_config;

int flag = 0;
// Main application task
void app_main(void)
{
    //UART configuration
    uart_config_t uart_config = {
        .baud_rate = 115200,
        .data_bits = UART_DATA_8_BITS,
        .parity = UART_PARITY_DISABLE,
        .stop_bits = UART_STOP_BITS_1,
        .flow_ctrl = UART_HW_FLOWCTRL_DISABLE};

    uart_param_config(UART_NUM_0, &uart_config);
    uart_set_pin(UART_NUM_0, 16, 15, UART_PIN_NO_CHANGE, UART_PIN_NO_CHANGE);
    uart_driver_install(UART_NUM_0, 257, 0, 0, NULL, 0);

    uart_param_config(UART_NUM_1, &uart_config);
    uart_set_pin(UART_NUM_1, 17, 14, UART_PIN_NO_CHANGE, UART_PIN_NO_CHANGE);
    uart_driver_install(UART_NUM_1, 512, 0, 0, NULL, 0);

    uart_param_config(UART_NUM_2, &uart_config);
    uart_set_pin(UART_NUM_2, 18, 13, UART_PIN_NO_CHANGE, UART_PIN_NO_CHANGE);
    uart_driver_install(UART_NUM_2, 512, 0, 0, NULL, 0);

    //Must start with the negative clock to have enough offset between the two clocks
    xTaskCreatePinnedToCore(
        sendNegativeClock,
        "!clk",
        10000,
        NULL,
        5,
        NULL,
        0);

    //Must have the positive clock next to ensure clocks are sending data before the phases are sent
    xTaskCreatePinnedToCore(
        sendClock,
        "clk",
        10000,
        NULL,
        5,
        NULL,
        0);

    //start sending phases last
    xTaskCreatePinnedToCore(
        sendData,
        "sending",
        10000,
        NULL,
        5,
        NULL,
        0);

    //Communication loop to continuously edit the send_buffer based on changed test_buffer values
    while (1)
    {

        int x[8] = {7, 1, 0, 3, 2, 4, 5, 6};

        for (int i = 0; i < 16; i++)
        {
            for (int j = 0; j < 8; j++)
            {
                send_buffer[i * 8 + j + 1] = (phase_offsets[i * 16 + x[(j / 2)]] + test_buffer[i * 16 + x[(j / 2)]]) % 80;
            }
        }
        for (int i = 0; i < 16; i++)
        {
            for (int j = 0; j < 8; j++)
            {
                send_buffer[128 + i * 8 + j + 1] = (phase_offsets[8 + i * 16 + x[(j / 2)]] + test_buffer[8 + i * 16 + x[(j / 2)]]) % 80;
            }
        }
        vTaskDelay(100 / portTICK_PERIOD_MS);
    }
    // uart_write_bytes(UART_NUM_0, send_buffer, sizeof(send_buffer));
    // uart_write_bytes(UART_NUM_1, clock_buffer, sizeof(clock_buffer));
    // uart_write_bytes(UART_NUM_2, clock_buffer, sizeof(clock_buffer));

}

//delay on the data send to separate chunks of data
void sendData()
{
    for (;;)
    {
        uart_write_bytes(UART_NUM_0, send_buffer, sizeof(send_buffer));
        vTaskDelay(30 / portTICK_PERIOD_MS);
    }
}

//no delay on the clocks to have a consistent clock signal
void sendClock()
{
    for (;;)
    {
        uart_write_bytes(UART_NUM_1, clock_buffer, sizeof(clock_buffer));
    }
}

void sendNegativeClock()
{
    for (;;)
    {
        uart_write_bytes(UART_NUM_2, clock_buffer, sizeof(clock_buffer));
    }
}
