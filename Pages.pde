void pageOrderDraw () {
  rectMode (CORNER);

  noStroke();
  fill (blueDeep);
 
  rect (107, 18, 916, 732, 10);// rectangle of cardsContainer
   
  cContainer.draw ();

  noStroke();
  fill ( blueDeep);
  rect (107, 18, 916, 201, 10);// the middle curtain  of cards container
  fill(blueDark);
  rect (107, 0, 916, 18, 10);// the upper curtain of the cardscontainer

  categories.draw ();
  noStroke();
  fill(blueDark);
  rect (0,130, 135, 80);// lower left side tabs curtian
  noStroke();
  fill(blueDeep);
  rect (107,130, 28, 80);// upper left tabs  curtain 
   noStroke();
  fill(blueDark);
  rect (1023,130, 343, 80);//  big right side tabs curtian
  noStroke();
  fill(blueDeep);
  rect (1018,130, 5, 80);// small right tabs  curtain 
  noStroke();
  fill(blueDark);
  rect (107, 750, 916, 768, 10);// the lower curtain of cardscontainer


  float tax=rContainer.subtotal()*0.15;
  total= tax+ rContainer.subtotal();

  summaryState = getSummaryState (); // 0: Print 1: Confirm 3: Printing
  if (summaryState == 0) {
    fill (blueDeep);
    rect (1041, 18, 307, 521, 10);// rectangle of cardRcontainer
    //cardR.draw (1059, 134);
    rContainer.draw();
    noStroke();
    fill(blueDark);
    rect (1039, 539, 307, 229);// the lower curtain of cardRcontainer

    fill( blueDeep);
    rect(1041, 18, 307, 104, 10);// the middle curtain of cardRcontainer

    fill(blueDark);
    rect(1041, 0, 307, 18);// the upper curtain of cardRcontainer

    fill( blueDeep);
    rect( 1041, 557, 307, 193, 10);// rectangle for subtotal, print, cancel and etc
    // texts on the small rectanglur container of subtotal, tax and Total
    fill(255);
    textSize(14);
    textAlign(LEFT, TOP);
    text("Subtotal", 1071, 573);
    text("Tax(15%)", 1071, 597);
    textAlign(RIGHT, TOP);
    text( nfc(rContainer.subtotal(), 2), 1270, 573);
    text(nfc(tax, 2), 1270, 597);

    stroke(#F8F8F8);
    line(1059.5, 633, 1059.5+270.81, 633);

    fill(255);
    textAlign(LEFT, TOP);
    text("Total", 1071, 650);
    textAlign(RIGHT, TOP);
    text(nfc(total, 2), 1270, 650);
    print.draw();
    cancel.draw();
  } else if ( summaryState==1) {
    fill( blueDeep);
    rect( 1041, 141, 307, 193, 10);// rectangle for subtotal, print, cancel and etc
    rect( 1041, 352, 307, 398, 10);
    rectMode(CORNER);
    fill (black, 255*0.5);
    rect (107, 18, 916, 732, 10);
    fill(255);
    textSize(14);
    textAlign(LEFT, TOP);
    text("Total", 1071, 234);
    textAlign(RIGHT, TOP);
    text(nfc(total, 2), 1329.47, 234);
    change.draw();
    tendered.draw();
    kContainer.draw();
    print.draw();
    cancel.draw();
  } else if ( summaryState==2) {
    period.patience= rContainer.cards.size()*400;
    p= map( period.elapsedTime(), 0, period.patience, 1, 100);
    w= map( period.elapsedTime(), 0, period.patience, 1, 227);

    fill (black, 255*0.5);
    rect (107, 18, 916, 732, 10);
    fill(255);
    textSize(14);
    textAlign(LEFT, TOP);
    text("Printing", 1081, 171);
    text("Items", 1081, 215);
    text("Total", 1081, 234);
    textAlign(RIGHT, TOP);
    text(str(rContainer.quantity()), 1308, 215);
    text(str(total), 1308, 234);

    fill(lightPink);
    rect(1081, 194, 227, 6, 3);
    text(nfc(p, 2)+"%", 1286+22, 171);// percentage of printed items on arduino
    fill(pink);
    rect(1081, 194, w, 6, 3);
    if ( p>99.9) {
      print.label="Print";
      print.Color= greenMid;
    }
  }
  
  if ( summaryState != 3 ){
    fill(blueDeep);
    rect(1041, 18, 307, 105, 10);
    fill(255);
    textAlign(LEFT, TOP);
    textSize(21);
    text("Ordered Items", 1059, 54);
    //fill( white);
    //line( 1059, 122, 1059+271,122);
    fill( white);
    textSize(12);
    if ( rContainer.cards.size()<2) {
      text(rContainer.cards.size()+" Item", 1059, 84);
    } else {
      text(rContainer.cards.size()+" Items", 1059, 84);
    }
  } 
  search.draw();
  if (search.active) {
    rectMode(CORNER);
    keyboard.draw();
    drawn =true;
  }
  else {
     drawn =false;
  }
    
}


void pageOrderMouseReleased () {
  if (getSummaryState()==0 && userimage.active == false) {
    rContainer.mouseReleased ();
   if (!search.active){
    cContainer.mouseReleased ();
    }
    categories.mouseReleased ();
  }
  if (cancel.hovered()) {
    if ( getSummaryState () == 0) {
      rContainer.makeEmpty();
    } else if ( getSummaryState()!=0) {
      cancel.y=688;
      print.y=688;
      print.Color= greenMid;
      print.label="Print";
    }
  }


  if (getSummaryState () == 0) { // if total is equal to zero the system should give warning or 
    if ( print.hovered()) {
      if (total!=0) {
        print.y=272;
        cancel.y=272;
        float tenderedV= kContainer.nearFifty(total);
        tendered.value = str(int(tenderedV));
        changeValue();
        print.label = "Confirm Print";
        
      }
    }
  } else if (getSummaryState()==1) {
    if (print.hovered() || kContainer.keys[13].keyhovered()) {
      if ( float(change.value)>=0) {
        period.reset();
        print.Color=fadebrown;
        cancel.y=688;
        print.y=688;
        saveFrequiency();
        saveRecord();
        thread ("punchKeys");
        addMostoreded();
       updateRecordTable ();
       graphdata();
      }
    }
  } else if ( getSummaryState()==2 && print.hovered) {
    print.label="Print";
    print.Color=greenMid;
  }

  if (kContainer.keys[11].keyhovered()) {
    tendered.value="0";
  }
  tendered.active = true;

  String keyStr = kContainer.getHovered();
  if (keyStr != null) {
    if (!tendered.value.contains (".")) {
      tendered.keyPressed (keyStr);
      change.value= str( float (tendered.value)-total);
    } else {
      if ( keyStr!="." ) {
        tendered.keyPressed (keyStr);
        changeValue();
      }
    }
  }
  for (int a=0; a< kContainer.tKeys.length; a++) {
    if ( kContainer.tKeys[a].keyhovered()) {
      tendered.value= kContainer.tKeys[a].label;
    } 
    changeValue();
  }
  if ( !search.hovered() && search.value.equals("")) {
    cContainer.addCards (allItems, "All Items");
  }
  String KeyStr = keyboard.getHovered();
  if (KeyStr != null) {
    search.keyPressed (KeyStr);
    search();
  }
    
} 

void changeValue(){
  float changeF= float(tendered.value)- total;
  String changeS= nfc( changeF, 2);
  String check="";
  if ( changeS.length() < 4){
    change.value=changeS;
  } else {
    for ( int a=0 ; a< changeS.length(); a++){
      char letter= changeS.charAt(a);
      if( letter!=','){
        check+=letter;
      } 
    } change.value=check;
  }
  
}

void pageOrderMousepressed() {
  if (search.hovered ()) {
    if (search.trailingContainerHovered) {
      cContainer.emptyCardContainer ("All Items");
      cContainer.addCards (allItems, "All Items");
    }
  } if ( getSummaryState()==0){ // to make search bar to be deactivated when confirmation bar is diplayed
    search.mousePressed();  
  }
   
}

void pageOrderKeypressed() {

  if (search.active) {
    search.keyPressed();
    search();
  }
}
void pageAddItemDraw() {
  background (blueDark);

  fill(blueDeep);
  rect (107, 18, 916, 736, 10);
  rect ( 1041, 18, 307, 736, 10);
  textFont (fonts.visby.demiBold);
  fill(255);
  textAlign(LEFT, TOP);
  textSize(43);
  text("Add Items", 440, 47);
  name.draw();
  code.draw();
  price.draw();
  uploadImage.draw();
  Ccategory.draw();
  fill(255);
  if (name.hovered() && mousePressed ) { 
    name.active = true;
  } else if ( mousePressed && !keyboard.hovered()) {
    name.active = false;
  }
  if ( code.hovered() && mousePressed ) {
    code.active = true;
  } else if ( mousePressed && !keyboard.hovered() ) {
    code.active = false;
  }
  if ( price.hovered() && mousePressed && !keyboard.hovered()) {
    price.active = true;
  } else if (  mousePressed && !keyboard.hovered()) {
    price.active = false;
  }
  if (Ccategory.hovered() && mousePressed && !keyboard.hovered()) {
   Ccategory.active = true;
  } else if (  mousePressed && !keyboard.hovered()) {
    Ccategory.active = false;
  }
  
  save.draw();
  discard.draw();
  
  if ( name.active || code.active || price.active || Ccategory.active ) {
    keyboard.draw();
    drawn = true;
  }
  else {
    drawn = false;
  }
  textSize(20);
  textAlign(LEFT,CORNER);
  text("Main Menu Preview ",1103,167);
  text("Selected Item Preview",1090,583);
  fill(#1F2029);
  rect(1080,188,243,224,10);    
  rect(1085,616,237,65,10);
  fill(blueDeep);
  rect(1097,205,210,126,10);
  rect(1094,633,48,37,10);
  if (imageUploaded){
     String imagePath = "data/images/"+ name.value+".png"; 
     PImage image;
     image = loadImage (imagePath);
    imageMode (CORNER);
    image (image,1097,205,210,126);
    image (image, 1094,633,48,37);
    fill(white);
    textSize(12);
    text(name.value,1097,361);
    fill(pink);
    text(price.value+" Birr",1097,391);
     textSize(12);
  fill(white);
  text(name.value,1153,648);
  fill(pink);
  text(price.value+" Birr",1153,665);
  }
  if (!imageUploaded){
    fill(white);
  textSize(12);
  text("Name",1097,361);
  text("Image",1175,268);
  fill(pink);
  text("Price",1097,391);
  textSize(12);
  fill(white);
  text("Name",1153,648);
  text("Image",1103,656);
  fill(pink);
  text("Price",1153,665);
  }
}

void pageAddItemMouseReleased() { 
  if ( save.hovered() && phase == 1 && drawn != true ) {
    Save();
    phase++;
  } 
  if ( discard.hovered() && drawn != true ) {
    name.value ="";
    code.value ="";
    price.value =""; 
    Ccategory.value = "";
    phase=1;
    imageUploaded= false;
  }
  if (uploadImage.hovered()&& name.value!= null){
   selectInput("Select The Image:", "fileSelected");
  }

  String keyStr = keyboard.getHovered();
  if (keyStr!= null) {
    name.keyPressed (keyStr);
    code.keyPressed (keyStr);
    price.keyPressed (keyStr);
    Ccategory.keyPressed(keyStr);
  }
  
}

void pageAddItemKeyPressed () {
  if (name.active) { 
    name.keyPressed();
  }
  if ( code.active) {
    code.keyPressed();
  }
  if ( price.active) {
    price.keyPressed();
  } if ( Ccategory.active){
    Ccategory.keyPressed();
  }
}
void pageAddItemMousepressed(){

}
void pageRecordDraw () {
  background (blueDark);
  fill(blueDeep);
  rect (107, 18, 1234, 736, 10);
  textFont (fonts.visby.demiBold);
  fill(255);
  textAlign(LEFT, TOP);
  textSize(43);
  text("Record", 440, 47);
  if ( rType.value == "Graph"){
  graph.draw();
   textSize(16);
  textAlign(LEFT, TOP);
  text(str(year()) +" Monthly Revenue", X+492, Y+680);
  }else if (rType.value == "Table"){
  fill(255);
  textSize(16);
  textAlign(LEFT, TOP);
  text("Today's", 1060, 190+100);
  text("This Month's", 1060, 374+100); 
  fill(pink);
  text("Sales Total", 1053.89, 252.67+100);
  text("Tax Total", 1053.89, 278.51+100);
  text("Sub Total", 1053.89, 304.36+100);
  text("Sales Total", 1053.89, 445.18+100);
  text("Tax Total", 1053.89, 472.03+100);
  text("Sub Total", 1053.89, 497.88+100);
  fill(255);
  text(nfc(dailySalesTotal, 2)+" Birr", 1183.66, 252.67+100);
  text(nfc(dailyTaxTotal, 2)+" Birr", 1183.66, 278.51+100);
  text(nfc(dailyTaxTotal+dailySalesTotal, 2)+" Birr", 1183.66, 304.36+100);
  text(nfc(monthesSalesTotal, 2)+" Birr", 1183.66, 445.18+100);
  text(nfc(monthesTaxTotal, 2)+" Birr", 1183.66, 472.03+100);
  text(nfc(monthesSalesTotal+monthesTaxTotal, 2)+" Birr", 1183.66, 497.88+100);
   recordTable.draw ();
  //buttom cutrain
  fill(blueDark);
  noStroke();
  rect(136, 753.55, 912, 16);
  }
  rType.draw ();
 
}

void pageItemsDraw() {
   background (blueDark);
  fill(blueDeep);
  rect (107, 18, 1234, 736, 10);
  if (!ItemDrwan){
  itemTable.draw ();
  }
  Cname.draw();
  Ccode.draw();
  Cprice.draw();
  CaTegory.draw();
  if ( Cdrawn ){
  Csave.draw();
  Cdiscard.draw();
  }
  if (!Cdrawn){
  Cchange.draw();
  }  if ( Cname.active || Ccode.active || Cprice.active) {
    keyboard.draw();
    ItemDrwan = true;
  }
  textFont (fonts.visby.demiBold);
  fill(255);
  textAlign(LEFT, TOP);
  textSize(43);
  text("Items Details", 440, 47);
  
  fill(blueDark);
  noStroke();
  rect(136, 753.55, 912, 16);
}
void pageItemsMouseReleased(){
  
 if (exits()){
 int activeRow = itemTable.getActiveIndexes()[0];
 if (!Cdrawn){
  Cname.value = itemTable.rows.get(activeRow).labels[0];
  Cprice.value= itemTable.rows.get(activeRow).labels[1];
  Ccode.value= itemTable.rows.get(activeRow).labels[3];
  CaTegory.value= itemTable.rows.get(activeRow).labels[2];
  previousCode = itemTable.rows.get(activeRow).labels[3]; 
 }
  }
  if (Csave.hovered()){
    Table table = loadTable(shopDataPath, "header");
    int cIndex = table.getColumnIndex ("Codes");
    int rIndex = table.findRowIndex (previousCode, cIndex);
     TableRow row = table.getRow (rIndex);
     row.setString ("Codes",Ccode.value);
     row.setString ("Items",Cname.value);
     row.setString ("Prices",Cprice.value);
     row.setString("Category", CaTegory.value);

     saveTable (table, shopDataPath);
     updateItemsTable () ;
     Cdrawn= false;
     Cname.active = false;
     Ccode.active = false;
     Cprice.active = false;
  } 
  
   if ( Cchange.hovered()) {
     Cname.active = true;
     Cdrawn = true; 
  } 
  if (Cdrawn){
    if (Cprice.hovered()){
      Cname.active = false;
      Cprice.active = true;
    } else{
      Cprice.active=false;
    }
    if (Ccode.hovered()){
       Cname.active = false;
      Ccode.active = true;
    } else{
      Ccode.active=false;
    } 
    if (Cname.hovered()){
      Cname.active = true;
    } if (   CaTegory.hovered()){
      Cname.active = false;
      CaTegory.active= true;
    } else {
      CaTegory.active = false;
    }
  }
  
  if(Cdiscard.hovered()){
   Cname.value="";
   Ccode.value="";
   Cprice.value ="";
   Cname.active = false;
   Cdrawn = false;
   ItemDrwan = false;
  }
 String keyStr = keyboard.getHovered();
  if (keyStr!= null) {
    Cname.keyPressed (keyStr);
    Ccode.keyPressed (keyStr);
    Cprice.keyPressed (keyStr);
  } 
}
void pageItemsMousePressd(){
  if( Cdrawn == true){
    CaTegory.mousePressed();
  }
}
void pageItemsKeyPressed (){
  if (Cname.hovered() ){ 
    Cname.keyPressed();
  }
  if ( Ccode.hovered() ){
  Ccode.keyPressed();
  }
  if ( Cprice.hovered() ){
  Cprice.keyPressed();
  }
  
}
