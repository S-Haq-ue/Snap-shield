// import 'package:snap_shield_alpha/screens/textscreen.dart';

class TextExtraction {
  textExtractor(String text) {
    String finalText = text;
    // String finalText = "Hello i am sh find me from the image";
    String textWithoutDot = finalText.replaceAll(".", " ");

    List<String> finalSentance = textWithoutDot.split(" ");
    // print(finalSentance);
    finalSentance.removeWhere(
      (element) =>element.length<= 2
    );
    // TextScreen(words: finalSentance);
    print(finalSentance);
    return finalSentance;
  }
}
