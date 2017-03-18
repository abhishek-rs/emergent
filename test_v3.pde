//this code will only work with an arduino attached to your computer!!! If you dont have acces to arduino, delete everything to do with serial (or comment out)
//import libraries, probably you only need to install minim. Go to sketch -> import library and add library. Search for minim
import ddf.minim.analysis.*;
import ddf.minim.*;
import processing.serial.*;

//declare instance of class defined at the bottom
powerSpectrum chan1;
powerSpectrum chan2;
powerSpectrum chan3;
powerSpectrum chan4;
powerSpectrum chan5;
powerSpectrum chan6;
powerSpectrum chan7;
powerSpectrum chan8;
powerSpectrum chan9;
powerSpectrum chan10;
powerSpectrum chan11;
powerSpectrum chan12;
powerSpectrum chan13;
powerSpectrum chan14;
powerSpectrum chan15;
powerSpectrum chan16;

//create serial port
Serial myPort;

Minim minim_viz;
AudioPlayer song_viz;
FFT fft_viz;

// Variables qui définissent les "zones" du spectre
// Par exemple, pour les basses, on prend seulement les premières 4% du spectre total
float specLow = 0.03; // 3%
float specMid = 0.125;  // 12.5%
float specHi = 0.20;   // 20%

// Il reste donc 64% du spectre possible qui ne sera pas utilisé. 
// Ces valeurs sont généralement trop hautes pour l'oreille humaine de toute facon.

int[] dataBuffer = new int[256];
int[] dataLoc = {2, 4, 8, 16, 32, 64, 128, 256};


// Valeurs de score pour chaque zone
float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

// Valeur précédentes, pour adoucir la reduction
float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;

// Valeur d'adoucissement
float scoreDecreaseRate = 25;

// Cubes qui apparaissent dans l'espace
int nbCubes;
Cube[] cubes;

//Lignes qui apparaissent sur les cotés
int nbMurs = 500;
Mur[] murs;

void setup() {
  fullScreen(P3D);
  // just get the maximum framerate. 
  setup_viz();
  //screensettings
  background(255);

  //connect with arduino
  printArray(Serial.list());
 // myPort = new Serial(this, Serial.list()[0], 115200);

  ////number indicates channel, used for visualization
  chan1 = new powerSpectrum(1);
  chan2 = new powerSpectrum(2);
  chan3 = new powerSpectrum(3);
  chan4 = new powerSpectrum(4);
  chan5 = new powerSpectrum(5);
  chan6 = new powerSpectrum(6);
  chan7 = new powerSpectrum(7);
  chan8 = new powerSpectrum(8);
  chan9 = new powerSpectrum(9);
  chan10 = new powerSpectrum(10);
  chan11 = new powerSpectrum(11);
  chan12 = new powerSpectrum(12);
  chan13 = new powerSpectrum(13);
  chan14 = new powerSpectrum(14);
  chan15 = new powerSpectrum(15);
  chan16 = new powerSpectrum(16);

  ////add music to each channel. This should be in the /data folder. 
  chan1.input("/jazz/01_KickIn.mp3");
  chan2.input("/jazz/02_KickOut.mp3");
  chan3.input("/jazz/03_SnareUp.mp3");
  chan4.input("/jazz/04_SnareDown.mp3");
  chan5.input("/jazz/05_HiHat.mp3");
  chan6.input("/jazz/06_Tom1.mp3");
  chan7.input("/jazz/07_Tom2.mp3");
  chan8.input("/jazz/08_Tom3.mp3");
  chan9.input("/jazz/09_Overheads.mp3");
  chan10.input("/jazz/10_BassMic.mp3");
  chan11.input("/jazz/11_BassDI.mp3");
  chan12.input("/jazz/12_PianoMics1.mp3");
  chan13.input("/jazz/13_PianoMics2.mp3");
  chan14.input("/jazz/14_Trumpet.mp3");
  chan15.input("/jazz/15_Trombone.mp3");
  chan16.input("/jazz/16_Saxophone.mp3");

  ////start everything (including play)
  chan1.begin();
  chan2.begin();
  chan3.begin();
  chan4.begin();
  chan5.begin();
  chan6.begin();
  chan7.begin();
  chan8.begin();
  chan9.begin();
  chan10.begin();
  chan11.begin();
  chan12.begin();
  chan13.begin();
  chan14.begin();
  chan15.begin();
  chan16.begin();
}      

void draw() {
  //this is automatically looped. Tries to get to 10000x per second

  background(255); //need to draw background everytime, since that makes you have a "clean" screen. comment out if you want to see what happens without it
  draw_viz();
  
  drawDataLoc();
  //get the powerspectrum (fft) per channel
  chan1.getSpectrum();
  chan2.getSpectrum();
  chan3.getSpectrum();
  chan4.getSpectrum();
  chan5.getSpectrum();
  chan6.getSpectrum();
  chan7.getSpectrum();
  chan8.getSpectrum();
  chan9.getSpectrum();
  chan10.getSpectrum();
  chan11.getSpectrum();
  chan12.getSpectrum();
  chan13.getSpectrum();
  chan14.getSpectrum();
  chan15.getSpectrum();
  chan16.getSpectrum();

  chan1.addToBuffer();
  chan2.addToBuffer();  
  chan3.addToBuffer();
  chan4.addToBuffer();
  chan4.addToBuffer();
  chan5.addToBuffer();
  chan6.addToBuffer();
  chan7.addToBuffer();
  chan8.addToBuffer();
  chan9.addToBuffer();
  chan10.addToBuffer();
  chan11.addToBuffer();
  chan12.addToBuffer();
  chan13.addToBuffer();
  chan14.addToBuffer();
  chan15.addToBuffer();
  chan16.addToBuffer();

  //sendData();
  //monitor the speed of the program. Frames per second
  //println(frameRate);
}