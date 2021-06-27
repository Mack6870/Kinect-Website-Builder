class Element{
  
  // element attributes
  String type;
  int wdth;
  int hght;
  int posX;
  int posY;
  boolean added = false;
  
  // constructor 1
  public Element(String type, int wdth, int hght, int posX, int posY){
    this.type = type;
    this.wdth = wdth;
    this.hght = hght;
    this.posX = posX;
    this.posY = posY;
  }
  
  // constructor 2
  public Element(String type, int posX, int posY){
    this.type = type;
    this.posX = posX;
    this.posY = posY;
  }
  
  public String toString(){
    if (type.equals("image")){
      return "Element of type : " + type + " Width: " + wdth + " Height: " + hght + " posX: " + posX + " posY: " + posY;
    }
    return "Element of type : " + type + " posX: " + posX + " posY: " + posY;
  }
  
}
