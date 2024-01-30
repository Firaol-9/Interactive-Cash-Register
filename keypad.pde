class keyContainer {
  float startX;
  float startY;
  float gapX=9;
  float gapY= 9;
  int nearten, nearfifty, nearhundred;
  keybuttons keys[];
  keybuttons tKeys[];

  keyContainer(float x, float y ) {

    this.startX = x;
    this.startY = y;  
    keys = new keybuttons[0];
    tKeys = new keybuttons[0];
    for ( int k=1; k<10; k++) {
      keys = (keybuttons[]) append(keys, new keybuttons ( str(k), #D34444, 60, 60));
    }

    keys = (keybuttons[]) append(keys, new keybuttons ( ".", #D34444, 60, 60));
    keys = (keybuttons[]) append(keys, new keybuttons ( "0", #D34444, 60, 60));
    keys = (keybuttons[]) append(keys, new keybuttons ( "CLR", #D34444, 60, 60));
    keys = (keybuttons[]) append(keys, new keybuttons ( "BS", #D34444, 60, 129));
    keys = (keybuttons[]) append(keys, new keybuttons ( "DONE", #147C4F, 60, 129));
    tKeys= (keybuttons[]) append(tKeys, new keybuttons ( str(nearHundred(total)),1252,374,78.27,43.81,#3A3A40));
    tKeys= (keybuttons[]) append(tKeys, new keybuttons ( str(nearFifty(total)),1156,374,78.27,43.81,#3A3A40));
    tKeys= (keybuttons[]) append(tKeys, new keybuttons ( str(nearTen(total)),1059,374,78.27,43.81,#3A3A40));
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
    
    
    return false;
  }

  void draw() {
    int p = 0;
    for (int r = 0; r < 4; r ++) {
      for (int c = 0; c < 3; c ++) {  
        if ( p < 12 ) {
          keys[p].draw (startX + 60*c + gapX*c, startY + 60*r + gapY*r);
          p++;
        }
      }
    }

    keys[12].draw(1268, 455);
    keys[13].draw(1268, 593) ;
    
    stroke(#1F2029);
    strokeWeight(5);
    line( 1061,436,1061+270.81,436);
    
    nearten= int( nearTen(total));
    nearfifty= int( nearFifty( total));
    nearhundred= int ( nearHundred(total));
    
    tKeys[0].label= str( nearhundred);
    tKeys[1].label= str( nearfifty);
    tKeys[2].label= str( nearten);
    for( int a=0; a< tKeys.length; a++){
      
      tKeys[a].draw();
     
    }
  }
  
  float nearTen(float num){
    if ( num%10 == 0 ){
      return num;
    }
    else {
      return (10 - (num%10)) + num;
    }
  }
  
 float nearFifty( float num){
    if ( num%50 == 0 ){
      return num;
    }
    else {
      return (50 - (num%50)) + num;
    }
  }
  
  float nearHundred( float num){
    if ( num%100 == 0 ){
      return num;
    }
    else {
      return (100 - (num%100)) + num;
    }
  }
}
