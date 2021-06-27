/*
*  This sketch is for processing the image created by the Kinect sketch and converting it into the
*  corresponding website. It will generate and HTML document and launch it on it's first pass and the
*  document will then automatically refresh every REFRESH seconds to update to the new image as an HTML.
*/

PrintWriter output;
int count = 0;
PImage imgSaveCopy;
PImage imgSave2;
PImage blocks;
ArrayList<Element> elements = new ArrayList<Element>();
ArrayList<Element> elementsHolder = new ArrayList<Element>();

void generateWebsite(){
  
  output = createWriter("index.html"); // file created
  
  count++; // keeps track of how many times the function is being run for the launch command
  
  // all starting html tags are added
  output.println("<!DOCTYPE html>");
  output.println("<html>\n");
  output.println("<head>");
  output.println("\t<title>Kinect Generated Website</title>");
  output.println("\t<meta http-equiv=\"refresh\" content=\"" + REFRESH + "\"/>"); // adds a tag to refresh the page every 10 seconds
  output.println("</head>\n");
  output.println("<body>");
  
  
  // TEST OUTPUT
  //output.println("\t<p>Testing the HTML generation.</p>");
  //output.println("\t<p>The count is at: " + count + "</p>");
  
  processImageSave();
  // <----- content belongs here ------>
  
  
  
  // all closing tags are added
  output.println("</body>\n");
  output.println("</html>");   
  
  // forces all lines to be written and then closes the file
  output.flush();
  output.close();
  
  // opens the website for view on the first pass
  if(count == 1){
    String path = sketchPath("");  // grabs the path of the sketch
    
    //UNCOMMMENT ME
    launch(path + "index.html");   // launches at the path of the HTML file
    //UNCOMMMENT ME
  }
}

