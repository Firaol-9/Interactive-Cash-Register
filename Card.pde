class Card {
  float x, y;
  float w = 160, h = 160;
  float radius = 10;
  String label1, label2; // Primary and Secondary labels
  String code;
  String category;

  PImage image;
  
  Card () {
  }

  Card (String label1, String label2, String imagePath, String category, String code) {
    this.label1 = label1;
    this.label2 = label2;
    
    image = loadImage (imagePath);

    this.category = category;
    this.code = code;
  }

  Card (String label1, String label2, String imagePath, float x, float y) {
    this.label1 = label1;
    this.label2 = label2;

    this.x = x;
    this.y = y;

    image = loadImage (imagePath);
  }

  void draw (float x, float y) {
    this.x = x;
    this.y = y;

    draw ();
  }

  public void draw () {
    noStroke ();
    if (hovered ()) {
      if (mousePressed) {
        fill (blueLight);
      } else {
        fill (blueMid);
      }
    } else { 
      fill (blueDark);
    }
    rect (x, y, w, h, radius);

    imageMode (CORNER);
    image (image, x + 14, y + 14,132,83);

    textFont (fonts.visby.demiBold);
    fill (255);
    textSize (14);
    textAlign (LEFT, TOP);
    text (label1, x + 14, y + 14 + 79.2 + 14);

    fill (pink);
    textSize (12);
    textAlign (LEFT, BOTTOM);
    text (label2+" Birr", x + 14, y + h - 14);
  }

  void mouseReleased () {
  }

  public boolean hovered () {
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }
}
