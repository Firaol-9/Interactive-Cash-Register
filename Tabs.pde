class Tabs {
  float x, y;
  float w = 160, h = 70;
  float TcontainerW = 856;
  float TcontainerH=70;
  float containerX= 143;
  float containerY=134;
  float gapX = 14;

  int activeTabIndex = 0;

  List <Button> buttons;

  Tabs (float x, float y) {
    this.x = x;
    this.y = y;

    buttons = new ArrayList <Button> ();
  }

  void addButtons (String labels []) {
    for (int a = 0; a < labels.length; a ++) {
      addButton (labels [a]);
    }
  }

  void addButton (String label) {
    float buttonsX = x + gapX * buttons.size () + w * buttons.size ();
    float buttonsY = y;
    buttons.add (new Button (label, buttonsX, buttonsY));
  }

  void activate (int index) {
    if (index >= 0 && index < buttons.size ()) {
      buttons.get (index).active = true;
      activeTabIndex = index;

      for (int i = 0; i < buttons.size (); i ++) {
        if (index != i)
          buttons.get (i).active = false;
      }
    }
  }

  void draw () {
    // Draw cards' buttons
    for (int b = 0; b < buttons.size (); b ++) {
      buttons.get (b).draw ();
    }
  }

  void mouseReleased () {
    for (int b = 0; b < buttons.size () ; b ++) {
      if (buttons.get (b).hovered () && hovered ()) {
        // Activate the button pressed
        buttons.get (b).active = true ;
        activeTabIndex = b;

        // Inactivate the unpressed buttons
        for (int i = 0; i < buttons.size (); i ++) {
          if (b != i)
            buttons.get (i).active = false;
        }

        break;
      }
    }
  }
   boolean hovered () {
    return mouseX > containerX && mouseX < containerX + TcontainerW && mouseY > containerY && mouseY < containerY + TcontainerH;
  }
}