// this method sets up the image to be better detected
void processImageSave(){
  
  imgSave = loadImage("depths.png"); // ***** remove later used to test the algorithm ********
  imgSave.loadPixels(); 
  
  imgSaveCopy = loadImage("depths.png");
  imgSaveCopy.loadPixels(); 
  
  
  int threshold = 17;  // threshold for the spaces between coloured pixels
  int bleedThreshold = 3; // threshold for bleeding the colour for a better result - THIS MUST BE AT LEAST ONE LESS THAN Bthreshold
  int Bthreshold = 4;  // threshold for the spaces between the black pixels
  
  // loops through the pixels of the image within the safe zone and fills in the coloured rectangles
  for(int x = 2; x < imgSave.width - 2; x++){
    for(int y = 26; y < imgSave.height - 2; y++){
      
      
      // IDEA ONE --->
      // INCREASE EACH PIXEL SIZE - NOT GREAT
      //if (imgSave.pixels[x + y * imgSave.width] == color(255, 0, 0) && x + threshold < imgSave.width && x - threshold > 0 && y + threshold < imgSave.height && y - threshold > 0){
      //  for (int i = threshold; i > 0; i--){
      //    imgSaveCopy.pixels[x + i + y * imgSave.width] = color(255, 0, 0);
      //    imgSaveCopy.pixels[x - i + y * imgSave.width] = color(255, 0, 0);
      //    imgSaveCopy.pixels[x + (y + i) * imgSave.width] = color(255, 0, 0);
      //    imgSaveCopy.pixels[x + (y - i) * imgSave.width] = color(255, 0, 0);
      //  }
      //}
      
      ///////////////////////////////////////////////////////////////////
      
      // IDEA TWO --->
      // CHECK THRESHOLD IN EACH ROW AND COLUMN AND FILL IF ANOTHER PIXEL OR SET BLACK IF NOT
      // - BETTER BUT NOT PERFECT
      //boolean track = false;
      //if (imgSave.pixels[x + y * imgSave.width] == color(255, 0, 0)){ // checks for red pixels
      //  if (x + threshold < imgSave.width){
      //    track = false;
      //    for (int i = threshold; i > 0; i--){  // looks for neighbours
      //      if (imgSave.pixels[x + i + y * imgSave.width] == color(255, 0, 0)){
      //        for (int j = threshold; j > 0; j--){
      //          imgSaveCopy.pixels[x + j + y * imgSave.width] = color(255, 0, 0);
      //        }
      //        track = true;
      //      }
      //    }
      //    if (!track){
      //      imgSaveCopy.pixels[x + y * imgSave.width] = color(0); // sets the pixel to black because it doesn't have neighbours
      //    }
      //  }
      //  if (y + threshold < imgSave.height){
      //    track = false;
      //    for (int i = threshold; i > 0; i--){  // looks for neighbours
      //      if (imgSave.pixels[x + (y + i) * imgSave.width] == color(255, 0, 0)){
      //        for (int j = threshold; j > 0; j--){
      //          imgSaveCopy.pixels[x + (y + j) * imgSave.width] = color(255, 0, 0);
      //        }
      //        track = true;
      //      }
      //    }
      //    if (!track){
      //      imgSaveCopy.pixels[x + y * imgSave.width] = color(0); // sets the pixel to black because it doesn't have neighbours
      //    }
      //  }
      //}
      
      //else if (imgSave.pixels[x + y * imgSave.width] == color(0, 255, 0)){ // checks for green pixels
      //  if (x + threshold < imgSave.width){
      //    track = false;
      //    for (int i = threshold; i > 0; i--){  // looks for neighbours
      //      if (imgSave.pixels[x + i + y * imgSave.width] == color(0, 255, 0)){
      //        for (int j = threshold; j > 0; j--){
      //          imgSaveCopy.pixels[x + j + y * imgSave.width] = color(0, 255, 0);
      //        }
      //        track = true;
      //      }
      //    }
      //    if (!track){
      //       imgSaveCopy.pixels[x + y * imgSave.width] = color(0); // sets the pixel to black because it doesn't have neighbours
      //    }
      //  }
      //  if (y + threshold < imgSave.height){
      //    track = false;
      //    for (int i = threshold; i > 0; i--){  // looks for neighbours
      //      if (imgSave.pixels[x + (y + i) * imgSave.width] == color(0, 255, 0)){
      //        for (int j = threshold; j > 0; j--){
      //          imgSaveCopy.pixels[x + (y + j) * imgSave.width] = color(0, 255, 0);
      //        }
      //        track = true;
      //      }
      //    }
      //    if (!track){
      //       imgSaveCopy.pixels[x + y * imgSave.width] = color(0); // sets the pixel to black because it doesn't have neighbours
      //    }
      //  }
      //}
      
      //else if (imgSave.pixels[x + y * imgSave.width] == color(0, 0, 255)){ // checks for blue pixels
      //  if (x + threshold < imgSave.width){
      //    track = false;
      //    for (int i = threshold; i > 0; i--){  // looks for neighbours
      //      if (imgSave.pixels[x + i + y * imgSave.width] == color(0, 0, 255)){
      //        track = true;
      //        for (int j = threshold; j > 0; j--){
      //          imgSaveCopy.pixels[x + j + y * imgSave.width] = color(0, 0, 255);
      //        } 
      //      }
      //    }
      //    if (!track){
      //       imgSaveCopy.pixels[x + y * imgSave.width] = color(0); // sets the pixel to black because it doesn't have neighbours
      //    }
      //  }
      //  if (y + threshold < imgSave.height){
      //    track = false;
      //    for (int i = threshold; i > 0; i--){  // looks for neighbours
      //      if (imgSave.pixels[x + (y + i) * imgSave.width] == color(0, 0, 255)){
      //        for (int j = threshold; j > 0; j--){
      //          imgSaveCopy.pixels[x + (y + j) * imgSave.width] = color(0, 0, 255);
      //        }
      //        track = true;
      //      }
      //    }
      //    if (!track){
      //       imgSaveCopy.pixels[x + y * imgSave.width] = color(0); // sets the pixel to black because it doesn't have neighbours
      //    } 
      //  }
      //}
      
      ///////////////////////////////////////////////////////////////////
      
      // IDEA THREE --->
      // MOVE A SQUARE OF SIZE threshold x threshold AROUND THE IMAGE AND FILL 
      // IF ALL 4 CORNERS ARE THE SAME COLOUR
      
      // checks if all 4 corners are the same colour and not black
      if(x + threshold + bleedThreshold < imgSave.width - 2 && y + threshold + bleedThreshold < imgSave.height - 2){ // corrects loop size

        if (imgSave.pixels[x + y * imgSave.width] == imgSave.pixels[x + threshold + y * imgSave.width] && imgSave.pixels[x + y * imgSave.width] == imgSave.pixels[x + threshold + (y + threshold) * imgSave.width] && imgSave.pixels[x + y * imgSave.width] == imgSave.pixels[x + (y + threshold) * imgSave.width] && imgSave.pixels[x + y * imgSave.width] != color(0)){
          for (int i = 1; i <= threshold + bleedThreshold; i++){
            for (int j = 1; j <= threshold + bleedThreshold; j++){
              // sets all the pixels in the box to the colour of the top right pixel
              imgSaveCopy.pixels[x + i + (y + j) * imgSave.width] = imgSave.pixels[x + y * imgSave.width];
            }
          }
        }
        
      }
      
    }
  }
  imgSaveCopy.updatePixels();
  imgSaveCopy.save("imgSaveCopy.png");
  imgSave2 = loadImage("imgSaveCopy.png");
  
  
  
    // loops through the pixels of the image within the safe zone and fills in the black rectangles
  for(int x = 2; x < imgSave.width - 2; x++){
    for(int y = 26; y < imgSave.height - 2; y++){
       if(x + Bthreshold < imgSave.width - 2 && y + Bthreshold < imgSave.height - 2){ // corrects loop size

         if (imgSave2.pixels[x + y * imgSave.width] == imgSave2.pixels[x + Bthreshold + y * imgSave.width] && imgSave2.pixels[x + y * imgSave.width] == imgSave2.pixels[x + Bthreshold + (y + Bthreshold) * imgSave.width] && imgSave2.pixels[x + y * imgSave.width] == imgSave2.pixels[x + (y + Bthreshold) * imgSave.width] && imgSave2.pixels[x + y * imgSave.width] == color(0)){
           for (int i = 1; i <= Bthreshold; i++){
             for (int j = 1; j <= Bthreshold; j++){
               // sets all the pixels in the box to the colour of the top right pixel
               imgSaveCopy.pixels[x + i + (y + j) * imgSave.width] = imgSave2.pixels[x + y * imgSave.width];
             }
           }
         }
      }   
    }
  }
  
  // update image and test output to see if it works
  imgSave.updatePixels();
  imgSave.save("imgSave.png");
  imgSave2.updatePixels();
  imgSave2.save("imgSave2.png");
  imgSaveCopy.updatePixels();
  imgSaveCopy.save("imgSaveCopy.png");
  
  
  // condense the image into the one only containted in the safezone
  blocks = createImage(imgSave.width - 4, imgSave.height  - 28, RGB);
  int a = 0;
  int b = 0;
  for(int x = 2; x < imgSave.width - 2; x++){
    for(int y = 26; y < imgSave.height - 2; y++){
      blocks.pixels[a + b * blocks.width] = imgSaveCopy.pixels[x + y * imgSaveCopy.width];
      b++;
    }
    b = 0;
    a++;
  }
  blocks.updatePixels();
  blocks.save("blocksStarting.png");
  
  detectBlocks();
}

