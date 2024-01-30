class Page {
  String page = "";

  String DETAILS = "Details";
  String RECORD ="Record";
  String AddItem="AddItem";
  String Items="Items";
  Page () {
  }

  boolean isOrder () {
    return page.equals (DETAILS);
  }

  void setOrder () {
    page = DETAILS;
  }
  boolean isRecord() {
  return page.equals (RECORD);
  }
  void setRecord() {
    page = RECORD;
  }
  boolean isAddItem() {
    return page.equals (AddItem);
  }
  void setAddItem() {
    page = AddItem;
  }
  boolean isItems(){
     return page.equals (Items);
  }
  void setItems(){
    page = Items;
  }
}
