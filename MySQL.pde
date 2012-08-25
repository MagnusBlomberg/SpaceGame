class MySQL{
  String urlString;
  MySQL(String newUrlString){
    urlString = newUrlString;
  }
  
  void updateVar(String parameter, String value){
    loadStrings(urlString + "?" + parameter + "=" + value);
  }
  
  String getVar(String parameter){
    String[] tmpString = loadStrings(urlString + "?get" + parameter);
    return tmpString[0];
  }
  
}
