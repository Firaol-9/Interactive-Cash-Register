boolean showErrorPage=false;
boolean showSaveButton;

void signInPageDraw(){
  background( blueFade);
  image (SLogo, 958.83, 205.33,134.23,178.67);
  
  textFont (fonts.visby.demiBold);
  fill(255);
  textAlign(LEFT,CENTER);
  textSize(45);
  text("Gebeta Restaurant",813,430);
  textSize(25);
  text("Where taste dreams come true",838, 498.07);
  
  fill(blueDeep);
  noStroke();
  rectMode(CORNER);
  rect(0,0,683,768);
  
  fill(255);
  textAlign(LEFT,CENTER);
  textSize(60);
  text("Welcome",208,122);
  
  SignIn.draw();
  Password.draw();
  userName.draw();
  
  if ( attempt2==2){
   fill(255);
   textAlign(CENTER,CENTER);
   text("Too many attempts. You have 3 chances", 341.5, 360);
  } else if ( attempt2==3){
    fill(255);
   textAlign(CENTER,CENTER);
   text("Admin Password Required", 341.5, 360);
  }
  
  if (Password.hovered() && mousePressed ) {   
    Password.active = true;
  } else if ( mousePressed && !keyboard2.hovered()) {
    Password.active = false;
  }
 
  if( Password.active){
    noStroke();
    keyboard2.draw();
  } 
} 
void signInPageMouseReleased(){
  if( SignIn.hovered()){
    if( attempt2<=2){
      if ( attempt<5){
        if( Password.value.equals(passwordRead())){
          firstpage.setMainPage();
          attempt=0; 
          activeUserName= userName.value;
          } else{
          attempt+=1;
          }
        } else{
          attempt2+=1;
          attempt=3;
        }
      } else {
        if ( userName.value.equals("Admin")){
          if(Password.value.equals(passwordRead())){
            firstpage.setMainPage();
          }
        }
      }
  }
  String keyStr = keyboard2.getHovered();
  if (keyStr!= null) {
    Password.keyPressed (keyStr);
  } 
}
void SignInPageMousePressed(){
  userName.mousePressed();
}
void SignInPageKeyPressed(){
  if ( Password.active ){
  Password.keyPressed();
  }
}

void mainPageDraw(){
  background (blueDark);

  if (page.isOrder ()) {
    pageOrderDraw ();
  } else if ( page.isAddItem()) {
    pageAddItemDraw();
  } else if (page.isRecord ()) {
    pageRecordDraw ();
  } else if (page.isItems()){
    pageItemsDraw();
  }
   image (logo, 38, 54,32.91,43.81);
  for (int a = 0; a < navbuttons.length; a++ ) {
    navbuttons[a].draw();
  } 
  textFont (fonts.visby.demiBold);
  fill(255);
  textAlign(LEFT, TOP);
  textSize(21);
  text("Gebeta Restuarant", 143, 54);

  fill(#707070);
  textAlign(LEFT, TOP);
  textSize(12);
  text("Where taste dreams come true", 143, 84);
  
  userimage.draw();
  
  if ( getSummaryState() == 3 ){
    textFont (fonts.visby.demiBold);
    fill(0,100);
    rect( 107, 20,916,730);
    fill(blueDeep);
    rect(1041, 18, 307, 105, 10);
    fill(255);
    textAlign(LEFT, TOP);
    textSize(21);
    text("Casher's Profile", 1123, 60);
   
    
    fill( blueDeep );
    rectMode( CORNER );
    rect ( 1041, 141, 307, 609,10);
    fill( white );
    textAlign(LEFT,TOP);
    text(activeUserName, 1165, 383);
    LuserImage.draw();
    casherName.draw();
    logout.draw();
    upload.draw();
    uploadPath = new TextField ( "data/images/" + activeUserName , 1073.42, 521.83, 186.58, 55.43);
    uploadPath.draw();
    
    if ( casherName.active ==true ){
      Schanges.draw();
      Pdiscard.draw();
    }
    
    if ( casherName.active ==true || showSaveButton==true){
      Schanges.draw();
      Pdiscard.draw();
      showSaveButton = true;
    }
    
    if ( showErrorPage ==true ){
      rectMode( CORNER);
      stroke(white);
      fill( blueDeep );
      rect( 395, 246, 537, 299, 10);
      
      textFont (fonts.visby.demiBold);
      fill( white);
      textAlign(LEFT, TOP);
      textSize(21);
      text( "Are you sure do you want to log-out?", 484,306);
      
      yes.draw();
      no.draw();
      
    }
  }
  String ampm="";
  if ( hour() >= 12 && hour()<24) {
    ampm="PM";
  } else if ( hour()>=0 && hour()<12) {
    ampm="AM";
  }
  fill( white);
  textAlign(RIGHT, TOP);
  textSize(21);
  text(hour()+":"+minute()+" "+ampm, 931, 54);
  fill(darkGray);
  textSize(12);
  text( Month()+" "+day()+","+year(), 932, 84);
  
}
void mainPageMouseReleased(){
  userimage.mouseReleased();
  if ( navbuttons[0].active ) { 
    page.setOrder();
    pageOrderMouseReleased ();
  } else if ( navbuttons[3].active) {
    page.setRecord();
  } else if ( navbuttons[1].active) {
    page.setAddItem();
    pageAddItemMouseReleased();
  }  else if (navbuttons[2].active ){
    page.setItems();
    pageItemsMouseReleased();
  } 
  
  if ( logout.hovered() && showErrorPage==false){
    showErrorPage =true;
  } 
  if ( showErrorPage==true && yes.hovered()==true){
    firstpage.setSignInPage();
    showErrorPage= false;
    userimage.active=false;
  } else if ( showErrorPage == true && no.hovered()==true){
    showErrorPage = false;
  }
  if( upload.hovered() ){
   showSaveButton=true;
   selectInput("Select The Image:", "fileSelected2");
  } 
  int uIndex = Tpassword.getColumnIndex("User Name");
  int pIndex = Tpassword.findRowIndex( activeUserName, uIndex);
  TableRow row= Tpassword.getRow(pIndex);
  String UserName= "";
  if( casherName.value == activeUserName || casherName.value == null ){
    UserName= activeUserName;
  } else if (casherName.value != activeUserName){
    UserName = casherName.value;
  } 
  if(Schanges.hovered() && showSaveButton==true){
    row.setString ("User Name", UserName);
    selectInput("Select The Image:", "fileSelected2");
    row.setString("ImageName", UserName + ".png");
    saveTable (Tpassword, PasswordPath);
    activeUserName = UserName;
    showSaveButton=false;
    userNameList = Tpassword.getStringColumn("User Name");
  userName =  new DropDownMenu ("User Name", userNameList, 96, 251, 491, 87);
  } else if ( Pdiscard.hovered() && showSaveButton == true ){
    casherName.value = activeUserName;
    showSaveButton = false;
  }
  
}

void mainPageMousePressed() {
  if ( getSummaryState() == 3 ){
    casherName.mousePressed();
  }
}
void mainPageKeyPressed(){
  if ( page.isOrder()) {
    pageOrderKeypressed();
  } else if ( page.isAddItem()) {
    pageAddItemKeyPressed();
  }
  
  if ( getSummaryState() == 3 ) {
    casherName.keyPressed();
  }
}
