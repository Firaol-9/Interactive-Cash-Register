class CardR {
  float x, y;
  float w = 271, h = 70;
  float radius = 10;
  float cancelDiameter = 19.53;
  boolean active = false;
  String label1, label2; // Primary, Secondary, Tertiary labels
  String code;
  String category;

  int quantity = 1;

  PImage image;
  PShape Add,cancel;
  PShape minus;
  CardR (Card card) {
    label1 = card.label1;
    label2 = card.label2;

    image = card.image;

    category = card.category;
    code = card.code;
  }

  void draw (float x, float y) {
    this.x = x;
    this.y = y;

    draw ();
  }

 void draw () {
    noStroke ();
    if (hovered ()) {
      if (mousePressed) {
        fill (blueLight);
        stroke(#F05756);
      } else {
        fill (blueMid);
      }
    } else { 
      fill (blueDark);
    }
    rect (x, y, w, h, radius);

    imageMode (CORNER);
    image (image, x + 12, y + 12, 57.5, 46);
    
    textFont (fonts.visby.demiBold);

    // Label 1 text
    fill (255);
    textSize (14);
    textAlign (LEFT, TOP);
    text (label1, x + 12 * 2 + 57.5, y + 12 + 6);

    // Label 2 text
    fill (pink);
    textSize (12);
    textAlign (LEFT, TOP);
    text (label2+" Birr", x + 12*2 + 57.5, y + 40);

    // Label 3 text
    String label3 = str (quantity);
    fill (255);
    textSize (12);

   if (active){
      textAlign (CENTER, CENTER);
      text (label3, x + 225, y + h/2);
      
      rectMode (CORNER);
      // Minus
      if (minusHovered ()) {
        fill (pink);
        noStroke ();
      } else {
        stroke (pink);
        strokeWeight (1);
        noFill ();
      }
     
      minus = loadShape("data/shapes/minus_filled.svg");
      minus.disableStyle();
      shapeMode (CORNER);
      shape(minus,x + 190, y + h/2 - 20/2, 20, 20);

      // Plus
      if (plusHovered ()) {
        fill (pink);
        noStroke ();
      } else {
        stroke (pink);
        strokeWeight (1);
        noFill ();
      }
       Add = loadShape("data/shapes/add_filled.svg");
      Add.disableStyle();
      shapeMode(CORNER);
      shape (Add,x + 239, y + h/2 - 20/2, 20, 20);

      // Cancel
      cancel = loadShape("data/shapes/cancel.svg");
      cancel.disableStyle();
      shapeMode (CENTER);
      fill (pink);
      noStroke ();
      shape(cancel,x + w, y);
    }
    
  }

  void mouseReleased () {
   if ( hovered() ){
     if ( active && !minusHovered () && !plusHovered () && !cancelHovered ()){
       active = false;
     } else {
         active = true;    
     }
   }
  
    if (plusHovered ()) {
      quantity ++;
    }

    if (minusHovered()) {
      if (quantity >1) {
        quantity --;
      }
    }
  }
 

  boolean hovered () {
    return mouseX > x && mouseX < x + w + 9.8 && mouseY > y-9.8 && mouseY < y + h;
  }

  boolean minusHovered () {
    return mouseX > x + 190 && mouseX < x + 190 + 20 && mouseY > y + h/2 - 20/2 && mouseY < y + h/2 + 20/2;
  }
  boolean plusHovered () {
    return mouseX > x + 239 && mouseX < x + 239 + 20 && mouseY > y + h/2 - 20/2 && mouseY < y + h/2 + 20/2;
  }
  boolean cancelHovered () {
    return mouseX > x + w - cancelDiameter/2 && mouseX < x + w + cancelDiameter/2 && mouseY > y - cancelDiameter/2 && mouseY < y + cancelDiameter/2;
  }
}
