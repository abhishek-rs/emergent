import processing.net.*;
import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;


Minim minim;
AudioPlayer song;
FFT fft;

Serial myPort;
// Variables qui définissent les "zones" du spectre
// Par exemple, pour les basses, on prend seulement les premières 4% du spectre total
float specVeryLow=0.02;
float specLow = 0.10; // 3%
float specMid = 0.25;  // 12.5%
float specHi = 0.40;   // 20%

// Il reste donc 64% du spectre possible qui ne sera pas utilisé. 
// Ces valeurs sont généralement trop hautes pour l'oreille humaine de toute facon.

// Valeurs de score pour chaque zone
float scoreVeryLow=0;
float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

// Valeur précédentes, pour adoucir la reduction
float oldScoreVeryLow=scoreVeryLow;
float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;

// Valeur d'adoucissement
float scoreDecreaseRate = 25;

float[] dataStore = new float[5];
int[] data = new int[5];

void setup() {
  minim = new Minim(this);
  song = minim.loadFile("midterm_demo.mp3");
  fft = new FFT(song.bufferSize(), song.sampleRate()); 
  printArray(Serial.list());

  myPort = new Serial(this, Serial.list()[0], 115200);
  song.play(0);
}

void draw() {
  fft.forward(song.mix);
  background(scoreLow/100, scoreMid/100, scoreHi/100);
  //Calcul des "scores" (puissance) pour trois catégories de son
  //D'abord, sauvgarder les anciennes valeurs
  oldScoreVeryLow = scoreVeryLow;
  oldScoreLow = scoreLow;
  oldScoreMid = scoreMid;
  oldScoreHi = scoreHi;

  scoreVeryLow=0;
  scoreLow = 0;
  scoreMid = 0;
  scoreHi = 0;

  for (int i = 0; i < fft.specSize()*specVeryLow; i++)
  {
    scoreVeryLow += fft.getBand(i);
  }

  for (int i = (int)(fft.specSize()*specVeryLow); i < fft.specSize()*specLow; i++)
  {
    scoreLow += fft.getBand(i);
  }

  for (int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++)
  {
    scoreMid += fft.getBand(i);
  }

  for (int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++)
  {
    scoreHi += fft.getBand(i);
  }

  //Faire ralentir la descente.
  if (oldScoreVeryLow > scoreVeryLow) {
    scoreVeryLow = oldScoreVeryLow - scoreDecreaseRate;
  }
  
  if (oldScoreLow > scoreLow) {
    scoreLow = oldScoreLow - scoreDecreaseRate;
  }

  if (oldScoreMid > scoreMid) {
    scoreMid = oldScoreMid - scoreDecreaseRate;
  }

  if (oldScoreHi > scoreHi) {
    scoreHi = oldScoreHi - scoreDecreaseRate;
  }
  
  float scoreGlobal = (scoreVeryLow + scoreLow + scoreMid + scoreHi)/4;

  dataStore[0]=log(sqrt(scoreVeryLow))/log(2);
  dataStore[1]=log(sqrt(scoreLow))/log(2);
  dataStore[2]=log(sqrt(scoreMid))/log(2);
  dataStore[3]=log(sqrt(scoreHi))/log(2);
  dataStore[4]=log(sqrt(scoreGlobal))/log(2);

  for (int i=0; i<dataStore.length; i++) {
    if (dataStore[i]<0) {
      dataStore[i]=0.0;
    }
    data[i]=int(map(dataStore[i], 0, 6, 0, 254));
  }  

  println(data);

  for (int i=0; i<data.length; i++) {
    myPort.write(data[i]);
  }
}