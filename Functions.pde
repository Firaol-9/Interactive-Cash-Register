void punchKeys () {
  int size= rContainer.cards.size();
  String CodeSent="";
  if ( size==1) {
    CodeSent= rContainer.cards.get(0).code+"*"+rContainer.cards.get(0).quantity+"*!";
  } else {
    for ( int a=0; a<rContainer.cards.size()-1; a++) {
      CodeSent += rContainer.cards.get(a).code+"*"+rContainer.cards.get(a).quantity+"*";
    } 
    CodeSent+=rContainer.cards.get(size-1).code+"*"+rContainer.cards.get(size-1).quantity+"*!";
  } 
  println( CodeSent);
  for ( int a=0; a< CodeSent.length(); a++) { // if the buton confirm print is pressed sents the code of each cards in cardR container with their respective quantities
    char c= CodeSent.charAt(a);
    if ( c=='0') {
      port.write (2+ "\n");
    } else if ( c=='1') {
      port.write ( 3+ "\n");
    } else if ( c=='2') {
      port.write ( 4+ "\n");
    } else if ( c=='3') {
      port.write ( 5+ "\n");
    } else if ( c=='4') {
      port.write ( 6+ "\n");
    } else if ( c=='5') {
      port.write ( 7+ "\n");
    } else if ( c=='6') {
      port.write ( 8+ "\n");
    } else if ( c=='7') {
      port.write ( 9+ "\n");
    } else if ( c=='8') {
      port.write ( 10+ "\n");
    } else if ( c=='9') {
      port.write ( 11+ "\n");
    } else if ( c=='-') {
      port.write ( 12+ "\n");
    } else if ( c=='+') {
      port.write ( "A2"+ "\n");
    } else if ( c=='*') {
      port.write ( "A0" + "\n");
    } else if ( c=='!') {
      port.write ( "A1" + "\n");
    }
    delay(102);
  }
}
void saveFrequiency() {
  for ( int a=0; a< rContainer.cards.size(); a++) {
    String itemCode =  rContainer.cards.get(a).code;
    int quantity = rContainer.cards.get(a).quantity;

    Table table = loadTable (shopDataPath, "header");

    int cIndex = table.getColumnIndex ("Codes");
    int rIndex = table.findRowIndex (itemCode, cIndex);

    TableRow row = table.getRow (rIndex);// gets everything in the row, and if it's given a column it gives the item under that column 
    String frequencyStr = row.getString ("Frequency");
    int frequency = int (frequencyStr) + quantity;
    frequencyStr = str (frequency);

    row.setString ("Frequency", frequencyStr);

    saveTable (table, shopDataPath);
  }
}
void saveRecord() {

  for (int a=0; a < rContainer.cards.size(); a++) {
    String Rcode =  rContainer.cards.get(a).code + str(day())+str(month())+str(year());
    int quantity = rContainer.cards.get(a).quantity;
    String category =  rContainer.cards.get(a).category;
    String price =  rContainer.cards.get(a).label2;
    String itemName =  rContainer.cards.get(a).label1;
    Table table = loadTable (recordPath, "header");
    int lastRow = table.getRowCount(); 

    // if row row counnt is = 0 the save if if not check it 
    TableRow row = table.getRow (lastRow);// gets everything in the row, and if it's given a column it gives the item under that column 
    String codesStr [] = table.getStringColumn ("Record Codes");
    ArrayList<String> words = new ArrayList();
    for (int p = 0; p< codesStr.length; p ++) {
      words.add (codesStr[p]);
    }
    if (words.contains(Rcode)) {
      int cIndex = table.getColumnIndex ("Record Codes");
      int rIndex = table.findRowIndex (Rcode, cIndex);
      TableRow row2 = table.getRow (rIndex);
      String quantitystr = row2.getString ("Quantity");
      int Quantity = int (quantitystr) + quantity;
      quantitystr = str (Quantity);
      row2.setString ("Quantity", quantitystr);
      saveTable (table, recordPath);
    } else {
      row.setString ("Item", itemName);
      row.setString ("Record Codes", Rcode);
      row.setString ("Category", category);
      row.setString ("Price", price);
      row.setString ("Quantity", str(quantity));
      row.setString ("Day", str( day()));
      row.setString ("Month", str(month()));
      row.setString ("Year", str(year()));
      saveTable (table, recordPath);
    }
  }
}

