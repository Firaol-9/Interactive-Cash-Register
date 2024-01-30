class TextField {
  String label = "", value = ""; // Label: Name  |  Value: Input text (content)
  String assistiveText = "Assistive Text";
  String allowedInputChars = "";
  String LETTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
  String NUMBERS = "0123456789.";
  String SPACE = " ";
  String NAME_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz /.";

  float x = 480, y = 180;
  float w = 365, h = 55;

  float minTextSize = 14, maxTextSize = 18;

  float aiMinBorderSize = 1, aiMaxBorderSize = 2; // ai: Activation Indicator
  float insertionPointSize = 2;
  float cornerRadius = 6;

  int insertionPointPeriod = 500; // Blinking period of insertion point
  int inputCharLimit = -1;
  int FILLED = 0, OUTLINED = 1; // 0: Filled Text Field 1: Outlined Text Field
  int mode = FILLED;

  color accentColor = pink;
  color unhoveredFill = fadebrown, hoveredFill = brownMid, activeFill = brownLight, outlinedFill = white; // For container fill
  color unhoveredStroke = superGray, hoveredStroke = gray, activeStroke = accentColor; // For activation indicator/border & text fill
  color inactiveLabelFill = gray, activeLabelFill = accentColor;
  color valueFill = white;
  color errorFill = reddishBrown;

  boolean active = false;
  boolean showCharCount = false;
  boolean showAssistiveText = false;
  boolean error = false;
  boolean required = false;
  boolean showCharacterCounter = false;

  Fonts fonts;

  Periodically ipPeriod;

  void init (String label, float x, float y, float w, float h) {
    this.label = label;
    this.x = x; 
    this.y = y;
    this.w = w; 
    this.h = h;

    ipPeriod = new Periodically (insertionPointPeriod);
    allowedInputChars = NAME_CHARACTERS;
    fonts = new Fonts ();
  }

  TextField (String label, float x, float y, float w, float h) {
    init (label, x, y, w, h);
  }
  TextField (String label, float x, float y) {
    init (label, x, y, w, h);
  }

  void draw () {

    // For Outlined Text Field, Activation Indicator
    strokeCap (SQUARE);
    stroke (hovered ()? hoveredStroke : unhoveredStroke);
    if (active) stroke (activeStroke);
    if (error) stroke (errorFill);
    strokeWeight (active? aiMaxBorderSize : aiMinBorderSize);
    if (mode == FILLED) noStroke ();

    // Container
    // MODE: FILLED
    rectMode (CORNER);
    if (mode == FILLED) {
      fill (hovered ()? hoveredFill : unhoveredFill);
      if (active) fill (activeFill);
      rect (x, y, w, h, cornerRadius, cornerRadius, 0, 0);
    } else {
      fill (outlinedFill);
      rect (x, y, w, h, cornerRadius);
    }

    // For Filled Text Field
    // Activation Indicator
    stroke (hovered ()? hoveredStroke : unhoveredStroke);
    if (active) stroke (activeStroke);
    if (error) stroke (errorFill);
    strokeWeight (active? aiMaxBorderSize : aiMinBorderSize);
    strokeCap (SQUARE);
    if (mode == FILLED) line (x, y + h, x + w, y + h);

    // Label text
    textFont (fonts.roboto.medium);
    float lGap = (h - maxTextSize)/2;
    float lx = x + lGap;
    float ly = y + (h - maxTextSize)/2 - textDescent ()/2;
    if (mode == OUTLINED) {
      ly = y + h/2 - textDescent ()/2;
      if (active || value.length () != 0) ly = y - textDescent ()/2;
      textAlign (LEFT, CENTER);
    } else {
      if (active || value.length () != 0) ly = y + minTextSize - textDescent ()/2;
      textAlign (LEFT, TOP);
    }
    fill (active? activeLabelFill : inactiveLabelFill);
    if (error) fill (errorFill);
    textSize (active || value.length () != 0? minTextSize : maxTextSize);

    if (mode == OUTLINED && (active || value.length () != 0)) {
      strokeWeight (1 + (active? aiMaxBorderSize : aiMinBorderSize));
      stroke (outlinedFill);
      strokeCap (SQUARE);
      line (lx - 7, y, lx + textWidth (label) + 7, y);
    }
    text (error? label + "*" : label, lx, ly);

    // Insertion point | L: Length | W: Width of bounding box for the insertion point
    textFont (fonts.roboto.regular);
    textSize (maxTextSize);
    float ipX = lx + insertionPointSize*0.8 + textWidth (value);
    ipX = constrain (ipX, lx + insertionPointSize*0.8, x + w - lGap);
    float ipY = y + minTextSize + 1.9*(h - minTextSize - maxTextSize)/3;
    float ipL = (textDescent () + textAscent ())*0.9;
    if (mode == OUTLINED) ipY = y + (h - ipL)/2;

    float ipW = w - 2*lGap - insertionPointSize*0.8;
    if (active) stroke (activeStroke);
    if (error) stroke (errorFill);
    strokeWeight (insertionPointSize);
    if (active && ipPeriod.getState())
      line (ipX, ipY, ipX, ipY + ipL);

    // Value text
    String displayableValue = value;
    if (ipX  >= x + w - lGap) { // Insertion point has reached bound limit within field
      while (textWidth (displayableValue) > ipW) displayableValue = displayableValue.substring (1, displayableValue.length ());
    }
    textFont (fonts.roboto.regular);
    textSize (maxTextSize); 
    fill (valueFill);
    textAlign (LEFT, TOP);
    text (displayableValue, lx, ipY);

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

    // Character Counter
    if (inputCharLimit > 0 && showCharacterCounter) {
      textFont (fonts.roboto.regular);
      float atx = x + w - lGap, aty = y + h + minTextSize*0.5;
      fill (inactiveLabelFill);
      textSize (minTextSize);
      textAlign (RIGHT, TOP);
      text (value.length () + "/" + inputCharLimit, atx, aty);
    }
  }

  void showCharacterCounter () {
    showCharacterCounter = true;
  }

  boolean hovered () {
    return rectHovered (x, y, w, h, CORNER);
  }
  boolean rectHovered (float x, float y, float w, float h, float orientation) {
    return (((orientation == CORNER && mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h)
      || (orientation == CENTER && mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - h/2 && mouseY <= y + h/2))? true : false);
  }

  void acceptNumbersOnly (int inputCharLimit) {
    allowedInputChars = NUMBERS;
    this.inputCharLimit = inputCharLimit;
  }
  void setCharacterLimit (int inputCharLimit) {

    this.inputCharLimit = inputCharLimit;
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
    this.assistiveText = assistiveText;

    required = true;
  }
  void setRequiredText (String assistiveText, boolean showAssistiveText) {
    this.assistiveText = assistiveText;
    required = true;
    this.showAssistiveText = showAssistiveText;
  }

  void mousePressed () {
    if (hovered ()) active = true;
    else active = false;
  }

  void keyPressed (String keyStr) {
    char key = '-';
    if (keyStr.length () == 1 ) {
      key = keyStr.charAt (0);
    } else {
      if (keyStr.equals ("BS")) {
        key = BACKSPACE;
      }
      else if (keyStr.equals("ENTER") ){
        key =ENTER;
      }
      else if (keyStr.equals("SHIFT")){
        key = UP;
      }
    }
    
    if (active == true) {
      if (allowedInputChars.contains (str (key)) && (inputCharLimit > 0? value.length () < inputCharLimit : true))
        value += key;
      else if (value.length () > 0 && key == BACKSPACE) {
        int index = value.length () - 1;
        value = value.substring (0, index);
      } else if (key == ENTER)
        active = false;
    }
  }
  
  void keyPressed () {    
    if (active == true) {
      if (allowedInputChars.contains (str (key)) && (inputCharLimit > 0? value.length () < inputCharLimit : true))
        value += key;
      else if (value.length () > 0 && keyCode == BACKSPACE) {
        int index = value.length () - 1;
        value = value.substring (0, index);
      } else if (keyCode == ENTER)
        active = false;
    }
  }
} 
