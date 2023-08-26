import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snap_shield_alpha/screens/feed_screen.dart';
import 'package:snap_shield_alpha/screens/message/message_page.dart';
import 'package:snap_shield_alpha/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snap_shield_alpha/utils/colors.dart';
import 'package:snap_shield_alpha/utils/utils.dart';

class GroupInfo extends StatefulWidget {
  final String uId;
  final String groupId;
  final String groupName;
  final String adminName;
  final String adminId;
  const GroupInfo(
      {Key? key,
      required this.adminName,
      required this.groupName,
      required this.groupId,
      required this.adminId,
      required this.uId})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  var userData = {};
  var isToxic;
  Stream? members;
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  var currentId = FirebaseAuth.instance.currentUser!.uid;

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  // getData(String currentId) async {
  //   try {
  //     var userSnap = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(currentId)
  //         .get();
  //     userData = userSnap.data()!;
  //   } catch (e) {
  //     showSnackBar(
  //       context,
  //       e.toString(),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: secondaryColor,
        title: Text(
          "Group Info",
          style: GoogleFonts.kaushanScript(
            fontSize: 28,
            color: textColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        "Exit",
                        style: TextStyle(color: textColor),
                      ),
                      content: const Text(
                        "Are you sure you exit the group? ",
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
                                  "No",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                DatabaseService(
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .toggleGroupJoin(
                                        widget.groupId,
                                        getName(widget.adminName),
                                        widget.groupName)
                                    .whenComplete(() {
                                  nextScreenReplace(
                                      context, const MessagePage());
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  });
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: primaryColor,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).primaryColor.withOpacity(0.2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        widget.groupName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, color: textColor),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Group : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor),
                            ),
                            Text(
                              widget.groupName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: textColor),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Admin : ",
                              style: TextStyle(color: primaryColor),
                            ),
                            Text(
                              getName(widget.adminName),
                              style: const TextStyle(color: textColor),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Divider(color: secondaryColor),
              memberList(),
            ],
          ),
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              // print(snapshot.data['members']);
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var currid = getId(snapshot.data['members'][index]);
                  // print(currentId);
                  // getData(currid);
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            // userData['isToxic'] == true
                            //     ? Color.fromARGB(255, 255, 135, 135)
                            //     :
                            Theme.of(context).primaryColor,
                        child: Text(
                          getName(snapshot.data['members'][index])
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                              color: textColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        getName(snapshot.data['members'][index]),
                        style: const TextStyle(color: textColor),
                      ),
                      trailing: currid == widget.adminId
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(color: secondaryColor),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(3.0),
                                child: Text(
                                  "Admin",
                                  style: TextStyle(
                                    color: textColor,
                                  ),
                                ),
                              ))
                          : IconButton(
                              onPressed: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Exit",
                                          style: TextStyle(color: textColor),
                                        ),
                                        content: Text(
                                          "Are you sure you want to remove ${getName(snapshot.data['members'][index])} ",
                                          style: TextStyle(color: textColor),
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.all(15.0),
                                                  child: Text(
                                                    "No",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  DatabaseService(
                                                          uid: FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                      .removeMember(
                                                          widget.groupId,
                                                          getName(snapshot.data[
                                                                  'members']
                                                              [index]),
                                                          widget.groupName,
                                                          currid)
                                                      .whenComplete(() {
                                                    setState(() {
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid;
                                                    });
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          Colors.green.shade800,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(
                                widget.uId == widget.adminId
                                    ? Icons.exit_to_app
                                    : null,
                                color: primaryColor,
                              ),
                            ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("NO MEMBERS"),
              );
            }
          } else {
            return const Center(
              child: Text("NO MEMBERS"),
            );
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ));
        }
      },
    );
  }
}
