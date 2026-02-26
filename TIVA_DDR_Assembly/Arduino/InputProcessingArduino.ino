int button1 = 8;
int button2 = 9;
int button3 = 10;
int button4 = 11;
byte arbitraryCode1 = 96;
byte arbitraryCode2 = 97;
byte arbitraryCode3 = 98;
byte arbitraryCode4 = 99;
byte stopCode = 92;

void setup() {
  Serial.begin(9600);
}
 
void loop() {
  if (digitalRead(button1)) {
    Serial.write(arbitraryCode1);
    delay(500);
  }
  else if (digitalRead(button2)) {
    Serial.write(arbitraryCode2);
    delay(500);
  }
  else if (digitalRead(button3)) {
    Serial.write(arbitraryCode3);
    delay(500);
  }
  else if (digitalRead(button4)) {
    Serial.write(arbitraryCode4);
    delay(500);
  }
  else{
    Serial.write(stopCode);
    delay(500);
  }
}