void addMostoreded() {  

  Table table = loadTable (shopDataPath, "header");
  String codesStr [] = table.getStringColumn ("Codes");
  String frequenciesStr [] = table.getStringColumn ("Frequency");
  IntDict codeFreq = new IntDict ();
  for (int a = 0; a < codesStr.length; a ++) {
    codeFreq.set (codesStr [a], int (frequenciesStr [a]));
  }
  codeFreq.sortValuesReverse ();

  String codes [] = codeFreq.keyArray ();
  int frequencies [] = codeFreq.valueArray ();

  cContainer.emptyCardContainer ("Most Ordered");

  for (int a = 0; a < codes.length; a ++ ) { 
    String itemCode = codes[a];
    int cIndex = table.getColumnIndex ("Codes");
    int rIndex = table.findRowIndex (itemCode, cIndex);
    TableRow row = table.getRow (rIndex);
    String item = row.getString ("Items");
    String  price = row.getString ("Prices");
    String image = row.getString ("Image Name");

    if ( int (frequencies [a] ) > 10 ) {  // adds to most orderd if the frequency is greater than 10
      cContainer.addCard (item, price, parentImagePath +image, "Most Ordered", codes[a]);
    }
  }
}
void search() {
  FloatDict SimilarItems = new FloatDict();
  Table table = loadTable(shopDataPath, "header");
  String items [] = table.getStringColumn("Items");
  String codes [] = table.getStringColumn("Codes");
  categories.activate (1);
  cContainer.emptyCardContainer ("All Items");
  for ( int a = 0; a < items.length; a++ ) {
    char fIndex= items[a].charAt(0);
    char sIndex= ' ';
    String findex= str(fIndex).toLowerCase();
    fIndex= findex.charAt(0);
    if ( search.value.length()>0) {
      sIndex= search.value.charAt(0);
    }
    float  SimilarityValue = similarity( items[a], search.value);
    if (  SimilarityValue > 0.5  || fIndex== sIndex) {
      SimilarItems.set(codes[a], SimilarityValue);
    }
  }
  SimilarItems.sortValuesReverse();
  String Codes [] = SimilarItems.keyArray ();
  for (int a = 0; a < Codes.length; a ++ ) { 
    String itemCode = Codes[a];
    int cIndex = table.getColumnIndex ("Codes");
    int rIndex = table.findRowIndex (itemCode, cIndex);
    TableRow row = table.getRow (rIndex);
    String item = row.getString ("Items");
    String  price = row.getString ("Prices");
    String image = row.getString ("Image Name");
    cContainer.addCard (item, price, parentImagePath +image, "All Items", codes[a]);
  }
}

String Month() {
  String month;
  if ( month()==1) {
    month= "Jan";
  } else if ( month()==2) {
    month= "Feb";
  } else if ( month()==3) {
    month= "Mar";
  } else if ( month()==4) {
    month= "Apr";
  } else if ( month()==5) {
    month= "May";
  } else if ( month()==6) {
    month= "Jun";
  } else if ( month()==7) {
    month= "Jul";
  } else if ( month()==8) {
    month= "Aug";
  } else if ( month()==9) {
    month= "Sept";
  } else if ( month()==10) {
    month= "Oct";
  } else if ( month()==11) {
    month= "Nov";
  } else {
    month= "Dec";
  } 
  return month;
}

int getSummaryState () {
  if (print.label.equals ("Print") && userimage.active == false) {
    return 0;
  } else if ( print.label.equals("Confirm Print")  && userimage.active == false) {
    if (  print.Color==greenMid) {
      return 1;
    }  
  } else if ( userimage.active == true ){
      return 3; 
    }
  return 2;
}

boolean hasValue (String list [], String element) {
  for (int a = 0; a < list.length; a ++) {
    if (element.equals (list [a])) {
      return true;
    }
  }

  return false;
}

int getCategoryIndex (String category) {
  for (int a = 0; a < categoriesList.length; a ++) {
    if (categoriesList [a].equals (category)) {
      return a;
    }
  }

  return -1;
}

void Save () {
  Table table = loadTable (shopDataPath, "header");
  int lastRow = table.getRowCount();
  TableRow row = table.getRow (lastRow);
  row.setString ("Items", name.value); 
  row.setString ("Codes", code.value);
  row.setString ("Category", Ccategory.value);
  row.setString ("Prices", price.value);
  row.setString("Image Name",name.value+".png");
  saveTable (table, shopDataPath);
}

