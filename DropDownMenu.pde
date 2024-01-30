class DropDownMenu {
  PShape sortDown, sortUp; // Cascading Menu Indicator Icons

  String label = "", value = ""; // Label: Name  |  Value: Selected text (content)
  String assistiveText = "Assistive Text";
  String menus [] = {""};

  float x = 480, y = 180;
  float w = 400, h = 80;

  float minTextSize = 14, midTextSize = 16, maxTextSize = 18;

  float aiMinBorderSize = 1.5, aiMaxBorderSize = 2; // ai: Activation Indicator
  float cornerRadius = 6;
  float iconW, iconH;

  int insertionPointPeriod = 500; // Blinking period of insertion point

  color accentColor = purple;
  color unhoveredFill = fadebrown, hoveredFill = brownMid, activeFill = brownMid, pressedFill =brownMid; // For container fill
  color unhoveredMenuFill = fadebrown, hoveredMenuFill = brownMid;
  color unhoveredStroke = gray, hoveredStroke = superGray, activeStroke = accentColor; // For activation indicator/border & text fill
  color inactiveLabelFill = white, activeLabelFill = pink;
  color valueFill = white;
  color errorFill = reddishBrown;

  boolean active = false;
  boolean showCharCount = false;
  boolean showAssistiveText = false;
  boolean error = false;
  boolean required = false;

  Fonts fonts;

  Periodically ipPeriod;

  DropDownMenu (String label, String [] menus, float x, float y, float w, float h) {
    this.label = label;
    this.menus = menus;
    this.x = x; 
    this.y = y;
    this.w = w; 
    this.h = h;

    ipPeriod = new Periodically (insertionPointPeriod);
    fonts = new Fonts ();

    sortDown = loadShape ("data/icons/sort_down.svg");
    sortDown.disableStyle();
    sortUp = loadShape ("data/icons/sort_up.svg");
    sortUp.disableStyle();

    iconW = h*0.3;
    iconH = sortDown.height*(iconW/sortDown.width);
  }

  void draw () {
    // Container
    noStroke ();
    rectMode (CORNER);
    fill (hovered ()? hoveredFill : unhoveredFill);
    if (active) fill (activeFill);
    if (hovered () && mousePressed) fill (pressedFill);
    rect (x, y, w, h, cornerRadius, cornerRadius, 0, 0);

    // Label text
    textFont (fonts.roboto.medium);
    float lGap = (h - maxTextSize)/2;
    float lx = x + lGap;
    float ly = y + h/2 - textDescent ()/2;
    if (active || value.length () != 0) ly = y + minTextSize - textDescent ()/2;
    fill (active? activeLabelFill : inactiveLabelFill);
    if (error) fill (errorFill);
    textSize (active || value.length () != 0? minTextSize : maxTextSize);
    textAlign (LEFT, (active || value.length () != 0? TOP : CENTER));
    text (error? label + "*" : label, lx, ly);

    // Value text
    float vx = lx;
    float vy = y + h - minTextSize + textAscent ()/2 - textDescent ()/2;
    textFont (fonts.roboto.regular);
    textSize (maxTextSize);
    fill (valueFill);
    textAlign (LEFT, BOTTOM);
    text (value, vx, vy+5);

    // Assistive text
    if (showAssistiveText) {
      textFont (fonts.roboto.regular);
      float atx = lx, aty = y + h + minTextSize*0.5;
      fill (inactiveLabelFill);
      if (error) fill (errorFill);
      textSize (minTextSize);
      textAlign (LEFT, TOP);
      text ((required? "*" : "") + assistiveText, atx, aty);
    }

    // Menus
    if (menus.length > 1 && active) {
      float mGap = lGap*0.3;
      float mx = x, my = y + h, mw = w, mh = h - 2*mGap;
      float totalMh = mh*menus.length + mGap*2;
      int dirn = 1;
      if (my + totalMh > height) {
        my = y - totalMh - mGap;
        dirn = -1;
      }
      rectMode (CORNER);
      stroke (hoveredMenuFill);
      fill (unhoveredMenuFill);
      if (dirn == 1) rect (mx, my, mw, totalMh, 0, 0, cornerRadius, cornerRadius);
      else rect (mx, my, mw, totalMh, cornerRadius, cornerRadius, 0, 0);
      noStroke ();
      textFont (fonts.roboto.regular);
      textSize (midTextSize);
      for (int a = 0; a < menus.length; a ++) {
        fill (hoveredMenu (a)? hoveredFill : unhoveredMenuFill);
        rect (mx, my + mGap + a*mh, mw, mh);

        fill (valueFill);
        textAlign (LEFT, CENTER);
        text (menus [a], vx, my + mGap + a*mh + mh/2 - textDescent ()/2);
      }

      noFill ();
      stroke (hoveredMenuFill);
      strokeWeight (1);
      if (dirn == 1) rect (mx, my, mw, totalMh, 0, 0, cornerRadius, cornerRadius);
      else rect (mx, my, mw, totalMh, cornerRadius, cornerRadius, 0, 0);
    }

    // Cascading Menu Indicator
    float ix = lx + w - lGap - iconW*1.5;
    float iy = y + h/2;
    shapeMode (CENTER);
    noStroke ();
    fill (active? activeLabelFill : inactiveLabelFill);
    if (error) fill (errorFill);
    shape (active? sortUp : sortDown, ix, iy, iconW, iconH);

    // Activation Indicator
    stroke (hovered ()? hoveredStroke : unhoveredStroke);
    if (active) stroke (activeStroke);
    if (error) stroke (errorFill);
    strokeWeight (active? aiMaxBorderSize : aiMinBorderSize);
    strokeCap (SQUARE);
    line (x, y + h, x + w, y + h);
  }

  boolean hoveredMenu (int m) {
    float lGap = (h - maxTextSize)/2;
    float mGap = lGap*0.3;
    float mx = x, my = y + h, mw = w, mh = h - 2*mGap;
    float totalMh = mh*menus.length + mGap*2;

    if (my + totalMh > height)
      my = y - totalMh - mGap;

    return rectHovered (mx, my + mGap + m*mh, mw, mh, CORNER);
  }
  boolean hoveredMenu () {
    for (int a = 0; a < menus.length; a ++)
      if (hoveredMenu (a)) return true;

    return false;
  }
  int getHoveredMenuIndex () {
    for (int a = 0; a < menus.length; a ++)
      if (hoveredMenu (a)) return a;

    return -1;
  }
  String getHoveredMenuValue () {
    int menuIndex = getHoveredMenuIndex ();
    if (menuIndex != -1) return menus [menuIndex];

    return null;
  }
  boolean hovered () {
    return rectHovered (x, y, w, h, CORNER);
  }
  boolean rectHovered (float x, float y, float w, float h, float orientation) {
    return (((orientation == CORNER && mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h)
      || (orientation == CENTER && mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - h/2 && mouseY <= y + h/2))? true : false);
  }

  void showAssistiveText (String assistiveText) {
    showAssistiveText = true;

    this.assistiveText = assistiveText;
  }
  void showErrorText (String assistiveText) {
    showAssistiveText = true;
    error = true;

    this.assistiveText = assistiveText;
  }
  void setRequiredText (String assistiveText) {
    setRequiredText (assistiveText, true);
  }
  void setRequiredText (String assistiveText, boolean showAssistiveText) {
    this.assistiveText = assistiveText;

    required = true;
    this.showAssistiveText = showAssistiveText;
  }

  void mousePressed () {
    if (active && hoveredMenu ()) {
      int hoveredIndex = getHoveredMenuIndex();
      value = menus [hoveredIndex];
      active = false;
    } else if (hovered ()) active = !active;
    else active = false;
  }
}
