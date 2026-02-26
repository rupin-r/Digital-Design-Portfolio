  /*
  * Simple ESP32 Web Server  
  *  The ESP32 Wifi is configured as Access Point.  
  *    
  */  
 #include <WiFi.h>  
   
 #define BLUE_LED  25  
 #define GREEN_LED  26  
 #define RED_LED   27  

 // Create the objects for server and client  
 WiFiServer server(80);  
 WiFiClient client;  
   
 const char* ssid   = "ESP32-AP-WebServer";// This is the SSID that ESP32 will broadcast  
 const char* password = "12345678";     // password should be atleast 8 characters to make it work  
 IPAddress ip(192, 168, 1, 1); // Define your desired static IP address
 IPAddress gateway(192, 168, 1, 1); // Define the gateway IP address
 IPAddress subnet(255, 255, 255, 0); // Define the subnet mask
 // Create the global variable  
 String http;  

   
 void setup() {  
  Serial.begin(115200);  
  pinMode(BLUE_LED, OUTPUT);  
  pinMode(GREEN_LED, OUTPUT);  
  pinMode(RED_LED, OUTPUT);  
  digitalWrite(BLUE_LED, LOW);  
  digitalWrite(GREEN_LED, LOW);  
  digitalWrite(RED_LED, LOW);  
  Serial.print("Connecting to ");  
  Serial.println(ssid);  
   
  // Create the ESP32 access point  
  /*  
   * Alternative:  
   * softAP(const char* ssid,  
   *     const char* password,  
   *     int channel,  
   *     int ssid_hidden,   
   *     int max_connection  
   *       
   *     where:  
   *      ssid - this is the SSID that will be broadcast by ESP32  
   *          maximum of 63 characters  
   *      password - this is the password to connect to ESP32  
   *          minimum of 8 characters to function  
   *          Put NULL to make it open to public  
   *      channel - wifi channels (ranging from 1 to 13)  
   *      ssid_hidden - sets the SSID as broadcast or hidden  
   *          0: broadcast SSID  
   *          1: hidden SSID,   
   *           you need to type the exact SSID name in order to connect  
   *      max_connection - maximum number of connected clients  
   *          accepts 1 to 4 only  
   *            
   */  
  WiFi.softAP(ssid, password);  
  WiFi.softAPConfig(ip, gateway, subnet);

  Serial.println( "" );  
  Serial.println( "WiFi AP is now running" );  
  Serial.println( "IP address: " );  
  Serial.println(ip);
  // Serial.println( WiFi.softAPIP() );  
   
  // Start our ESP32 server  
  server.begin();  
 }  
   
 void loop(){  
    
  if ( client = server.available() ) {  // Checks if a new client tries to connect to our server  
   Serial.println("New Client.");  
   String clientData = "";  
   while ( client.connected() ) {    // Wait until the client finish sending HTTP request  
    if ( client.available() ) {     // If there is a data,  
     char c = client.read();      //  read one character  
     http += c;            //  then parse it  
     Serial.write(c);    
     if (c == 'n') {         // If the character is carriage return,   
                      //  it means end of http request from client  
      if (clientData.length() == 0) { //  Now that the clientData is cleared,  
       sendResponse();        //    perform the necessary action    
       updateWebpage();  
       break;  
      } else {  
       clientData = "";       //  First, clear the clientData  
      }  
     } else if (c != 'r') {      // Or if the character is NOT new line  
      clientData += c;        //  store the character to the clientData variable  
     }  
    }  
   }   
   http = "";  
   client.stop();            // Disconnect the client.  
   Serial.println("Client disconnected.");  
   Serial.println("");  
  }  
 }  
   
 void sendResponse() {  
  // Send the HTTP response headers  
  client.println("HTTP/1.1 200 OK");  
  client.println("Content-type:text/html");  
  client.println("Connection: close");  
  client.println();   
 }  
   
 void updateWebpage() {  
  // In here we will display / update the webpage by sending the HTML   
  //  to the connected client  
  // In order for us to use the HTTP GET functionality,  
  //  the HTML hyperlinks or href is use in the buttons.   
  //  So that, when you press the buttons, it will send a request to the   
  //  web server with the href links by which our ESP32 web server will  
  //  be check using HTTP GET and execute the equivalent action  
    
  // Send the whole HTML  
  client.println("<html>");
  client.println("<head>");
  client.println("<title><mark class=\"search-term\">ESP32</mark> WiFi Station</title>");  // Set the title in bold
  client.println("</head>");
  client.println("<body>");

  client.println("<h1>Simple ESP32 Web Server</h1>");  // Use an <h1> tag for a top-level heading
  client.println("<p>Data Received</p>");

  client.println("</body></html>");
 }  
   

