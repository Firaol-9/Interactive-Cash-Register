import java.util.List;
import processing.serial.*;
Serial port;

Search search;
Fonts fonts;
Page page;
firstPage firstpage;

Table shopData, Tpassword;

Tabs categories;
CardsContainer cContainer;
CardRcontainer rContainer;
keyBoardContainer keyboard, keyboard2;
Pbuttons print, cancel, save, discard,uploadImage,Csave,Cdiscard,Cchange, SignIn, Schanges, Pdiscard, logout, yes, no, upload;
TextField tendered, change, name, code, price,Password, casherName, uploadPath;
TextField  Cname, Ccode, Cprice, Ccategory ;
DropDownMenu CaTegory, userName,rType;
Periodically period;
keyContainer kContainer;
navButtons navbuttons[];
MTable recordTable;
CTable itemTable;
userImage userimage, LuserImage;
lineGraph graph;

PImage logo, SLogo;
String shopDataPath = "data/Shop Data.csv";
String recordPath = "data/record.csv" ;
String PasswordPath= "data/Password.csv";
String parentImagePath = "data/images/";
String categoriesList [] = {"Most Ordered", "All Items"};
float total;
float tax; 
float p, w;
int summaryState;
int phase=1;
float dailySalesTotal = 0;
float dailyTaxTotal = 0;
float dailySubTotal = 0;
float monthesSalesTotal = 0;
float monthesTaxTotal = 0;
float monthesSubTotal = 0;
boolean drawn = false;
boolean Cdrawn = false;
boolean ItemDrwan = false;
boolean imageUploaded= false;
String previousCode;
String userNameList[];
int attempt=1, attempt2=1, attempt3=1;
String activeUserName= " ";
float prevX[];
float pressedX[], releasedX[];
String filteredCategory[] = { };
float monthlyRevenu [] = new float[12];
String monthes [] = {"jan","feb","mar","apr","may","jun","july","Agus","sept","oct","nov","dec"};

List <Card> allItems;

