import processing.net.*;

Client c; 
String data;

// Keys to authorize the app through Spotify
String encodedKeys = "MTJiOWUxY2E2ZDdiNDhiZjk1MmZjZjA4ZWJjYTZkMjQ6NDIwZGM4ZTNlYzgwNGZiZGFlM2NjZTY3NWRlZDcxYzU=";
String refreshToken = "AQA9Upmsi6JG-ojXRbOL6WyCeziiBFI6MJNIGWY8ghMfHgd1Grr6vrfKyFewsy_HlepC2A4cs-bc71NWUM5dUACDE_i5Q3kdpiVOZpyNwwkE_jrGTY_GKZrxBOlQGjn6q5w";

String requestSong = "https://api.spotify.com/v1/audio-features/";

void setup() { 
  size(200, 200); 
  background(50); 
  fill(200);
  c = new Client(this, "https://api.spotify.com/v1/audio-features/1zHlj4dQ8ZAtrayhuDDmkY", 80);  // Connect to server on port 80 
  c.write("GET / HTTP/1.0\n");  // Use the HTTP "GET" command to ask for a webpage
  c.write("Host: my_domain_name.com\n\n"); // Be polite and say who we are
} 

void draw() {
  if (c.available() > 0) {    // If there's incoming data from the client...
    data += c.readString();   // ...then grab it and print it 
    println(data); 
  } 
}