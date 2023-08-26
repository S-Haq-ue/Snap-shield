import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snap_shield_alpha/ml/models/models.dart';
import 'package:snap_shield_alpha/ml/text_extraction.dart';
import 'package:snap_shield_alpha/utils/colors.dart';
import 'package:snap_shield_alpha/utils/utils.dart';

// for picking up image from gallery
bool secure = true;
// picrrkImage(ImageSource source) async {
//   final ImagePicker _imagePicker = ImagePicker();
//   XFile? _file = await _imagePicker.pickImage(source: source);
//   if (_file != null) {
//     return await _file.readAsBytes();
//   }
//   print('No Image Selected');
// }

final picker = ImagePicker();

pickAnImage(ImageSource source) async {
  // var result;
  final image = await picker.pickImage(source: source);
  if (image != null) {
    final inputImage = InputImage.fromFile(File(image.path));
    processImage(inputImage);
  }
  if (secure == true) {
    XFile? _file = image;
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }
  // List<String> tox(){
  //   return result;
  // }
}

final _textRecognizer = TextRecognizer();
Future<void> processImage(InputImage inputImage) async {
  // final file=File(inputImage.filePath!);
  final recognizedText = await _textRecognizer.processImage(inputImage);
  // print(recognizedText.text);
  List<String> imagetext = TextExtraction().textExtractor(recognizedText.text);
  bool toxic = models().toxicComments(imagetext);
  bool sensitive = models().sensitiveContents(imagetext);
  print("image toxic check $toxic");
  print("image secure $sensitive");
  // return imagetext;
  // call machine learning model to secure and toxic
  // make the modeles with return type of boolien
  // store that boolien value in a variable
  // if variable is true the show "showDialoge" to alert user,with to button(cancel[to cancel the posting],post[to continue with the posting])
  // _textRecognizer.close();
}
