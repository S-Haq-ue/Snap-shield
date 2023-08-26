import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/src/input_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snap_shield_alpha/utils/colors.dart';

// for picking up image from gallery
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  // print(text);
  // List<String> Fintext = text.split("]");
  // String errorText = Fintext[1].trim();
  // print(Text(Fintext[1]));
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
      ),
      backgroundColor: primaryColor,
    ),
  );
}
showSnackBarVal(BuildContext context, String text) {
  // print(text);
  List<String> Fintext = text.split("]");
  String errorText = Fintext[1].trim();
  // print(Text(Fintext[1]));
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        errorText,
      ),
      backgroundColor: primaryColor,
    ),
  );
}

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
        textColor: Color.fromARGB(255, 36, 18, 18),
      ),
    ),
  );
}
