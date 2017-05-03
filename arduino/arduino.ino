int incomingByte = 0;
int data[] = {0, 0, 0, 0, 0};
int i = 0;

int pinGlobal = 3;
int pinVeryLow = 6;
int pinLow = 9;
int pinMid = 10;
int pinHi = 11;

void setup() {
  Serial.begin(115200);
  pinMode(9, OUTPUT);
}

void loop() {
  if (Serial.available() > 0) {
    incomingByte = Serial.read();
    data[i] = incomingByte;
    i++;
    if (i == 5) {
      i = 0;
    }
    delay(3);

    analogWrite(pinVeryLow, data[0]);
    analogWrite(pinLow, data[1]);
    analogWrite(pinMid, data[2]);
    analogWrite(pinHi, data[3]);
    analogWrite(pinGlobal, data[4]);
  } else{
    analogWrite(pinVeryLow, 0);
    analogWrite(pinLow, 0);
    analogWrite(pinMid, 0);
    analogWrite(pinHi, 0);
    analogWrite(pinGlobal, 0);
    
  }

}
