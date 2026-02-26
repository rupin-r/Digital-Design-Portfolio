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

#include "lwip/dns.h"
#include "lwip/netdb.h"
#include "lwip/err.h"
#include "lwip/sys.h"

#define WIFI_SSID "WaveMind"
#define WIFI_CHANNEL 1
#define STA_CONN 5
#define SERVER_PORT 50000

#define FRAME_SIZE 256

//phase offset
char phase_offsets[256] = {0, 37, 37, 76, 36, 35, 34, 128, 0, 37, 44, 32, 128, 128, 73, 0, 78, 40, 36, 78, 34, 36, 68, 128, 36, 75, 76, 77, 22, 67, 74, 128, 31, 78, 30, 31, 70, 34, 30, 128, 76, 77, 36, 68, 31, 72, 73, 128, 77, 77, 27, 74, 62, 35, 27, 73, 128, 128, 128, 128, 128, 128, 128, 128, 71, 21, 73, 73, 27, 66, 72, 128, 34, 71, 25, 68, 71, 30, 30, 34, 30, 76, 72, 66, 70, 9, 74, 33, 35, 76, 32, 28, 27, 73, 22, 128, 74, 32, 73, 71, 34, 34, 32, 23, 65, 34, 27, 69, 31, 36, 30, 30, 78, 66, 31, 32, 26, 24, 64, 128, 32, 66, 71, 32, 74, 36, 71, 128, 41, 77, 35, 69, 73, 128, 76, 34, 30, 32, 128, 32, 29, 29, 34, 34, 31, 34, 36, 38, 36, 73, 22, 68, 69, 71, 67, 74, 23, 30, 33, 34, 78, 73, 69, 69, 31, 73, 68, 73, 128, 128, 128, 128, 128, 128, 128, 128, 34, 35, 36, 128, 26, 61, 27, 24, 31, 24, 74, 36, 24, 64, 30, 36, 128, 128, 128, 128, 70, 128, 32, 128, 71, 34, 128, 128, 32, 32, 32, 76, 37, 39, 128, 71, 33, 29, 128, 128, 36, 71, 35, 33, 29, 70, 73, 36, 37, 69, 28, 71, 31, 31, 68, 29, 73, 33, 33, 36, 70, 33, 76, 27, 27, 31, 30, 32, 32, 128, 66, 77, 74, 31, 33, 35, 72, 25, 71, 33};
//the buffer to edit that should contain raw data from focal point.
char test_buffer[256] = {16, 65, 28, 64, 14, 36, 51, 58, 58, 51, 36, 14, 64, 28, 65, 16, 65, 35, 79, 36, 66, 8, 23, 31, 31, 23, 8, 66, 36, 79, 35, 65, 28, 79, 43, 0, 31, 54, 69, 76, 76, 69, 54, 31, 0, 43, 79, 28, 64, 36, 0, 38, 69, 12, 28, 35, 35, 28, 12, 69, 38, 0, 36, 64, 14, 66, 31, 69, 20, 43, 59, 67, 67, 59, 43, 20, 69, 31, 66, 14, 36, 8, 54, 12, 43, 67, 2, 10, 10, 2, 67, 43, 12, 54, 8, 36, 51, 23, 69, 28, 59, 2, 18, 26, 26, 18,  2, 59, 28, 69, 23, 51, 58, 31, 76, 35, 67, 10, 26, 34, 34, 26, 10, 67, 35, 76, 31, 58, 58, 31, 76, 35, 67, 10, 26, 34, 34, 26, 10, 67, 35, 76, 31, 58, 51, 23, 69, 28, 59, 2, 18, 26, 26, 18,  2, 59, 28, 69, 23, 51, 36, 8, 54, 12, 43, 67, 2, 10, 10, 2, 67, 43, 12, 54, 8, 36, 14, 66, 31, 69, 20, 43, 59, 67, 67, 59, 43, 20, 69, 31, 66, 14, 64, 36, 0, 38, 69, 12, 28, 35, 35, 28, 12, 69, 38, 0, 36, 64, 28, 79, 43, 0, 31, 54, 69, 76, 76, 69, 54, 31,  0, 43, 79, 28, 65, 35, 79, 36, 66, 8, 23, 31, 31, 23, 8, 66, 36, 79, 35, 65, 16, 65, 28, 64, 14, 36, 51, 58, 58, 51, 36, 14, 64, 28, 65, 16};
//the buffer that combines the phase offsets and test buffer to send over UART
char send_buffer1[257] = {126, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
char send_buffer2[257] = {126, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
//the buffer that reads from wifi and writes to test buffer
char read_buffer[512] = {128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128};
//uart clocks for the verilog code to be able to handle UART
char clock_buffer[512] = {85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85};

void sendData();

void sendClock();

void sendNegativeClock();

uart_config_t uart_config;

int lock = 0;
int mutex = 0;
int done = 0;

spi_device_handle_t spi;

//Function to initialize WiFi in AP mode
void wifi_init_softap(void)
{
    //WiFi initialization
    ESP_ERROR_CHECK(esp_netif_init());
    ESP_ERROR_CHECK(esp_event_loop_create_default());
    esp_netif_create_default_wifi_ap();
    wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
    ESP_ERROR_CHECK(esp_wifi_init(&cfg));
    
    //WiFi initialization
    wifi_config_t wifi_config = {
        .ap = {
            .ssid = WIFI_SSID,
            .ssid_len = strlen(WIFI_SSID),
            .channel = WIFI_CHANNEL,
            .max_connection = STA_CONN,
            .authmode = WIFI_AUTH_OPEN},
    };

    ESP_ERROR_CHECK(esp_wifi_set_mode(WIFI_MODE_AP));
    ESP_ERROR_CHECK(esp_wifi_set_config(WIFI_IF_AP, &wifi_config));
    ESP_ERROR_CHECK(esp_wifi_start());

    //Print AP IP
    esp_netif_t *esp_netif = esp_netif_get_handle_from_ifkey("WIFI_AP_DEF");
    if (esp_netif)
    {
        esp_netif_ip_info_t ip_info;
        ESP_ERROR_CHECK(esp_netif_get_ip_info(esp_netif, &ip_info));
        char ip_addr[128];
        strncpy(ip_addr, ipaddr_ntoa((const ip_addr_t *)&ip_info.ip), 127);
        printf("AP address is: %s\n", ip_addr);
    }
}

int send_data(int cs, char *buf)
{
    int bcount; /* counts bytes read */
    int br;     /* bytes read this pass */

    bcount = 0;
    br = 0;
    while (bcount < FRAME_SIZE*2)
    { /* loop until full buffer */
        if ((br = read(cs, buf, FRAME_SIZE*2 - bcount)) > 0)
        {
            bcount += br; /* increment byte counter */
            buf += br;    /* move buffer ptr for next read */
        }
        else if (br < 0){ /* signal an error to the caller */
            return (-1);
        }
    }

    return 0;
}

//Main application task
void app_main(void)
{
    //Initialize NVS flash
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND)
    {
        ESP_ERROR_CHECK(nvs_flash_erase());
        ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);

    //Start WiFi AP
    wifi_init_softap();

    //UART configuration
    uart_config_t uart_config = {
        .baud_rate = 115200,
        .data_bits = UART_DATA_8_BITS,
        .parity = UART_PARITY_DISABLE,
        .stop_bits = UART_STOP_BITS_1,
        .flow_ctrl = UART_HW_FLOWCTRL_DISABLE};

    //UART SHIT
    uart_param_config(UART_NUM_0, &uart_config);
    uart_set_pin(UART_NUM_0, 16, 15, UART_PIN_NO_CHANGE, UART_PIN_NO_CHANGE);
    uart_driver_install(UART_NUM_0, 257, 0, 0, NULL, 0);

    uart_param_config(UART_NUM_1, &uart_config);
    uart_set_pin(UART_NUM_1, 17, 14, UART_PIN_NO_CHANGE, UART_PIN_NO_CHANGE);
    uart_driver_install(UART_NUM_1, 512, 0, 0, NULL, 0);

    uart_param_config(UART_NUM_2, &uart_config);
    uart_set_pin(UART_NUM_2, 18, 13, UART_PIN_NO_CHANGE, UART_PIN_NO_CHANGE);
    uart_driver_install(UART_NUM_2, 512, 0, 0, NULL, 0);


    //Must have the positive clock next to ensure clocks are sending data before the phases are sent
    xTaskCreatePinnedToCore(
        sendClock,
        "clk",
        10000,
        NULL,
        5,
        NULL,
        0);

    //Must start with the negative clock to have enough offset between the two clocks
    xTaskCreatePinnedToCore(
        sendNegativeClock,
        "!clk",
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

    //Socket setup
    struct sockaddr_in server_addr;
    server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(SERVER_PORT);
    static struct sockaddr_in client_addr;
    static unsigned int socklen = sizeof(client_addr);
    int s, cs;

    while (1)
    {
        
        //Create TCP socket
        s = socket(AF_INET, SOCK_STREAM, 0);
        if (s < 0)
        {
            vTaskDelay(1000 / portTICK_PERIOD_MS);
            continue;
        }

        //Bind socket to port
        if (bind(s, (struct sockaddr *)&server_addr, sizeof(server_addr)) != 0)
        {
            close(s);
            vTaskDelay(4000 / portTICK_PERIOD_MS);
            continue;
        }

        //Listen for incoming connections
        if (listen(s, 1024) != 0)
        {
            close(s);
            vTaskDelay(4000 / portTICK_PERIOD_MS);
            continue;
        }

        //Accept incoming connections
        while (1)
        {
            cs = accept(s, (struct sockaddr *)&client_addr, &socklen);
            char addr_str[128];
            inet_ntoa_r(client_addr.sin_addr.s_addr, addr_str, sizeof(addr_str) - 1);

            //Communication loop
            while (1)
            {

                if (send_data(cs, &read_buffer) != -1) //replace buf with test_buffer
                {
                    break;
                }
                int x[8] = {7,1,0,3,2,4,5,6};

                for (int i = 0; i < 16; i++)
                {
                    for (int j = 0; j < 8; j++)
                    {
                        if(mutex == 0)
                            send_buffer2[i * 8 + j + 1] = (phase_offsets[i * 16 + x[(j / 2)]] + read_buffer[(i * 16 + x[(j / 2)]) * 2]) % 80;
                        else
                            send_buffer1[i * 8 + j + 1] = (phase_offsets[i * 16 + x[(j / 2)]] + read_buffer[(i * 16 + x[(j / 2)]) * 2]) % 80;
                    }
                }
                for (int i = 0; i < 16; i++)
                {
                    for (int j = 0; j < 8; j++)
                    {
                        if(mutex == 0)
                            send_buffer2[128 + i * 8 + j + 1] = (phase_offsets[8 + i * 16 + x[(j / 2)]] + read_buffer[(8 + i * 16 + x[(j / 2)]) * 2]) % 80;
                        else
                            send_buffer1[128 + i * 8 + j + 1] = (phase_offsets[8 + i * 16 + x[(j / 2)]] + read_buffer[(8 + i * 16 + x[(j / 2)]) * 2]) % 80;
                    }
                }

                mutex = (mutex + 1) % 2;

                printf("Received: ");
                for (int i = 0; i < 16; i++)
                {
                    for(int j = 0; j < 16; j++)
                    {
                        printf("%d\t", (uint8_t)read_buffer[(i*16 + j) * 2]);
                    }
                    printf("\n");
                }
                printf("\n");
                vTaskDelay(495 / portTICK_PERIOD_MS);
            }
            close(cs);
            vTaskDelay(500 / portTICK_PERIOD_MS);
        }
    }
}

//delay on the data send to separate chunks of data
void sendData()
{
    for(;;){
            if(mutex == 0)
                uart_write_bytes(UART_NUM_0, send_buffer1, sizeof(send_buffer1));
            else
                uart_write_bytes(UART_NUM_0, send_buffer2, sizeof(send_buffer2));
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
