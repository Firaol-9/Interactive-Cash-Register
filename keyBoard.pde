class keyBoardContainer {
  float startX;
  float startY;
  float gapX=15;
  float gapY= 11;
  keybuttons keys[];

  String letters = "qwertyuiopasdfghjklzxcvbnm";
  String numbers = "0123456789";

  keyBoardContainer(float x, float y ) {

    this.startX = x;
    this.startY = y;  
    keys = new keybuttons[0];
    //tKeys = new keybuttons[0];

    for ( int a = 0; a < numbers.length(); a++ ) {
      keys = (keybuttons[]) append(keys, new keybuttons (str(numbers.charAt(a)), #D34444, 48, 52));
    }
    for ( int a = 0; a < letters.length(); a++ ) {
      keys = (keybuttons[]) append(keys, new keybuttons ( str(letters.charAt(a)), #D34444, 48, 52));
    }
    keys = (keybuttons[]) append(keys, new keybuttons ( "BS", #D34444, 78, 52));
    keys = (keybuttons[]) append(keys, new keybuttons ( "SHIFT", #D34444, 78, 52));
    keys = (keybuttons[]) append(keys, new keybuttons ( " ", #D34444, 298, 52));
    keys = (keybuttons[]) append(keys, new keybuttons ( "ENTER", #D34444, 78, 52));
  }
  String getHovered () {
    for (int a =0; a < keys.length; a++) {
      if (keys[a].keyhovered ()) {
        return keys [a].label;
      }
    }
    return null;
  }

  boolean hovered () {
    return mouseX > startX-10 && mouseX < startX-10 + 650  && mouseY > startY-10 && mouseY < startY-10 + 322;
  }

  void draw() {
    fill(blueMid);
    rect(startX-10, startY-5, 635, 322,10);

    int p = 0;
    for (int r = 0; r < 2; r ++) {
      for (int c = 0; c < 10; c ++) {  
        if ( p < 20) {
          keys[p].draw (startX + 48*c + gapX*c, startY + 52*r + gapY*r);
          p++;
        }
      }
    }

    int index1 = 20;
    for ( int a = 0; a < 9; a++ ) {
      if ( index1 < 29) {
        keys[index1].draw (startX+30 + 48*a + gapX*a, startY+ 2*52+gapY*2);
      }
      index1++;
    }
    int index2 = 29;
    for ( int a = 0; a < 9; a++ ) {
      if ( index2 < 36) {
        keys[index2].draw (startX+30+ 48+gapX + 48*a + gapX*a, startY+ 3*52+gapY*3);
      }
      index2++;
    }

    keys[36].draw (startX+30+ 48*8+8*gapX, startY+ 3*52+gapY*3);
    keys[37].draw (startX, startY+ 3*52+gapY*3);
    keys[38].draw (startX+30+ 48*2+gapX*2, startY+ 4*52+gapY*4);
    keys[39].draw (startX+30+ 48*7+gapX*7, startY+ 4*52+gapY*4);
  }
}
