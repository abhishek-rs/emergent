import processing.net.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import http.requests.*; // Library for HTTP requests: https://github.com/runemadsen/HTTP-Requests-for-Processing

//song selection
String[][] songs = { //filename, spotifythingy
  {"../data/19 - Drink Up Me Hearties.mp3", "0HewdQ1l9bckQXPfIO3CYH"}, 
  {"../data/05 - Elements.mp3", "1jrFczYf5NysHccOQPXnNP"}, 
  {"../data/Coldplay - The Scientist .mp3", "75JFxkI2RXiU7L9VXzMkle"}, 
  {"../data/07 Snow Patrol - Just Say Yes.mp3", "6JJobJT994GijrdaiRg4aB"}, 
  {"../data/17 - Time.mp3", "6ZFbXIJkuI1dVNWvzJzown"},
  {"../data/17 - Time.mp3", "2QsynagSdAqZj3U9HgDzjD"}
};

int songID=2; //change for different songs

// Client clientToken; 
String data;
String newToken;

// Keys to authorize the app through Spotify
String authorizationKey;
String refreshToken;

String requestSong = "https://api.spotify.com/v1/audio-features/";
JSONObject json;
JSONObject jsonSong;

// Variables we're interested in saving from the JSON
float tempo;
float energy;
int musicKey;
float loudness;
int mode;
float valence;
float danceability;

//Variable for visualization
Minim minim;
AudioPlayer song;
FFT fft;

float  r = 200;//orig=200
float rad = 70;//orig=70

int bands = 2048;

float[] sum = new float[bands];
float smooth_factor = 0.2;
float scale=2;
color backgroundColor;

float i = 0;
float rotationSpeed;

//----------------//
float specLow = 0.03; // 3%
float specMid = 0.125;  // 12.5%
float specHi = 0.20;   // 20%

// Valeurs de score pour chaque zone
float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

// Valeur précédentes, pour adoucir la reduction
float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;

float scoreGlobal;
float scoreDecreaseRate = 5; //<------- not really a clue what this doest yet.

void setup() {
  fullScreen(P3D);
  frameRate(30);
  setupVisualization();
  setupSpotify();
  getSpotifyData();
  println("danceability: "+ danceability+"\t"+"tempo: " + tempo+"\t"+"energy: "+energy+"\t"+"key: "+musicKey+"\t"+"loudness: " + loudness+"\t"+"mode: "+mode+"\t"+"valence: "+valence);
  smooth_factor=energy*valence; //<------------ has influence on the smoothness of the movements
  scale=scale*energy; //<--------- has influence on the amplitude of the balls
  backgroundColor=color(255*valence, 255*valence, 255*valence);
}

void draw() {
  getScores();
  background(backgroundColor); //<---- we can change this based on something
  visualization();
}