void setup () {
  size (1366, 768);

  background (0);
  navbuttons = new navButtons[0];
  navbuttons = ( navButtons[]) append( navbuttons, new  navButtons ( "Order", "data/shapes/shopping_cart.svg", 19, 219));
  navbuttons = ( navButtons[]) append( navbuttons, new  navButtons ( "Add", "data/shapes/add.svg", 19, 304));
  navbuttons = ( navButtons[]) append( navbuttons, new  navButtons ( "Items", "data/shapes/items.svg", 19, 389));
  navbuttons = ( navButtons[]) append( navbuttons, new  navButtons ( "Record", "data/shapes/record.svg", 19, 474));
  
  navbuttons[0].active =true;

  page = new Page ();

  //surface.setLocation (-3, 0);

  fonts = new Fonts ();

  shopData = loadTable (shopDataPath, "header");


  String tempList [] = shopData.getStringColumn ("Category");
  for (int a = 0; a < tempList.length; a ++) {
    if (!hasValue (categoriesList, tempList [a])) {
      categoriesList = append (categoriesList, tempList [a]);
    }
  }

  categories = new Tabs (137, 134);
  categories.addButtons (categoriesList);
  categories.activate (0);
  // for scrolling the tabs
  prevX = new float[categoriesList.length];
  pressedX = new float [categoriesList.length];
  releasedX= new float [categoriesList.length];

  String items [] = shopData.getStringColumn ("Items");
  String prices [] = shopData.getStringColumn ("Prices");
  String category [] = shopData.getStringColumn ("Category");
  String imageName [] = shopData.getStringColumn ("Image Name");
  String codes [] = shopData.getStringColumn ("Codes");

  allItems = new ArrayList <Card> ();

  cContainer = new CardsContainer (137, 219);
  for (int a = 0; a < items.length; a ++) {
    cContainer.addCard (items [a], prices [a], parentImagePath + imageName [a], category [a], codes [a]);
    allItems.add (new Card (items [a], prices [a], parentImagePath + imageName [a], "All Items", codes [a]));
  }
  cContainer.addCards (allItems, "All Items");
  addMostoreded();

  rContainer = new CardRcontainer ( 1059, 134 );

  print= new Pbuttons( "Print", 1059, 688, 209, 43.81, #147C4F);
  cancel= new Pbuttons( "X", 1286, 688, 43.81, 43.81, #FF404D);

  tendered =new TextField("Tendered", 1070.75, 161.57, 114.38, 55.43);
  tendered.value = "27";
  tendered.acceptNumbersOnly (7);

  change =new TextField("change", 1203.6, 161.57, 114.38, 55.43);

  search = new Search ("Search for items", 491, 54, 334, 43.81);

  period = new Periodically(10000);
  //port= new Serial(this, "COM9", 9600);
  //port.bufferUntil('\n');

  kContainer = new keyContainer(1061, 455);
  tendered.active = true;

  page.setOrder ();

  save = new  Pbuttons ("Save", 195, 639, 270, 50, greenMid );
  discard = new  Pbuttons ("Discard", 496, 639, 270, 50, pink);
  uploadImage = new Pbuttons("Upload Image",496,375,239,50,pink);
  name = new TextField ("Item Name", 195, 157, 540, 50);
  name.showCharacterCounter ();
  code = new TextField ("code", 195, 267, 239, 50);
  code.acceptNumbersOnly (6);
  code.showCharacterCounter ();
  price = new TextField ("price", 195, 375, 239, 50);
  price.showCharacterCounter ();
  price.acceptNumbersOnly (6);
  /// record graph setup 
  String rTypes [] = {"Graph", "Table"};
  rType = new DropDownMenu ("Type", rTypes, 1105,138.57, 192, 65);
  rType.value = "Table";
  graphdata();
  graph = new lineGraph(monthes,monthlyRevenu,144,217);
  // record table set up 
  String headerLabels [] = {"Item", "Quantity", "Price", "Category", "Date"};
  recordTable = new MTable (headerLabels, 136.87, 138.57);
  updateRecordTable ();
  keyboard = new keyBoardContainer (167, 434);
  
  for ( int  a=0; a < categoriesList.length; a++){
    String Category = categoriesList[a];
    if ( !Category.equals("All Items")) {
      if(!Category.equals("Most Ordered")){
        filteredCategory = append(filteredCategory,Category);
      }
    }
  }
    CaTegory =  new DropDownMenu ("Categories", filteredCategory, 972, 314, 331, 50);
    Ccategory =  new TextField ("Categories", 496, 267, 239, 50);
    //CaTegory =  new DropDownMenu ("Categories", filteredCategory, 496, 267, 239, 50);
    //Ccategory =  new TextField ("Categories", 972, 314, 331, 50);
   String CheaderLabels [] = {"Item", "Price","Category","Code"};
   itemTable = new CTable (CheaderLabels, 135.04, 211);
   updateItemsTable (); 
   Csave = new  Pbuttons ("Save", 972, 653, 146.03, 50, green );
   Cdiscard = new  Pbuttons ("Discard", 1149.95, 653, 153.05, 50, reddishBrown);
   Cchange = new  Pbuttons ("Change Details", 1060.97, 600, 153.05, 43.81, green);
   Cname = new TextField ("Item Name", 972, 195, 331, 50);
   Cname.showCharacterCounter ();
   Ccode = new TextField ("code", 972, 540, 331, 50);
   Ccode.acceptNumbersOnly (6);
   Ccode.showCharacterCounter ();
   Cprice = new TextField ("price", 972, 417, 331, 50);
   Cprice.showCharacterCounter ();
   Cprice.acceptNumbersOnly (6);
  logo = loadImage("data/images/logo.png");
  SLogo= loadImage("data/images/logo 2.png");
 
  firstpage= new firstPage();
  firstpage.setSignInPage();
  
  SignIn = new  Pbuttons ("Login", 96, 501, 491, 87, pink );
  
  Password =new TextField("Password", 96, 379, 491, 87);
  //Password.acceptNumbersOnly(6);
  //Password.showCharacterCounter();
  
  Tpassword = loadTable (PasswordPath, "header");
  
  userNameList = Tpassword.getStringColumn("User Name");
  userName =  new DropDownMenu ("User Name", userNameList, 96, 251, 491, 87);
  
  userimage = new userImage ( 955, 54, 44, 44);
  LuserImage = new userImage ( 1104, 181, 182, 182);
  casherName = new TextField ( "Casher's Name", 1073.67, 448, 241.191, 55.43);
  
  Schanges = new Pbuttons("Save Changes",1073,616,187,43.81, greenMid);
  Pdiscard = new Pbuttons ( "x" , 1271.77, 616, 43.81, 43.81, pink);
  logout = new Pbuttons ( "Logout", 1073.42, 670.36, 242.16, 43.81, blueDark);
  
  yes = new Pbuttons ( "Yes", 460.45, 417.96, 190.79, 38.17, greenMid);
  no = new Pbuttons ( "No", 674.52, 417.96,190.79,38.17,pink);
  
  upload= new Pbuttons ( "UP", 1272,522,43.81, 55.43, blueDark);
  
  keyboard2 = new keyBoardContainer (710, 420);
}

void draw () {
  if ( firstpage.isSignInPage()){
    signInPageDraw();
  }
 else if( firstpage.isMainPage()){
 mainPageDraw();
  }
}

void mouseReleased () {
  if ( firstpage.isSignInPage()){
    signInPageMouseReleased();
  } else if( firstpage.isMainPage()){
    mainPageMouseReleased();
  }
}
void mousePressed (MouseEvent e) {
  if( firstpage.isSignInPage()){
    SignInPageMousePressed();
    } else if ( firstpage.isMainPage()){
    for (int b = 0; b <navbuttons.length; b ++) {
      if (navbuttons[b].hovered ()) {
        navbuttons[b].active = true ;
        //activeTabIndex = b;
        for (int i = 0; i < navbuttons.length; i ++) {
          if (b != i)
            navbuttons[i].active = false;
        }
  
        break;
      }
    }
    if ( page.isOrder()) {
      pageOrderMousepressed();
    } else if ( page.isAddItem()) {
      pageAddItemMousepressed();
    } else if (page.isRecord()) {
      recordTable.mousePressed(e);
      rType.mousePressed ();
    } else if (page.isItems()){
      pageItemsMousePressd();
      itemTable.mousePressed (e);
    } mainPageMousePressed();
   }
   for( int i = 0 ; i < pressedX.length ; i ++ ) {
  pressedX[i] = mouseX;
  prevX[i] = categories.buttons.get(i).x;
  }
}


void keyPressed () {
  if ( firstpage.isSignInPage()){
    SignInPageKeyPressed();
  }else if( firstpage.isMainPage()){
    mainPageKeyPressed();
  }
}

void mouseWheel (MouseEvent e) {
  int factor = e.getCount();

  cContainer.mouseWheel (factor);
  rContainer.mouseWheel (factor);
  recordTable.mouseWheel(e);
  itemTable.mouseWheel(e);
}
void mouseDragged () {
  int hiddenTabs = categoriesList.length - 5 ;
  if (categoriesList.length > 5 && categories.hovered()){
  for( int i = 0 ; i < pressedX.length ; i ++ ){
   float max=  137+ categories.w*i + categories.gapX*i;
   float min = 137 - (categories.w *( hiddenTabs - (1*i)) +  categories.gapX * ( hiddenTabs - (1*i)));
  categories.buttons.get(i).x =  prevX[i] + (mouseX - pressedX[i]);
  categories.buttons.get(i).x = constrain(categories.buttons.get(i).x, min,max);
  }
 }
}
