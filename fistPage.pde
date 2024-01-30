class firstPage{
  String fPage="";
  String signInPage="signInPage";
  String mainPage= "mainPage";
  
  firstPage(){
  }
boolean isSignInPage () {
    return fPage.equals (signInPage);
  }

  void setSignInPage () {
    fPage = signInPage;
  }
  boolean isMainPage () {
    return fPage.equals (mainPage);
  }

  void setMainPage () {
    fPage = mainPage;
  }

}
