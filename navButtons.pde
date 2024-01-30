class navButtons {
  //int pink = 0xffF05756, lightPink = 0xffF56F6E;
  //int darkBlue = 0xff1F2029;
  int darkGrey = #323340;

   float h = 70 , w = 70 , r = 10;
   String label; 
   String shapePath; 
   float x;
   float y;
   boolean mousepressed= false;
   boolean active = false;
   PShape shape;
   
  navButtons ( String label , String shapePath , float x , float y ){
    
    this.label = label;
    this.shapePath = shapePath; 
    this.x = x ;
    this.y = y ;
    shape = loadShape (shapePath);
   
  }
   
   void draw() {
     
      if (hovered () ) {
      if (mousePressed == true) {
        fill (pink);
      } else {
        fill (pink,150);
      }
    } else {
      if (active) {
        fill (pink);
      } else {
        fill (darkGrey);
      }
    }

  
    noStroke();
    rectMode(CORNER);
    rect (x, y, w, h, r);

    textFont (fonts.visby.demiBold);
    fill (255);
    textSize( 12);
    textAlign (CENTER, CENTER);
    text (label, x + w/2, y + 41 - textDescent ()/2);
    
    shape.disableStyle();
    shapeMode (CENTER);
    fill (255);
    noStroke ();
    shape (shape, x + w /2,y + 25 ,20,20);
   }
  
  public boolean hovered () {
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }

  public boolean mousepressed() {
    if (hovered ()) {
      mousepressed= true;
    } else {
      mousepressed=false;
    }
    return mousepressed;
  }
  
}
