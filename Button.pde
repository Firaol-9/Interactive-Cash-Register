class Button {
  int pink = 0xffF05756, lightPink = 0xffF56F6E;
  int darkBlue = 0xff1F2029;

  float x = 186, y = 105;
  float w = 160, h = 70, r = 5;

  boolean active = false;

  String label = "Button";
  boolean mousepressed= false;

  Button (String label, float x, float y) {
    this.label = label;
    this.x = x;
    this.y = y;
  }

  void draw () {
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h && categories.hovered()) {
      if (mousePressed == true) {
        fill (pink, 255 * 0.25);
      } else {
        fill (lightPink, 255 * 0.25);
      }
    } else {
      if (active) {
        fill (pink, 255 * 0.25);
      } else {
        fill (darkBlue);
      }
    }

    if (active) {
      strokeWeight (2);
    } else {
      strokeWeight (1);
    }
    stroke (pink);
    rect (x, y, w, h, r);

    textFont (fonts.visby.demiBold);
    fill (255);
    textSize( 16);
    textAlign (CENTER, CENTER);
    text (label, x + w/2, y + h/2 - textDescent ()/2);
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
