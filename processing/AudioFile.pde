class AudioFile {
  private String location;
  //String dataPath = "./data/adventure/"; //<--- we should make this dependend. 
  ArrayList<FloatList> fftData;

  float specLow = 0.03; //maybe initialize this when we intilize the instance? This is looped quite often now. 
  float specMid = 0.10;
  float specHi = 0.15;

  float scoreLow = 0;
  float scoreMid = 0;
  float scoreHi = 0;
  float scoreGlobal=0;

  float oldScoreLow = scoreLow;
  float oldScoreMid = scoreMid;
  float oldScoreHi = scoreHi;

  float scoreDecreaseRate = 25;

  int[] fftValue = new int[4];
  float[] dataStore = new float[4];


  AudioPlayer audio;
  Minim minim;
  FFT fft;
  int bands = 512; //should be power of 2 (either 512 or 1024 is probably best)

  // constructor
  AudioFile(String location) {
    this.location = location;
    this.minim = new Minim(processing.this);
    this.fftData = new ArrayList<FloatList>();
  }

  // methods to use the audio file
  int startTime=millis(); //in order to not get echos
  void play() {
    int playTime=millis()-startTime;
    this.audio.play(playTime);
  }

  void startFFT() {
    this.audio = minim.loadFile(this.location, bands);
    this.fft = new FFT(this.audio.bufferSize(), this.audio.sampleRate());
  }

  void getSpectrum() {
    this.fft.forward(this.audio.mix);
  }

  //function to calculate and return 4 datapoints in song
  int[] addData() {

    oldScoreLow = scoreLow;
    oldScoreMid = scoreMid;
    oldScoreHi = scoreHi;
    scoreLow = 0;
    scoreMid = 0;
    scoreHi = 0;

    ////get the data from the fft bands
    for (int i = 0; i < fft.specSize()*specLow; i++)
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

    ////reduce scores if needed. 
    if (oldScoreLow > scoreLow) {
      scoreLow = oldScoreLow - scoreDecreaseRate;
    }
    if (oldScoreMid > scoreMid) {
      scoreMid = oldScoreMid - scoreDecreaseRate;
    }
    if (oldScoreHi > scoreHi) {
      scoreHi = oldScoreHi - scoreDecreaseRate;
    }

    ////calculate global
    scoreGlobal = (scoreLow + scoreMid + scoreHi)/3; //alse this happens quite often, get the intialization outside the loop?

    //!do we need smoothing?

    //!This and down probably could be done nicer without needing two arrays. 
    dataStore[0]=log(sqrt(scoreLow))/log(2);
    dataStore[1]=log(sqrt(scoreMid))/log(2);
    dataStore[2]=log(sqrt(scoreHi))/log(2);
    dataStore[3]=log(sqrt(scoreGlobal))/log(2);

    for (int i=0; i<dataStore.length; i++) {
      if (dataStore[i]<0) {
        dataStore[i]=0.0;
      }
      fftValue[i]=int(map(dataStore[i], 0, 6, 0, 254));
    }  

    for (int i=0; i<fftValue.length; i++) { //create threshold. Below 5 is almost nothing, so make it really nothing to make vibrations clearer. 
      if (fftValue[i]<5) {
        fftValue[i]=0;
      }
    }
    return fftValue;
  }

  // setters
  void setLocation(String location) {
    this.location = location;
  }

  // getters
  String getLocation() {
    return this.location;
  }
}