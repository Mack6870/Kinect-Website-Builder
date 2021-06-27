/*
*  This code is for the CISC 325 project by Group 23.
*  Its purpose is to utilize the kinect's raw depth data to create an image with depth displayed as colour.
*  This image is then exported as a PNG to be utilized to create a website with different HTML elements in
*  their appropriate location. It is able to accomplish this with the Open Kinect Library, core Java
*  and some Processing functions. 
*/

import org.openkinect.processing.*;

// global variables
Kinect2 kinect2;
int timer1;
int timer2;
PImage img;
PImage imgSave;

final int REFRESH = 10; // variable for the refresh time of the website (this changes all places)

int seconds = REFRESH;

// thresholds for block depth
float minThresh1 = 0;
float maxThresh1 = 710;

float minThresh2 = 755;
float maxThresh2 = 827;

float minThresh3 = 826;
float maxThresh3 = 870;



void setup() {
  //size(displayWidth, displayHeight, P2D);
  size(512, 424);
  
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  //kinect2.initVideo();
  //kinect2.initIR();
  
  //intialize kinect
  kinect2.initDevice(0); //index 0
  
  img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);
  background(0);
}

void draw() {
  background(0);
  
  img.loadPixels();
  
  // for setting the threshold
  //minThresh3 = map(mouseX, 0, width, 0, 4500);
  //maxThresh3 = map(mouseY, 0, height, 0, 4500);
  
  // takes in the raw depth data from the kinect
  int depth[] = kinect2.getRawDepth();
  
  // loops through all the image depth values and sets the appropriate colours to the image in the spot the correlate.
  for (int x = 0; x < kinect2.depthWidth; x++){
    for (int y = 0; y < kinect2.depthHeight; y++){
      int offset = x + y * kinect2.depthWidth;
      int d = depth[offset];
      
      // flip y-axis for user experience 
      int holder = kinect2.depthHeight - y - 1;
      offset = x + holder * kinect2.depthWidth;
      
      // FILTERS FOR CHAIR LEGS
      int topFilter = 385; // 424
      int bottomFilter = 50; // 0
      
      // take out the y < 270 later (used for removing chair legs from image)
      if (d > minThresh1 && d < maxThresh1 && y < topFilter && y > bottomFilter){
        img.pixels[offset] = color(255, 0, 0);
      }
      else if (d > minThresh2 && d < maxThresh2 && y < topFilter && y > bottomFilter){
        img.pixels[offset] = color(0, 255, 0);
      }
      else if (d > minThresh3 && d < maxThresh3 && y < topFilter && y > bottomFilter){
        img.pixels[offset] = color(0, 0, 255);
      }
      else{
        img.pixels[offset] = color(0);
      }
      // draws white safe area border
      if(x == 1 && y < 400 && y % 5 < 4){ 
        img.pixels[offset] = color(255); 
        img.pixels[offset-1] = color(255);
      }
      if(y == 1 && x % 5 < 4){
        img.pixels[offset] = color(255);
        img.pixels[offset+kinect2.depthWidth] = color(255); 
      }
      if(x == 511 && y < 400 && y % 5 < 4){
        img.pixels[offset] = color(255); 
        img.pixels[offset-1] = color(255);
      }
      if(y == 399 && x % 5 < 4){
        img.pixels[offset] = color(255);
        img.pixels[offset+kinect2.depthWidth] = color(255); 
      }
    }
  }
  
  // updates and displays image
  img.updatePixels();
  image(img, 0, 0);
  
  //for printing thresholds
  fill(255);
  textSize(20);
  //text("Min Thresh: " + minThresh3 + "    Max Thresh: " + maxThresh3, 10, 20);
  
  
  // printing when an image will be taken
  if (millis() - timer1 >= 1000) {
    if(seconds > 1){
      seconds--;
    }
    else{
      seconds = REFRESH;
    }
    timer1 = millis();
  }
 text("The image will be converted in " + seconds + " second(s)", 10, 20); 
 
  // runs the takeImage function every REFRESH seconds
  if (millis() - timer2 >= REFRESH * 1000) {
    imgSave = img;
    takeImage();
    timer2 = millis();
  }
  
}

void takeImage(){
  println("Took an image");
  saveFrame("depths.png");
  generateWebsite();
}
