import processing.net.*; //communicate with unity
import processing.serial.*; //communicate arduino
import ddf.minim.*; //sound playing
import ddf.minim.analysis.*; //sound analyses

//Connection to Arduino & Unity
Serial myPort;
Server myServer;

// array of available songs
AudioFile[] instruments;

// array of folders, so we can change the folder dinamically
String[] folderNames;

// function to retrieve files from the data/jazz folder (change accordingly)
String[] getAudioFilesList(String folderStr) {
  java.io.File folder = new java.io.File(dataPath(folderStr));
  // return filenames in folder
  return folder.list();
}

//arrays for sending data to arduino. 
int[] sendData;
int[] newData = new int[4];
int handShake = 0;
int previousHandShake=99;

//which port we open our server for unity
int port = 5204; 

void setup() {

  myServer = new Server(this, port);

  frameRate(600); //makes this sketch run as fast as possible

  // set up which folders we add to load the songs
  folderNames = new String[]{"acdc/", "queen/", "beatles/", "bowie/", "test/"};

  // take data from server 
  Client thisClient = myServer.available();

  //wait for connection with client
  //while (thisClient == null) {
  //  delay(10);
  //  thisClient = myServer.available();
  //  println("Client unavailable"+"\t"+millis());
  //}   

  //get song number from client
  //String whatClientSaid = thisClient.readString();
  //int songNumber = Integer.parseInt(trim(whatClientSaid));
  //println(songNumber);

  int songNumber=3;

  //select corresponding song folder
  String song = folderNames[songNumber];

  // load instruments from folder into an array
  String[] files = getAudioFilesList(song);

  // Create as many instrument files as the number of audio files in the folder
  instruments = new AudioFile[files.length];

  // for the sendData array (global one), we want 4 elements for each instrument (Low, Mid, Hi, global)
  sendData = new int[files.length*4];

  // create a AudioFile for each file and put into array
  for (int i = 0; i < files.length; i++) {
    instruments[i] = new AudioFile(song + files[i]);
    print(files[i]);
  }


  // prepare all songs' FFT
  for (int i = 0; i < instruments.length; i++) {
    instruments[i].startFFT();
  }

  //delay(5000); //!we need to change this delay to sync with phone. 

  //play all instruments. 
  for (int i = 0; i < instruments.length; i++) {
    instruments[i].play();
  }

  // connect to arduino
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 115200);
  handShake=99;
}

void draw() {
  // analyze songs
  for (int i = 0; i < instruments.length; i++) {
    instruments[i].getSpectrum();
  }
  //delay(2); //some delay, otherwise things fuck up

  //format data
  for (int i = 0; i < instruments.length; i++) { //!can we do this in the class itself and save it into a global array?
    newData=instruments[i].addData(); //things we get from each instrument
    sendData[i*4+0]=newData[0]; //save it to one long array for sending 
    sendData[i*4+1]=newData[1];
    sendData[i*4+2]=newData[2];
    sendData[i*4+3]=newData[3];
  }

  //send data and wait for signal to get more
  
  for (int i=0; i<sendData.length; i++) {
    if (myPort.available() > 0) {
      handShake=myPort.read();
    }
    if (previousHandShake != handShake) {
      myPort.clear();
      println("handshake received"+"\t"+handShake+"\t"+sendData[handShake]);
      myPort.write(sendData[handShake]);
      previousHandShake=handShake;
    }
  }


  //println(sendData);
  //delay(2); //some delay, otherwise things fuck up
}