
import processing.serial.*;

Serial myPort;
int[] data;
int handShake = 0;
int previousHandShake=0;

void setup() {
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 115200);

  myPort.clear();
  while (handShake==0) {
    myPort.write(1);
    if (myPort.available() > 0) {
      handShake=myPort.read();
      println(handShake);
    }
  }
  data=new int[handShake];
  handShake=99;
}

void draw() {
  if (myPort.available() > 0) {
    handShake=myPort.read();
  }
  if (previousHandShake != handShake) {
    myPort.clear();
    println("handshake received"+"\t"+handShake);
    myPort.write(data[handShake]);
    previousHandShake=handShake;
  }
}