import processing.net.*;

// Library for HTTP requests: https://github.com/runemadsen/HTTP-Requests-for-Processing
import http.requests.*;

// Client clientToken; 
String data;
String newToken;

// Keys to authorize the app through Spotify
String authorizationKey = "MTJiOWUxY2E2ZDdiNDhiZjk1MmZjZjA4ZWJjYTZkMjQ6NDIwZGM4ZTNlYzgwNGZiZGFlM2NjZTY3NWRlZDcxYzU=";
String refreshToken = "AQA9Upmsi6JG-ojXRbOL6WyCeziiBFI6MJNIGWY8ghMfHgd1Grr6vrfKyFewsy_HlepC2A4cs-bc71NWUM5dUACDE_i5Q3kdpiVOZpyNwwkE_jrGTY_GKZrxBOlQGjn6q5w";

String requestSong = "https://api.spotify.com/v1/audio-features/";


void setup(){
 
  // First, request a new refreshed token
  PostRequest postToken = new PostRequest("https://accounts.spotify.com/api/token");
  
  // adding all required data and headers
  postToken.addHeader("Authorization", "Basic " + authorizationKey);
  postToken.addData("grant_type", "refresh_token");
  postToken.addData("refresh_token", refreshToken);
  
  postToken.send();
  
  println("Response Content Refresh Token: " + postToken.getContent());
  
  // Save new token for song request
  JSONObject json = parseJSONObject(postToken.getContent());
  if (json == null) {
    println("JSONObject could not be parsed");
  } else {
    newToken = json.getString("access_token");
  }
  
  ////////////////
  
  // Second, retrieve the song data
  
  GetRequest getSongData = new GetRequest(requestSong + "756CJtQRFSxEx9jV4P9hpA");
  getSongData.addHeader("Authorization", "Bearer " + newToken);
  getSongData.send();
  
  println("Response Content: " + getSongData.getContent());
  
}