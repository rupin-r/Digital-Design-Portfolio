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

// Global variable for SPI
spi_device_handle_t spi;

// phase offset
char phase_offsets[256] = {0, 37, 37, 76, 36, 35, 34, 128, 0, 37, 44, 32, 128, 128, 73, 0, 78, 40, 36, 78, 34, 36, 68, 128, 36, 75, 76, 77, 22, 67, 74, 128, 31, 78, 30, 31, 70, 34, 30, 128, 76, 77, 36, 68, 31, 72, 73, 128, 77, 77, 27, 74, 62, 35, 27, 73, 128, 128, 128, 128, 128, 128, 128, 128, 71, 21, 73, 73, 27, 66, 72, 128, 34, 71, 25, 68, 71, 30, 30, 34, 30, 76, 72, 66, 70, 9, 74, 33, 35, 76, 32, 28, 27, 73, 22, 128, 74, 32, 73, 71, 34, 34, 32, 23, 65, 34, 27, 69, 31, 36, 30, 30, 78, 66, 31, 32, 26, 24, 64, 128, 32, 66, 71, 32, 74, 36, 71, 128, 41, 77, 35, 69, 73, 128, 76, 34, 30, 32, 128, 32, 29, 29, 34, 34, 31, 34, 36, 38, 36, 73, 22, 68, 69, 71, 67, 74, 23, 30, 33, 34, 78, 73, 69, 69, 31, 73, 68, 73, 128, 128, 128, 128, 128, 128, 128, 128, 34, 35, 36, 128, 26, 61, 27, 24, 31, 24, 74, 36, 24, 64, 30, 36, 128, 128, 128, 128, 70, 128, 32, 128, 71, 34, 128, 128, 32, 32, 32, 76, 37, 39, 128, 71, 33, 29, 128, 128, 36, 71, 35, 33, 29, 70, 73, 36, 37, 69, 28, 71, 31, 31, 68, 29, 73, 33, 33, 36, 70, 33, 76, 27, 27, 31, 30, 32, 32, 128, 66, 77, 74, 31, 33, 35, 72, 25, 71, 33};
char test_buffer[256] = {37, 20, 77, 43, 4, 32, 63, 9, 30, 43, 51, 52, 47, 35, 16, 70, 20, 78, 33, 3, 50, 12, 47, 75, 16, 31, 39, 40, 35, 23, 4, 58, 77, 33, 9, 63, 31, 74, 30, 59, 0, 14, 22, 24, 19, 7, 68, 41, 43, 3, 63, 38, 8, 51, 7, 35, 56, 67, 73, 75, 71, 62, 44, 19, 4, 50, 31, 8, 58, 21, 54, 76, 11, 24, 30, 30, 26, 14, 5, 68, 32, 12, 74, 51, 21, 62, 6, 31, 49, 65, 72, 74, 66, 53, 32, 8, 63, 47, 30, 7, 54, 6, 35, 62, 7, 22, 30, 31, 25, 11, 69, 40, 9, 75, 59, 35, 76, 31, 62, 12, 36, 53, 62, 63, 57, 42, 20, 70, 30, 16, 0, 56, 11, 49, 7, 36, 62, 78, 6, 8, 1, 67, 44, 14, 43, 31, 14, 67, 24, 65, 22, 53, 78, 15, 23, 25, 18, 4, 61, 31, 51, 39, 22, 73, 30, 72, 30, 62, 6, 23, 33, 34, 28, 13, 70, 40, 52, 40, 24, 75, 30, 74, 31, 63, 8, 25, 34, 36, 29, 14, 71, 41, 47, 35, 19, 71, 26, 66, 25, 57, 1, 18, 28, 29, 22, 7, 64, 34, 35, 23, 7, 62, 14, 53, 11, 42, 67, 4, 13, 14, 7, 72, 50, 20, 16, 4, 68, 44, 5, 32, 69, 20, 44, 61, 70, 71, 64, 50, 27, 77, 70, 58, 41, 19, 68, 8, 40, 70, 14, 31, 40, 41, 34, 20, 77, 47};
char send_buffer[256] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};


