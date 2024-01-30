class CardRcontainer {
  float startX, startY;
  float startYs [];
  float gapY = 15;
  float w = 289, h = 417;
  float EndPoint = 0;
  float originalStartY;
  

  List <CardR> cards;


  CardRcontainer (float startX, float startY) {
    this.startX = startX;
    this.startY = startY;

    originalStartY = startY;

    cards = new ArrayList <CardR> ();
  }

  void addCardR (Card card) {
    CardR cardR = new CardR (card);

    cards.add (cardR);
  }

  void makeEmpty () {
    cards = new ArrayList <CardR> ();
  }

  boolean hasCardR (Card card) {
    for (int a = 0; a < cards.size (); a ++) {
      CardR eachCard = cards.get (a);

      if (eachCard.code.equals (card.code)) {
        return true;
      }
    }

    return false;
  }
  int Rindex (Card card) {

    for ( int a = 0; a < cards.size(); a++ ) {
      CardR eachCard = cards.get (a);
      if (eachCard.code.equals (card.code)) {
        int index = cards.indexOf( eachCard);
        return index ;
      }
    }
    return 0;
  }

  void draw() {
    for (int p = 0; p < cards.size (); p ++) {
      cards.get (p).draw (startX, startY + cards.get (p).h * (cards.size () - p - 1) + gapY*(cards.size () - p - 1));
    }

  }

  int quantity() {
    int Quantity=0;
    for ( int a=0; a< cards.size(); a++) {
      Quantity+=cards.get(a).quantity;
    }
    return Quantity;
  }

  float subtotal() {
    float subtotal=0;
    for ( int r=0; r< cards.size(); r++) {

      subtotal+=cards.get(r).quantity*float( cards.get(r).label2);
    }
    return subtotal;
  } 

  void codes() {
    for ( int a=0; a< cards.size(); a++) {
    }
  }

  void mouseReleased () {
    for ( int p = 0; p < cards.size () && hovered (); p ++) {
      cards.get (p).mouseReleased();
      if ( cards.get(p).minusHovered() || cards.get(p).plusHovered() || cards.get(p).cancelHovered()) {

        rContainer.subtotal();
      }
      if (cards.get (p).cancelHovered()) { 
        cards.remove (p);
        rContainer.subtotal();
        updateStartY ();
      }
    }
  }

  void mouseWheel (int factor) {
    if (hovered ()) {
      float temp = startY - factor * 8;
      startY = temp;

      updateStartY ();
    }
  }

  void updateStartY () {
    int scrollableCards = max (cards.size() - 5, 0);
    float minY = originalStartY - (scrollableCards)*70 - (scrollableCards)*gapY;
    startY = constrain (startY, minY, originalStartY);
  }

  boolean hovered () {
    return mouseX > startX && mouseX < startX + w && mouseY > 122 && mouseY < 122 + h;
  }
}
