class userImage{
  
  PImage userImage;
  boolean active = false;
  float x, y;
  int w, h;
  String userImagePath;
  
  userImage ( float x, float y, int w, int h){
    
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    
  }
  
  void draw(){
    
    int uIndex = Tpassword.getColumnIndex("User Name");
    int rIndex = Tpassword.findRowIndex(activeUserName, uIndex);
    String imageName;
    
    TableRow row= Tpassword.getRow(rIndex);
    
    imageName = row.getString("ImageName");
    userImagePath = "data/images/"+ imageName;
    userImage= loadImage( userImagePath );
    userImage.resize( w, h);
    
    // Create a new image with circular shape
  PImage circularImg = createImage(w, h, ARGB);
  
  // Iterate over each pixel of the image
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      // Calculate the distance from the pixel to the center of the image
      float distance = dist(x, y, w/2, h/2);
      
      // Check if the pixel falls within the circular shape
      if (distance < w/2) {
        // Get the color of the pixel from the rectangular image
        color pixelColor = userImage.get(x, y);
         
        // Set the color of the corresponding pixel in the circular image
        circularImg.set(x, y, pixelColor);
      }
    }
  }
  
  // Display the circular image on the screen
  image(circularImg, x, y);
  }
  
  void mouseReleased(){
    
    if ( hovered() && active == false) {
      casherName.value=activeUserName;
      active =  true;
    } else if ( hovered() && active == true ){
      active = false;
    }
    
  }
 boolean hovered(){
   return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
 }
}
