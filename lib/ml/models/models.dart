class models {
  bool toxicComments(List<String> text) {
    bool tox=false;
    List<String> toxic;
    toxic=["fuck","asshole","hell","fat","ugly","beast","suck","ass","hit","kill""stupid","fool","idiot","bad","scums","moron","hate","rascal","smelly","smells","shit"];
    for(String word in text){
      
      // print("i value in toxic $word");
      // print("if condition result in toxic ${toxic.contains(word)}");
      if(toxic.contains(word.toLowerCase())){
        tox=true;
        break;
      }
    }
    // tox=true;
    // print("toxic$tox");
    return tox;
  }
  bool sensitiveContents(List<String> text) {
    bool sens=false;
    List<String> sensitive;
    sensitive=["+91","password","username","place","name","account","id","dob","(ho)","house","(po)","post","pin","ifsc"];
    for(String word in text){
      if(word.contains("@")){
        sens=true;
        break;
      }
      if (isNumericWith10Digits(word)) {
      sens = true;
      break;
    } 
      // print("i value in toxic $word");
      // print("if condition result in toxic ${toxic.contains(word)}");
      if(sensitive.contains(word.toLowerCase())){
        sens=true;
        break;
      }
    }
    // print("sensitive$sens");
    return sens;
  }
}

bool isNumericWith10Digits(String value) {
  if (value == null || value.length != 10) {
    return false;
  }
  return double.tryParse(value) != null;
}