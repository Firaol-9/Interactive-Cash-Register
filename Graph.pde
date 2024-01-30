class lineGraph{
   String Xcoordinates[];
   float Ycoordinates[];
   float X;
   float Y;
  
  
  lineGraph(String Xcoordinates[] ,float Ycoordinates[],float X, float Y) {
     this.Xcoordinates = Xcoordinates;
      this.Ycoordinates = Ycoordinates;
      this.X =X;
      this.Y =Y;
     }
  
  void draw(){
    textSize(16);
   rectMode(CORNER);
   fill(blueDark);
   rect(X,Y,945,494);
    stroke(255);
    line(X+70.5+100,Y+67.5,X+70.5+100,Y+396.5);// y axis
    // y axis hypen  
    for( int i = 0 ; i <6;i ++){
    line(X+54.5+100,Y+345.5-50*i,X+70.5+100,Y+345.5-50*i);
    }
    // y axis labels           
    float max = max(Ycoordinates);
    int minDivison= ceil (max/6);                
    String sMinDivison = str(minDivison);
    float  fx1= pow(10,sMinDivison.length());
    int x1 = int(fx1);
    fill(255);
    textAlign(RIGHT,TOP);
    for( int i = 0 ; i <6;i ++){
    text(str(x1*(i+1)),X+53.5+100,Y+335.5-50*i);
    }
    
    line(X+70.5+100,Y+396.5,X+70.5+53.5* Xcoordinates.length+100,Y+396.5);// x axis
    // x axis hyphen
    for(int i = 0; i < Xcoordinates.length; i ++){
    line(X+103+53.5*i+100,Y+396.5,X+103+53.5*i+100,Y+402.75);
    }
    // x axis labels 
    textAlign(CENTER,CENTER);
    fill(255);
    for ( int i = 0 ; i < Xcoordinates.length; i++){
    text(Xcoordinates[i],X+103+53.5*i+100,Y+417.75);
    }
    for ( int i = 0; i < Ycoordinates.length-1; i ++ )  {
    // takes y and give you the postion 
    float maxPosition = Y+67.5;
    float maximum = x1*7;
    float Yposition1 = map(Ycoordinates[i],0,maximum,Y+395.5,maxPosition);
    float Yposition2 = map(Ycoordinates[i+1],0,maximum,Y+395.5,maxPosition);
    
    // x position 
    float Xposition1 =X+103+53.5*i+100;
    float Xposition2 =X+103+53.5*(i+1)+100;
    // now let us sketch
    stroke(pink);
    strokeWeight(5);
    line (Xposition1,Yposition1,Xposition2,Yposition2);
    
  }  
  }
  
}
