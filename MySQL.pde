class MySQL{
  String urlString;
  MySQL(String newUrlString){
    urlString = newUrlString;
  }
  
  void updateVar(String parameter, String value){
    loadStrings(urlString + "?set=" + parameter + "&val=" + value);
  }
  
  String getVar(String parameter){
    String[] tmpString = loadStrings(urlString + "?get=" + parameter);
    return tmpString[0];
  }
  
  void updateShip(Ship newShip){
    loadStrings(urlString + "?updateShip=" + newShip.sqlID + "&positionx=" + newShip.position.x + "&positiony=" + newShip.position.y + "&positionz=" + newShip.position.z + "&health=" + newShip.health);
  }
  
  int getNextShipID(){
    return 1;
  }
}
