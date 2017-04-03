void setup_viz()
{
  // Display in 3D on the entire screen
  // Load the minimal library
  minim_viz = new Minim(this);
 
 // Load the song

  song_viz = minim_viz.loadFile("data/jazz/All.mp3");

// Create the FFT object to analyze the song
  fft_viz = new FFT(song_viz.bufferSize(), song_viz.sampleRate());
  
// One cube per frequency band
  nbCubes = (int)(fft_viz.specSize()*specHi);
  cubes = new Cube[nbCubes];
  
 // As many walls as you want
  murs = new Mur[nbMurs];

  // Create all objects
  // Create cubic objects
  //for (int i = 0; i < nbCubes; i++) {
   //cubes[i] = new Cube(); 
  //}
  
  // Create wall objects
  // Left Walls
  for (int i = 0; i < nbMurs; i+=4) {
   murs[i] = new Mur(0, height/2, 10, height); 
  }
  
  //right walls
  for (int i = 1; i < nbMurs; i+=4) {
   murs[i] = new Mur(width, height/2, 10, height); 
  }
  
  //low walls
  for (int i = 2; i < nbMurs; i+=4) {
   murs[i] = new Mur(width/2, height, width, 10); 
  }
  
  //high walls
  for (int i = 3; i < nbMurs; i+=4) {
   murs[i] = new Mur(width/2, 0, width, 10); 
  }
  
  //Black background
  background(0);
  //song_viz.mute();
  // Start the song
  song_viz.play(0);
}
 //============================================
void draw_viz()
{
  //move the song. On draw () for each "frame" of the song ...
  fft_viz.forward(song_viz.mix);
  
 // Calculation of "scores" (power) for three categories of sound
  // First, save the old values
  oldScoreLow = scoreLow;
  oldScoreMid = scoreMid;
  oldScoreHi = scoreHi;
  
  //Reset values
  scoreLow = 0;
  scoreMid = 0;
  scoreHi = 0;
 
  //Calculate the new "scores"
  for(int i = 0; i < fft_viz.specSize()*specLow; i++)
  {
    scoreLow += fft_viz.getBand(i);
  }
  
  for(int i = (int)(fft_viz.specSize()*specLow); i < fft_viz.specSize()*specMid; i++)
  {
    scoreMid += fft_viz.getBand(i);
  }
  
  for(int i = (int)(fft_viz.specSize()*specMid); i < fft_viz.specSize()*specHi; i++)
  {
    scoreHi += fft_viz.getBand(i);
  }
  
  //Slow down the descent.
  if (oldScoreLow > scoreLow) {
    scoreLow = oldScoreLow - scoreDecreaseRate;
  }
  
  if (oldScoreMid > scoreMid) {
    scoreMid = oldScoreMid - scoreDecreaseRate;
  }
  
  if (oldScoreHi > scoreHi) {
    scoreHi = oldScoreHi - scoreDecreaseRate;
  }
  
  //Volume for all frequencies at this time, with higher sounds higher.
  // This allows the animation to go faster for sounds more acute, which is more noticeable
  float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;
  
// Subtle background color
  background(scoreLow/100, scoreMid/100, scoreHi/100);
   
  //------CUBES COMMENTED OUT
// Cube for each frequency band
  //for(int i = 0; i < nbCubes; i++)
  //{
    // Value of the frequency band
    //float bandValue = fft_viz.getBand(i);
    
    
// The color is represented as red for bass, green for middle sounds and blue for highs.
    // Opacity is determined by the volume of the tape and the overall volume.
    //cubes[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  //}
  //------CUBES COMMENTED OUT
  
// Line walls, here you must keep the value of the previous band and the next one to connect them together
  float previousBandValue = fft_viz.getBand(0);
  
  //Distance between each line point, negative because on the dimension z
  float dist = -25;
  
  //Multiply the height by this constant
  float heightMult = 2;
  
  //For each band
  for(int i = 1; i < fft_viz.specSize(); i++)
  {
    //Frequency band value, the farther bands are multiplied so that they are more visible.
    float bandValue = fft_viz.getBand(i)*(1 + (i/50));
    
    //Selection of color according to the strengths of the different types of sounds
    stroke(100+scoreLow, 100+scoreMid, 100+scoreHi, 255-i);
    strokeWeight(1 + (scoreGlobal/100));
    
    //Left lower line
    line(0, height-(previousBandValue*heightMult), dist*(i-1), 0, height-(bandValue*heightMult), dist*i);
    line((previousBandValue*heightMult), height, dist*(i-1), (bandValue*heightMult), height, dist*i);
    line(0, height-(previousBandValue*heightMult), dist*(i-1), (bandValue*heightMult), height, dist*i);
    
    //left upper line
    line(0, (previousBandValue*heightMult), dist*(i-1), 0, (bandValue*heightMult), dist*i);
    line((previousBandValue*heightMult), 0, dist*(i-1), (bandValue*heightMult), 0, dist*i);
    line(0, (previousBandValue*heightMult), dist*(i-1), (bandValue*heightMult), 0, dist*i);
    
    //Right lower line
    line(width, height-(previousBandValue*heightMult), dist*(i-1), width, height-(bandValue*heightMult), dist*i);
    line(width-(previousBandValue*heightMult), height, dist*(i-1), width-(bandValue*heightMult), height, dist*i);
    line(width, height-(previousBandValue*heightMult), dist*(i-1), width-(bandValue*heightMult), height, dist*i);
    
    //Right upper line
    line(width, (previousBandValue*heightMult), dist*(i-1), width, (bandValue*heightMult), dist*i);
    line(width-(previousBandValue*heightMult), 0, dist*(i-1), width-(bandValue*heightMult), 0, dist*i);
    line(width, (previousBandValue*heightMult), dist*(i-1), width-(bandValue*heightMult), 0, dist*i);
    
    //Save the value for the next loop round
    previousBandValue = bandValue;
  }
  
  //wall rectangles
  for(int i = 0; i < nbMurs; i++)
  {
    //Each wall is assigned a band, and its force is sent to it.
    float intensity = fft_viz.getBand(i%((int)(fft_viz.specSize()*specHi)));
    murs[i].display(scoreLow, scoreMid, scoreHi, intensity, scoreGlobal);
  }
}
 //==========================================================
