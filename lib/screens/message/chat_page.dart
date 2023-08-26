import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snap_shield_alpha/ml/models/models.dart';
import 'package:snap_shield_alpha/ml/text_extraction.dart';
import 'package:snap_shield_alpha/screens/message/group_info.dart';
import 'package:snap_shield_alpha/screens/message/message_page.dart';
import 'package:snap_shield_alpha/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snap_shield_alpha/utils/colors.dart';
import 'package:snap_shield_alpha/utils/utils.dart';
import 'package:snap_shield_alpha/widgets/message_tile.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
  }) : super(key: key);
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<String> finaltext = [];
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";
  String AdminId = "";
  var userData = {};
  int postLen = 0;
  bool isLoading = false;
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  var isSecure;
  var isDataSensitive = false;
  var isToxic = false;

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() async {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
    DatabaseService().getGroupAdminId(widget.groupId).then((val) {
      setState(() {
        AdminId = val;
      });
    });
    try {
      var userSnap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      userData = userSnap.data()!;
      isSecure = userData['isSecure'];
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: textColor,
          ),
          onPressed: () {
            nextScreenReplace(context, const MessagePage());
          },
        ),
        title: Text(
          widget.groupName,
          style: GoogleFonts.kaushanScript(
            fontSize: 22,
            color: textColor,
          ),
        ),
        backgroundColor: secondaryColor,
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(
                  context,
                  GroupInfo(
                    groupId: widget.groupId,
                    groupName: widget.groupName,
                    adminName: admin,
                    adminId: AdminId,
                    uId: uid,
                  ));
            },
            icon: const Icon(Icons.info),
            color: primaryColor,
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          // chat messages here
          SingleChildScrollView(
              child: Container(
            height: MediaQuery.of(context).size.height * 0.79,
            child: chatMessages(),
          )),
          Container(
            // height: MediaQuery.of(context).size.height*0.90,
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: secondaryColor,
                  decoration: const InputDecoration(
                    hintText: "Send a message...",
                    hintStyle: TextStyle(color: textColor, fontSize: 16),
                    border: InputBorder.none,
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.send,
                        color: primaryColor,
                      ),
                    ),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  // print("toxicity of ${index} is ${snapshot.data.docs[index]['isToxic']}");
                  return MessageTile(
                    message: snapshot.data.docs[index]['message'],
                    sender: snapshot.data.docs[index]['sender'],
                    sentByMe:
                        widget.userName == snapshot.data.docs[index]['sender'],
                    isToxic: snapshot.data.docs[index]['isToxic'],
                  );
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text != "" && isSecure == true) {
      finaltext = TextExtraction().textExtractor(messageController.text);
      // call machine learning model to secure and toxic
      // make the modeles with return type of boolien
      // store that boolien value in a variable
      // if variable is true the show "showDialoge" to alert user,with to button(cancel[to cancel the posting],post[to continue with the posting])
      // print("\n");
      // print(finaltext);
      bool toxic=models().toxicComments(finaltext);
      bool sensitive=models().sensitiveContents(finaltext);
      setState(() {
        isDataSensitive = sensitive;
        isToxic = toxic;
      });
      if (!isDataSensitive && !isToxic) {
        if (messageController.text.isNotEmpty) {
          Map<String, dynamic> chatMessageMap = {
            "message": messageController.text,
            "sender": widget.userName,
            "time": DateTime.now().millisecondsSinceEpoch,
            "isToxic": isToxic,
          };

          DatabaseService()
              .sendMessage(widget.groupId, chatMessageMap, isToxic);
          setState(() {
            messageController.clear();
          });
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
                          if (messageController.text.isNotEmpty) {
                            Map<String, dynamic> chatMessageMap = {
                              "message": messageController.text,
                              "sender": widget.userName,
                              "time": DateTime.now().millisecondsSinceEpoch,
                              "isToxic": isToxic,
                            };

                            DatabaseService().sendMessage(
                                widget.groupId, chatMessageMap, isToxic);
                            setState(() {
                              messageController.clear();
                            });

                            Navigator.pop(context);
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
                          if (messageController.text.isNotEmpty) {
                            Map<String, dynamic> chatMessageMap = {
                              "message": messageController.text,
                              "sender": widget.userName,
                              "time": DateTime.now().millisecondsSinceEpoch,
                              "isToxic": isToxic,
                            };

                            DatabaseService().sendMessage(
                                widget.groupId, chatMessageMap, isToxic);
                            setState(() {
                              messageController.clear();
                            });
                            Navigator.pop(context);
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
      if (messageController.text.isNotEmpty) {
        Map<String, dynamic> chatMessageMap = {
          "message": messageController.text,
          "sender": widget.userName,
          "time": DateTime.now().millisecondsSinceEpoch,
          "isToxic": isToxic,
        };

        DatabaseService().sendMessage(widget.groupId, chatMessageMap, isToxic);
        setState(() {
          messageController.clear();
        });
      }
    }
  }
}
