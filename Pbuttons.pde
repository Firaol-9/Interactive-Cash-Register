class Pbuttons {
  color pink = #F05756, lightPink = #F56F6E;
  color darkBlue = #1F2029;

  float x , y , r=5;
  float w , h ;
  color Color;
  boolean hovered= hovered();

  boolean active = false;
  
  String label = "Button";
  
  Pbuttons (String label, float x, float y, float w, float h, color Color) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.Color= Color;
    
  }

  void draw () {
    if (hovered()) {
      if (mousePressed == true) {
        fill (Color,80);
      } else {
        fill (Color,140);
      }
    } else {
        fill (Color);
    }
    noStroke();
    rect (x, y, w, h,r);

    textFont (fonts.roboto.medium);
    fill (255);
    textSize(16);
    textAlign (CENTER, CENTER);
    text (label, x + w/2, y + h/2 - textDescent ()/2);
  }

  public boolean hovered () {
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }
}
