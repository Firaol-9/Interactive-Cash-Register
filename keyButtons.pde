class keybuttons {

  color pink = #F05756, lightPink = #F56F6E;
  color darkBlue = #1F2029;

  float x, y, r=5;
  float w, h ;
  color Color;

  boolean active = false;

  String label = "Button";

  keybuttons (String label, float x, float y, float w, float h, color Color) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.Color= Color;
  }
  keybuttons (String label, color Color, float w, float h) {
    this.label = label;
    this.h = h;
    this.w = w;
    this.Color= Color;
  }
  void draw () {
    draw (x, y);
  }


  void draw (float x, float y) {
    this.x = x;
    this.y = y;
    if (keyhovered()) {
      fill(Color,100);
    } else {
      fill (Color);
    }

    noStroke();
    rect (x, y, w, h, r);
    
    textFont (fonts.roboto.medium);

    fill (255);
    textSize(20);
    textAlign (CENTER, CENTER);
    text (label, x + w/2, y + h/2 - textDescent ()/2);
  }  
  //void mouseReleased() {
  //  if ( keyhovered()) {
  //    println(label);
  //  }
  //}

  boolean  keyhovered () {
    
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }
} 
