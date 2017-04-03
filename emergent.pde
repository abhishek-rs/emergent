//this code will only work with an arduino attached to your computer!!! If you dont have acces to arduino, delete everything to do with serial (or comment out)
//import libraries, probably you only need to install minim. Go to sketch -> import library and add library. Search for minim
import ddf.minim.analysis.*;
import ddf.minim.*;
import processing.serial.*;

/*----------------------------------------------------------Variables for data analysis---------------------------------------------------------------------------*/
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

/*-------------------------------------------------------------Variables for data visualization------------------------------------------------------------------------*/
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

  //all setup needed for the visualization. See Visualization tab. 
  setup_viz();

  //connect with arduino commit in the myPort line if arduino is connected
  printArray(Serial.list());

   myPort = new Serial(this, Serial.list()[0], 115200);

  //all setup needed for the data analyses per channel. 
  //setupChannels();
}      

void draw() {
  //this is automatically looped.
  
  draw_viz();
  background(255);
  
  //drawDataLoc();
  analyzeSpectra(); 
  addToBuffer();

  //sendData();
  
  //monitor the speed of the program. Frames per second
  println(frameRate);
}