void updateRecordTable () {
  recordTable.rows = new ArrayList <MRow> ();
  Table table = loadTable(recordPath, "header");
  for ( int a = table.getRowCount()-1; a >=0; a --) {
    TableRow row = table.getRow (a);
    String item = row.getString ("Item");
    String  price = row.getString ("Price");
    String quantity = row.getString ("Quantity");
    String cAtegory = row.getString ("Category");
    String day = row.getString("Day");
    String month = row.getString("Month");
    String year = row.getString("Year");
    String rowsLabels [] = {item, quantity, price, cAtegory, day+"/"+month+"/"+year};
    recordTable.addRow (rowsLabels);

    if ( int (day )== day() ) {
      dailySalesTotal += float(price);   // daily total sale 
      dailyTaxTotal += 0.15 * float(price);   // daily total tax
      dailySubTotal += dailySalesTotal + dailyTaxTotal;
    } 
    if (int (month) == month()) {
      monthesSalesTotal += float(price);   // monthly total sale 
      monthesTaxTotal += 0.15 * float(price); 
      monthesSubTotal=monthesSalesTotal +monthesTaxTotal ;
    }
  }
}

 
 void fileSelected (File srcFile) {
  if (srcFile != null) {
    String path = srcFile.getAbsolutePath();
    if (path.endsWith (".png")|| path.endsWith("jpg")) { // || other image file formats)
      String dstPath = dataPath ("")+ "/images/"+name.value+ ".png";
      File dstFile = new File (dstPath);
      dstFile.getParentFile ().mkdirs();
      srcFile.renameTo(dstFile);
      imageUploaded= true;
    }
  }
}

void fileSelected2 (File srcFile) {
   
  if (srcFile != null) {
    String UserName="";
    if( casherName.value == activeUserName || casherName.value == null ){
    UserName= activeUserName;
  } else if (casherName.value != activeUserName){
    UserName = casherName.value;
  }
    String path = srcFile.getAbsolutePath();
    if (path.endsWith (".png")|| path.endsWith("jpg")) { // || other image file formats)
      String dstPath = dataPath ("")+ "/images/"+UserName+ ".png";
      File dstFile = new File (dstPath);
      dstFile.getParentFile ().mkdirs();
      dstFile.delete();
      srcFile.renameTo(dstFile);
    }
  }
}
void updateItemsTable () {
  itemTable.makeEmpty ();
  Table table = loadTable(shopDataPath,"header");
  for ( int a = 0 ; a< table.getRowCount(); a ++) {
    TableRow row = table.getRow (a);
    String itemName = row.getString ("Items");
    String  price = row.getString ("Prices");
    String code = row.getString ("Codes");
    String category = row.getString ("Category");
    String rowsLabels [] = {itemName, price,category,code};
    itemTable.addRow (rowsLabels);
   }
}
boolean exits (){
  for ( int p = 0 ; p < itemTable.rows.size() ; p ++ ){
   if (itemTable.rows.get(p).isActive ()){
     return true; 
   } 
  }
  return false;
}
String passwordRead(){
  String usersName= userName.value;
  TableRow row;
  String passWord;
  
  int uIndex= Tpassword.getColumnIndex("User Name");
  int pIndex= Tpassword.findRowIndex(usersName, uIndex);
  
  if ( !userName.value.equals("")){
    if ( !Password.value.equals("")){
      row= Tpassword.getRow(pIndex);
      passWord= row.getString("Password");
      return passWord;
    }
  }passWord= "no#ne";
  
  return passWord;
}
void graphdata(){ 
  Table table = loadTable(recordPath, "header");
  for ( int a = table.getRowCount()-1; a >=0; a --) {
    TableRow row = table.getRow (a);
    String  price = row.getString ("Price");
    String month = row.getString("Month");
    String year = row.getString("Year");
    for ( int i = 1; i <= 12; i++ ){
    if (int (month) == i && int(year) == year()) {
      monthesSalesTotal += float(price);  
      monthesTaxTotal += 0.15 * float(price); 
      monthesSubTotal=monthesSalesTotal +monthesTaxTotal ;
      monthlyRevenu [i-1] += float(price) + (0.15 * float(price));
    }
   }
  }
}
