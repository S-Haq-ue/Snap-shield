import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as aut;
import 'package:flutter/material.dart';
import 'package:snap_shield_alpha/ml/models/models.dart';
import 'package:snap_shield_alpha/ml/text_extraction.dart';
import 'package:snap_shield_alpha/models/user.dart';
import 'package:snap_shield_alpha/providers/user_provider.dart';
import 'package:snap_shield_alpha/resources/firestore_methods.dart';
import 'package:snap_shield_alpha/utils/colors.dart';
import 'package:snap_shield_alpha/utils/utils.dart';
import 'package:snap_shield_alpha/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final postId;
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final String uid = aut.FirebaseAuth.instance.currentUser!.uid;
  List<String> finaltext = [];
  final TextEditingController commentEditingController =
      TextEditingController();
  var userData = {};
  var isDataSensitive = false;
  var isToxic = false;
  var isSecure;
  @override
  void initState() {
    // TODO: implement initState
    getData();
  }

  getData() async {
    try {
      var userSnap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      userData = userSnap.data()!;
      print(userData['isSecure']);
      // isSecure = userData['isSecure'];
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }

  void postComment(
      String uid, String name, String profilePic, bool isSecure) async {
    if (commentEditingController.text != "" && isSecure == true) {
      // print(commentEditingController.text);
      finaltext = TextExtraction().textExtractor(commentEditingController.text);
      // call machine learning model to secure and toxic
      // make the modeles with return type of boolien
      // store that boolien value in a variable
      // if variable is true the show "showDialoge" to alert user,with to button(cancel[to cancel the posting],post[to continue with the posting])
      bool toxic = models().toxicComments(finaltext);
      bool sensitive = models().sensitiveContents(finaltext);
      setState(() {
        isDataSensitive = sensitive;
        isToxic = toxic;
      });
      if (!isDataSensitive && !isToxic) {
        try {
          String res = await FireStoreMethods().postComment(
            widget.postId,
            commentEditingController.text,
            uid,
            name,
            profilePic,
            isToxic,
          );
          // Navigator.pop(context);

          if (res != 'success') {
            showSnackBar(context, res);
          }
          setState(() {
            commentEditingController.text = "";
          });
        } catch (err) {
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
                            String res = await FireStoreMethods().postComment(
                              widget.postId,
                              commentEditingController.text,
                              uid,
                              name,
                              profilePic,
                              isToxic,
                            );
                            Navigator.pop(context);

                            if (res != 'success') {
                              showSnackBar(context, res);
                            }
                            setState(() {
                              commentEditingController.text = "";
                            });
                          } catch (err) {
                            showSnackBar(
                              context,
                              err.toString(),
                            );
                          }
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
                            String res = await FireStoreMethods().postComment(
                              widget.postId,
                              commentEditingController.text,
                              uid,
                              name,
                              profilePic,
                              isToxic,
                            );
                            Navigator.pop(context);
                            if (res != 'success') {
                              showSnackBar(context, res);
                            }
                            setState(() {
                              commentEditingController.text = "";
                            });
                          } catch (err) {
                            showSnackBar(
                              context,
                              err.toString(),
                            );
                          }
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
      }
    } else {
      isToxic = false;
      try {
        String res = await FireStoreMethods().postComment(
          widget.postId,
          commentEditingController.text,
          uid,
          name,
          profilePic,
          isToxic,
        );

        if (res != 'success') {
          showSnackBar(context, res);
        }
        setState(() {
          commentEditingController.text = "";
        });
      } catch (err) {
        showSnackBar(
          context,
          err.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text(
          'Comments',
          style: TextStyle(color: textColor),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentCard(
              snap: snapshot.data!.docs[index],
            ),
          );
        },
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(user.uid, user.username, user.photoUrl,
                    userData['isSecure']),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
