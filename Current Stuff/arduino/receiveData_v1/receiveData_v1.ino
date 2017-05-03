const int ShiftPWM_latchPin = 8;

//const int ShiftPWM_dataPin = 11;
// const int ShiftPWM_clockPin = 13  ;

const bool ShiftPWM_invertOutputs = false;
const bool ShiftPWM_balanceLoad = false;

#include <ShiftPWM.h>   // include ShiftPWM.h after setting the pins!

unsigned char maxPower = 255;
unsigned char pwmFrequency = 75;

int numRegisters = 4;
int incomingByte = 0;
int data[32];  //change to

int i = 0;
void setup() {
  Serial.begin(115200);
  // Sets the number of 8-bit registers that are used.
  ShiftPWM.SetAmountOfRegisters(numRegisters);
  ShiftPWM.Start(pwmFrequency, maxPower);
}

void loop()
{
  i = 0;
  while (i < 32) {
    Serial.write(i);
    if (Serial.available() > 0) {
      incomingByte = Serial.read();
      Serial.flush();
      data[i] = incomingByte;
      i++;
    }
    //delay(2);
  }

  for (int motor = 0; motor < 32; motor++) {
    ShiftPWM.SetOne(motor, data[motor]);
  }

}








