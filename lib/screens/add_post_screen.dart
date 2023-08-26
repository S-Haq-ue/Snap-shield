import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snap_shield_alpha/ml/models/models.dart';
import 'package:snap_shield_alpha/ml/text_extraction.dart';
import 'package:snap_shield_alpha/ml/text_recognition.dart';
import 'package:snap_shield_alpha/providers/user_provider.dart';
import 'package:snap_shield_alpha/resources/firestore_methods.dart';
import 'package:snap_shield_alpha/utils/colors.dart';
import 'package:snap_shield_alpha/utils/utils.dart';
import 'package:provider/provider.dart';
//   import 'dart:io';

// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'
// as ml;

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<String> finaltext = [];
  Uint8List? _file;
  bool isLoading = false;
  var isDataSensitive = false;
  var isToxic = false;
  var sens = false;
  var tox = false;
  final TextEditingController _descriptionController = TextEditingController();

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title:
              const Text('Create a Post', style: TextStyle(color: textColor)),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo',
                    style: TextStyle(color: textColor)),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file =
                      await pickAnImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery',
                    style: TextStyle(color: textColor)),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file =
                      await pickAnImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel", style: TextStyle(color: textColor)),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage(
      String uid, String username, String profImage, bool isSecure) async {      
    setState(() {
      isLoading = true;
    });
    if (_descriptionController.text != "" && isSecure == true) {
      finaltext = TextExtraction().textExtractor(_descriptionController.text);
      // call machine learning model to secure and toxic
      // make the modeles with return type of boolien
      // store that boolien value in a variable
      // if variable is true the show "showDialoge" to alert user,with to button(cancel[to cancel the posting],post[to continue with the posting])
      // print("\n");
      // print(finaltext);
      bool toxic = models().toxicComments(finaltext);
      bool sensitive = models().sensitiveContents(finaltext);
      setState(() {
        isDataSensitive = sensitive;
        isToxic = toxic;
      });
    }
    // start the loading
    if (!isDataSensitive && !isToxic) {
      try {
        // upload to storage and db
        String res = await FireStoreMethods().uploadPost(
          _descriptionController.text,
          _file!,
          uid,
          username,
          profImage,
        );
        if (res == "success") {
          setState(() {
            isLoading = false;
          });
          showSnackBar(
            context,
            'Posted!',
          );
          clearImage();
        } else {
          showSnackBar(context, res);
        }
      } catch (err) {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          err.toString(),
        );
      }
    } else if (isDataSensitive && isToxic) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "Toxic and Sensitive Content Present",
                style: TextStyle(color: textColor),
              ),
              content: const Text(
                "Do you want to continue ?",
                style: TextStyle(color: textColor),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        try {
                          // upload to storage and db
                          String res = await FireStoreMethods().uploadPost(
                            _descriptionController.text,
                            _file!,
                            uid,
                            username,
                            profImage,
                          );
                          if (res == "success") {
                            setState(() {
                              isLoading = false;
                            });
                            showSnackBar(
                              context,
                              'Posted!',
                            );
                            clearImage();
                          } else {
                            showSnackBar(context, res);
                          }
                        } catch (err) {
                          setState(() {
                            isLoading = false;
                          });
                          showSnackBar(
                            context,
                            err.toString(),
                          );
                        }
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Post",
                          style: TextStyle(
                            fontSize: 18,
                            color: blueColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
    } else if (isDataSensitive || isToxic) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                isDataSensitive
                    ? "Sensitive Data Present"
                    : "Toxic Content Present",
                style: const TextStyle(color: textColor),
              ),
              content: const Text(
                "Do you want to continue ?",
                style: TextStyle(color: textColor),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        try {
                          // upload to storage and db
                          String res = await FireStoreMethods().uploadPost(
                            _descriptionController.text,
                            _file!,
                            uid,
                            username,
                            profImage,
                          );
                          if (res == "success") {
                            setState(() {
                              isLoading = false;
                            });
                            showSnackBar(
                              context,
                              'Posted!',
                            );
                            clearImage();
                          } else {
                            showSnackBar(context, res);
                          }
                        } catch (err) {
                          setState(() {
                            isLoading = false;
                          });
                          showSnackBar(
                            context,
                            err.toString(),
                          );
                        }
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Post",
                          style: TextStyle(
                            fontSize: 18,
                            color: blueColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
    } else {
      try {
        // upload to storage and db
        String res = await FireStoreMethods().uploadPost(
          _descriptionController.text,
          _file!,
          uid,
          username,
          profImage,
        );
        if (res == "success") {
          setState(() {
            isLoading = false;
          });
          showSnackBar(
            context,
            'Posted!',
          );
          clearImage();
        } else {
          showSnackBar(context, res);
        }
      } catch (err) {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          err.toString(),
        );
      }
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    var ctime;
    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
                size: 60,
                color: textColor,
              ),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: textColor,
                ),
                onPressed: clearImage,
              ),
              title: Text(
                'Post to',
                style:
                    GoogleFonts.kaushanScript(fontSize: 22, color: textColor),
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: () => postImage(
                    userProvider.getUser.uid,
                    userProvider.getUser.username,
                    userProvider.getUser.photoUrl,
                    userProvider.getUser.isSecure,
                  ),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
            ),
            // POST FORM
            body: Column(
              children: <Widget>[
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        userProvider.getUser.photoUrl,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            focusColor: primaryColor,
                            hintText: "Write a caption...",
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 80.0,
                      width: 80.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: MemoryImage(_file!),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          );
  }
}

/* try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }*/