// this method pulls the elements out of the image
void detectBlocks(){
  
  int threshold = 20; // threshold for making sure the block is big enough (height and width must meet this number)
  int jump = 2; // jump size fo rchecking max size
  
  // loops through all the pixels of "blocks"
  for (int x = 0; x < blocks.width; x++){
    for(int y = 0; y < blocks.height; y++){
      
      // finds pixels that aren't the colour black
      if(blocks.pixels[x + y * blocks.width] != color(0)){
        
        // finds the biggest square that represents the image...
        int incX = jump;
        int incY = jump;
        while(x + incX < blocks.width && y + incY < blocks.height && blocks.pixels[x + y * blocks.width] == blocks.pixels[x + incX + y * blocks.width]){
          incX += jump;
          while(x + incX < blocks.width && y + incY < blocks.height && blocks.pixels[x + y * blocks.width] == blocks.pixels[x + incX + (y + incY) * blocks.width]){
            incY += jump;
          }
        }
        incX -= jump;
        incY -= jump;
        
        // must be large enough to count as an element
        if (incX >= threshold && incY >= threshold){
          String type;
          int posX = x;
          int posY = y;
          if (blocks.pixels[x + y * blocks.width] == color(255, 0, 0)){
             type = "header";
            elementsHolder.add(new Element(type, posX, posY));
          }
          else if (blocks.pixels[x + y * blocks.width] == color(0, 255, 0)){
            type = "paragraph";
            elementsHolder.add(new Element(type, posX, posY));
          }
          else{
            int hght = incY;
            int wdth = incX;
            type = "image";
            elementsHolder.add(new Element(type, wdth, hght, posX, posY));
          }
          for(int i = x; i <= x + incX; i++){
            for(int j = y; j <= y + incY; j++){
              blocks.pixels[i + j * blocks.width] = color(0);
            }
          }
        }
      }
    }
  }
  
  // combines elements that are close and similiar sized
  int alike = 2;
  for(Element e: elementsHolder){
    for(Element f: elementsHolder){
      
      // only running on images rn because of the lack of height and width of other blocks - could expand if these are added.
      if(e.type.equals(f.type) && e.type.equals("image") && e != f){  // runs if they are the same type of element but not the same element
        
          //checks if two blocks are neighbours to the east
          if(e.posX + e.wdth + alike - f.posX < alike && e.posX + e.wdth + alike - f.posX > alike && e.posY - alike <= f.posY && e.posY + e.hght + alike >= f.posY + f.hght){
            e.added = true;
            f.added = true;
            elements.add(new Element(e.type, (f.posX + f.wdth) - e.posX, e.hght, e.posX, e.posY));
          }
          // checks if two blocks are neighbours to the south
          else if(e.posY + e.hght + alike - f.posY < alike && e.posY + e.hght + alike - f.posY > alike && e.posX - alike <= f.posX && e.posX + e.wdth + alike >= f.posX + f.wdth){
            e.added = true;
            f.added = true;
            elements.add(new Element(e.type, e.wdth, (f.posY + f.hght) - e.posY, e.posX, e.posY));
          }
      }
    }
    // adds the non-image elements
    if(e.type != "image"){
      elements.add(e);
      e.added = true;
    }
  }
  
  for(Element e: elementsHolder){
    if(!e.added){
      elements.add(e); // add e if no combination and not already added
    }
  }
  elementsHolder = new ArrayList<Element>(); // emptys the elementsHolder arraylist
  
  blocks.save("blocksStep2.png"); // output at this point
  
  // sets the newly joined elements to display grey
  for(Element e: elements){
    for(int x = e.posX; x < e.posX + e.wdth;  x++){
      for(int y = e.posY; y < e.posY + e.hght; y++){
        blocks.pixels[x + y * blocks.width] = color(128, 128, 128);
      }
    }
  }
  
  
  blocks.save("blocksFinished.png");
  println(elements);
  
  buildSite();
}

