class CardsContainer {
  float startX, startY;
  float startYs [];
  float gapX = 14, gapY = 14;
  float w = 856, h = 546;
  float originalStartY;

  int TotalNCards;
  int numOfRows;

  List <Card> cards [];

  CardsContainer (float startX, float startY) {
    this.startX = startX;
    this.startY = startY;

    originalStartY = startY;

    cards = new List [categoriesList.length];
    startYs = new float [categoriesList.length];

    for (int a = 0; a < categoriesList.length; a ++) {
      startYs [a] = originalStartY;
      cards   [a] = new ArrayList <Card> ();
    }

    TotalNCards = shopData.getRowCount();
  }

  void emptyCardContainer (String category) {
    int cIndex = getCategoryIndex (category);// getcatagoryindex checks the index of category in which the item is contained from catagorieaslist
    cards [cIndex] = new ArrayList <Card> ();
  }

  void addCard (String label, String price, String imagePath, String category, String code) {
    Card card = new Card (label, price, imagePath, category, code);

    int cIndex = getCategoryIndex (category);// getcatagoryindex checks the index of category in which the item is contained from catagorieaslist
    cards [cIndex].add (card);
  }
  
  void addCards (List cards, String category) {
    int cIndex = getCategoryIndex (category);// getcatagoryindex checks the index of category in which the item is contained from catagorieaslist
    this.cards [cIndex] = cards;
  }

  void draw () {
    int iIndex = 0;
    int cIndex = categories.activeTabIndex;

    numOfRows = max (1, ceil (cards [cIndex].size ()/5.0));

    for (int r = 0; r < numOfRows; r ++) {
      for (int c = 0; c < 5; c ++) {

        if (iIndex < cards [cIndex].size ()) {
          Card card = cards [cIndex].get (iIndex);
          float xC = startX + card.w*c + gapX*c;
          float yC = startYs [cIndex] + card.h*r + gapY*r;
          card.draw (xC, yC);
          iIndex ++;
        }
      }
    }


    point (startX, startYs [cIndex] + numOfRows*new Card ().h +(numOfRows-1)*gapY);
  }

  void mouseReleased () {
    int iIndex = 0;
    int cIndex = categories.activeTabIndex;
    
    for (int r = 0; r < numOfRows && hovered (); r ++) {
      for (int c = 0; c < 5; c ++) {

        if (iIndex < cards [cIndex].size ()) {
          Card card = cards [cIndex].get (iIndex);

          if (card.hovered ()) {
            if (!rContainer.hasCardR(card)) {
              rContainer.addCardR (card);
              rContainer.subtotal();
            } else {
              int index = rContainer.Rindex(card);
              rContainer.cards.get(index).active = true;
              rContainer.cards.get(index).quantity++;
            }
          }

          iIndex ++;
        }
      }
    }
  }

  void mouseWheel (int factor) {
    int cIndex = categories.activeTabIndex;

    if (cards [cIndex].size () > 15) {
      if (hovered ()) {   // to allow the scroll only in the region of the cards  
        float temp = startYs [cIndex] -factor * 8;

        float limit = 219-(( numOfRows*new Card ().h +(numOfRows-1)*gapY)- (3*new Card ().h +2*gapY ));

        if (temp<=startY && temp >= limit) {
          startYs [cIndex] = temp;
        } 
        if ( temp>=startYs [cIndex] + numOfRows*new Card ().h +(numOfRows-1)*gapY) {
          startYs [cIndex] =startYs [cIndex] -factor * 8;
        }
      }
    }
  }

  boolean hovered () {
    return mouseX > startX && mouseX < startX + w && mouseY > startY && mouseY < startY + h;
  }
}