//Class for cubes floating in space
class Cube {
  
// Z position of "spawn" and maximum Z position
  float startingZ = -10000;
  float maxZ = 1000;
  
  //Position Values
  float x, y, z;
  float rotX, rotY, rotZ;
  float sumRotX, sumRotY, sumRotZ;
  
  //Constructor
  Cube() {
    //Show the cube at a random place
    x = random(0, width);
    y = random(0, height);
    z = random(startingZ, maxZ);
    
    //Give the cube a random rotation
    rotX = random(0, 1);
    rotY = random(0, 1);
    rotZ = random(0, 1);
  }
  
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    //Selection of the color, opacity determined by the intensity (volume of the strip)
    color displayColor = color(scoreLow*0.67, scoreMid*0.67, scoreHi*0.67, intensity*5);
    fill(displayColor, 255);
    
    //Color lines disappear with the individual intensity of the cube
    color strokeColor = color(255, 150-(20*intensity));
    stroke(strokeColor);
    strokeWeight(1 + (scoreGlobal/300));
    
    
// Creation of a transformation matrix for rotations, enlargements
    pushMatrix();
    

//Shifting (movement/removal?)
    translate(x, y, z);
    
// Calculation of the rotation according to the intensity for the cube
    sumRotX += intensity*(rotX/1000);
    sumRotY += intensity*(rotY/1000);
    sumRotZ += intensity*(rotZ/1000);
    
    //Application of rotation
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);
    
    //Creation of the box, variable size according to the intensity for the cube
    box(100+(intensity/2));
    
    //Application of the matrix
    popMatrix();
    
    //movement of Z
    z+= (1+(intensity/5)+(pow((scoreGlobal/150), 2)));
    
    //Replace the box when it is no longer visible
    if (z >= maxZ) {
      x = random(0, width);
      y = random(0, height);
      z = startingZ;
    }
  }
}


//======================================================
// Class to display the rows on the sides
class Mur {
// Minimum and maximum position of Z
  float startingZ = -10000;
  float maxZ = 50;
  
  //position values
  float x, y, z;
  float sizeX, sizeY;
  
  //Constructor
  Mur(float x, float y, float sizeX, float sizeY) {
    //Make the line appear at the specified location
    this.x = x;
    this.y = y;
// Random Depth
    this.z = random(startingZ, maxZ);  
    
    
// The size is determined because the walls on the floors have a different size than those on the sides
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }
  
//========================================================
// Display function
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    // Color determined by low, medium and high sounds
    // Opacity determined by the global volume
    color displayColor = color(scoreLow*0.67, scoreMid*0.67, scoreHi*0.67, scoreGlobal);
    
    //Make lines disappear in the distance to give an illusion of fog
    fill(displayColor, ((scoreGlobal-5)/1000)*(255+(z/25)));
    noStroke();
    
   // First band, that which moves according to the force
   // Transformation matrix
    pushMatrix();
    
    //movement
    translate(x, y, z);
    
    //enlargement
    if (intensity > 100) intensity = 100;
    scale(sizeX*(intensity/100), sizeY*(intensity/100), 20);
    
    //Creating the "box"
    box(1);
    popMatrix();
    
    //Second band, the one that is always the same size
    displayColor = color(scoreLow*0.5, scoreMid*0.5, scoreHi*0.5, scoreGlobal);
    fill(displayColor, (scoreGlobal/5000)*(255+(z/25)));
    //Transformation matrix
    pushMatrix();
    
    //movement
    translate(x, y, z);
    
    //enlargement
    scale(sizeX, sizeY, 10);
    
    //creation of box
    box(1);
    popMatrix();
    
    //Z movement
    z+= (pow((scoreGlobal/150), 2));
    if (z >= maxZ) {
      z = startingZ;  
    }
  }
}