// this method will add the actual body HTML to the HTML file
void buildSite(){
  
  // DEFAULT BLOCK STRINGS
  String openImageBlock = "\t<img src=\"https://picsum.photos/";
  String afterDimensionsImageBlock = "\" style=\"position: absolute; left: ";
  String afterXCorImageBlock = "px; top: ";
  String closeImageBlock = "px;\">";
   // <---- https://picsum.photos/width/height gives a random stock photo of those dimensions ----->
 
  String openParagraphBlock = "\t<p style=\"position: absolute; left: ";
  String afterXCorParagraphBlock = "px; top: ";
  String closeParagraphBlock = "px;\">This is a paragraph.</p>";
  
  
  String openHeaderBlock = "\t<h style=\"position: absolute; left: ";
  String afterXCorHeaderBlock = "px; top: ";
  String closeHeaderBlock = "px;\"><strong>This is a header.</strong></h>";
  
  float scale = 1.5; // scales the location and size of the blocks
  //int scale = 2; 
  
  for(Element e: elements){  // loops through the detected blocks in the ArrayList and writes them to HTML
    if(e.type.equals("image")){ 
      output.println(openImageBlock + scale * e.wdth + "/" + scale * e.hght + afterDimensionsImageBlock + scale * e.posX + afterXCorImageBlock + scale * e.posY + closeImageBlock);
    }
    else if (e.type.equals("paragraph")){
      output.println(openParagraphBlock + scale * e.posX + afterXCorParagraphBlock + scale * e.posY + closeParagraphBlock);
    }
    else{
      output.println(openHeaderBlock + scale * e.posX + afterXCorHeaderBlock + scale * e.posY + closeHeaderBlock);
    }
  }
  
  elements = new ArrayList<Element>(); // delete the arraylist so that the old elements are not rewritten
  
}