// Function to initialize WiFi in AP mode
void wifi_init_softap(void)
{
    // WiFi initialization
    ESP_ERROR_CHECK(esp_netif_init());
    ESP_ERROR_CHECK(esp_event_loop_create_default());
    esp_netif_create_default_wifi_ap();
    wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
    ESP_ERROR_CHECK(esp_wifi_init(&cfg));

    // WiFi initialization
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

    // Print AP IP
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
    while (bcount < FRAME_SIZE)
    { /* loop until full buffer */
        if ((br = read(cs, buf, FRAME_SIZE - bcount)) > 0)
        {
            bcount += br; /* increment byte counter */
            buf += br;    /* move buffer ptr for next read */
        }
        else if (br < 0) /* signal an error to the caller */
            return (-1);
    }

    return 0;
}

// Main application task
void app_main(void)
{
    // Initialize NVS flash
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND)
    {
        ESP_ERROR_CHECK(nvs_flash_erase());
        ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);

    // Start WiFi AP
    wifi_init_softap();

    // UART SHIT
    uart_config_t uart_config = {
        .baud_rate = 115200,
        .data_bits = UART_DATA_8_BITS,
        .parity = UART_PARITY_DISABLE,
        .stop_bits = UART_STOP_BITS_1,
        .flow_ctrl = UART_HW_FLOWCTRL_DISABLE};

    // Configure UARTs
    uart_param_config(UART_NUM_1, &uart_config);
    uart_set_pin(UART_NUM_1, 16, 17, UART_PIN_NO_CHANGE, UART_PIN_NO_CHANGE);
    uart_driver_install(UART_NUM_1, 256, 0, 0, NULL, 0);

    // Socket setup
    struct sockaddr_in server_addr;
    server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(SERVER_PORT);
    static struct sockaddr_in client_addr;
    static unsigned int socklen = sizeof(client_addr);
    int s, cs;

    while (1)
    {
        // Create TCP socket
        s = socket(AF_INET, SOCK_STREAM, 0);
        if (s < 0)
        {
            vTaskDelay(1000 / portTICK_PERIOD_MS);
            continue;
        }

        // Bind socket to port
        if (bind(s, (struct sockaddr *)&server_addr, sizeof(server_addr)) != 0)
        {
            close(s);
            vTaskDelay(4000 / portTICK_PERIOD_MS);
            continue;
        }

        // Listen for incoming connections
        if (listen(s, 1024) != 0)
        {
            close(s);
            vTaskDelay(4000 / portTICK_PERIOD_MS);
            continue;
        }

        // Accept incoming connections
        while (1)
        {
            cs = accept(s, (struct sockaddr *)&client_addr, &socklen);
            char addr_str[128];
            inet_ntoa_r(client_addr.sin_addr.s_addr, addr_str, sizeof(addr_str) - 1);

            // Communication loop
            while (1)
            {
                char buf[FRAME_SIZE];

                if (send_data(cs, buf) != -1) // replace buf with test_buffer
                {
                    break;
                }

                // uart_write_bytes(UART_NUM_1, buf, sizeof(buf));

		int x[8] = {7,1,0,3,2,4,5,6};

		for(int i = 0; i < 16; i++){
			for(int j = 0; j < 8; j++){
				send_buffer[i] = phase_offsets[i*16 + x[j]] + test_buffer[i*16 + x[j]];
			}
		}
		for(int i = 0; i < 16; i++){
			for(int j = 0; j < 8; j++){
				send_buffer[128 + i] = phase_offsets[i*16 + (x[j] + 8)] + test_buffer[i*16 + (x[j] + 8)];
			}
		}
                uart_write_bytes(UART_NUM_1, send_buffer, sizeof(send_buffer));

                // printf("Received: ");
                // for (int i = 0; i < FRAME_SIZE; i++)
                // {
                //     printf("%d", (uint8_t)buf[i]);
                // }
                // printf("\n");
            }
            close(cs);
            vTaskDelay(500 / portTICK_PERIOD_MS);
        }
    }
}
