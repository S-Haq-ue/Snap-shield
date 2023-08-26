import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snap_shield_alpha/resources/auth_methods.dart';
import 'package:snap_shield_alpha/screens/login_screen.dart';
import 'package:snap_shield_alpha/screens/message/message_page.dart';
import 'package:snap_shield_alpha/utils/colors.dart';
import 'package:snap_shield_alpha/utils/global_variable.dart';
import 'package:snap_shield_alpha/utils/utils.dart';
import 'package:snap_shield_alpha/widgets/post_card.dart';
import 'package:snap_shield_alpha/widgets/profile_post_card.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  var userData = {};
  int postLen = 0;
  bool isLoading = false;
  var isSecure;
  late String userName;
  late String bio;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      // get post length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      isSecure = userData['isSecure'];
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var ctime;
    final width = MediaQuery.of(context).size.width;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: secondaryColor,
              //       leading: IconButton(
              //   icon: const Icon(
              //     Icons.arrow_back,
              //     color: textColor,
              //   ),
              //   onPressed: () {
              //     // nextScreenReplace(context, const MobileScreenLayout());
              //   },
              // ),
              title: Text(
                userData['username'],
                style:
                    GoogleFonts.kaushanScript(fontSize: 24, color: textColor),
              ),
            ),
            endDrawer: Drawer(
                backgroundColor: mobileBackgroundColor,
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  children: <Widget>[
                    Icon(
                      Icons.account_circle,
                      size: 150,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Snap Shield",
                      style: GoogleFonts.kaushanScript(
                        // fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Divider(
                      height: 2,
                    ),
                    ListTile(
                      onTap: () async {
                        nextScreen(context, const MessagePage());
                      },
                      selectedColor: Theme.of(context).primaryColor,
                      selected: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      leading: const Icon(
                        Icons.group,
                        color: textColor,
                      ),
                      title: const Text(
                        "Groups",
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  "Logout",
                                  style: TextStyle(color: textColor),
                                ),
                                content: const Text(
                                  "Are you sure you want to logout?",
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
                                              fontSize: 18,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await AuthMethods().signOut();
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen(),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(
                                            "Yes",
                                            style: TextStyle(
                                              fontSize: 18,
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      leading: const Icon(Icons.exit_to_app_outlined,
                          color: textColor),
                      title: const Text(
                        "Logout",
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    ListTile(
                      selectedColor: Theme.of(context).primaryColor,
                      selected: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      leading:
                          const Icon(Icons.lock_outlined, color: textColor),
                      title: const Text(
                        "Secure Mode",
                        style: TextStyle(color: textColor),
                      ),
                      trailing: ToggleSwitch(
                        minWidth: 33.0,
                        minHeight: 25.0,
                        initialLabelIndex: 0,
                        cornerRadius: 20.0,
                        activeFgColor: textColor,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: textColor,
                        totalSwitches: 1,
                        labels: [isSecure ? "On" : "Off"],
                        activeBgColors: [
                          isSecure
                              ? [Colors.cyanAccent, Colors.cyan]
                              : [Colors.grey, Colors.grey.shade500]
                        ],
                        //  nimate must be set to true when using custom curve
                        onToggle: (index) {
                          if (index == 0) {
                            setState(() {
                              isSecure = !isSecure;
                            });
                            print(isSecure);
                          }
                          final CollectionReference userCollection =
                              FirebaseFirestore.instance.collection("users");
                          final uid = FirebaseAuth.instance.currentUser!.uid;
                          DocumentReference userDocumentReference =
                              userCollection.doc(uid);
                          userDocumentReference.update({
                            "isSecure": isSecure,
                          });
                        },
                      ),
                    ),
                  ],
                )),
            body: WillPopScope(
              onWillPop: () {
                DateTime now = DateTime.now();
                if (ctime == null ||
                    now.difference(ctime) > const Duration(seconds: 2)) {
                  //add duration of press gap
                  ctime = now;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'Press Back Button Again to Exit'))); //scaffold message, you can show Toast message too.
                  return Future.value(false);
                }

                return Future.value(true);
              },
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            userData['photoUrl'],
                          ),
                          radius: 100,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 15,
                          ),
                          child: Text(
                            userData['username'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 1,
                          ),
                          child: Text(
                            userData['bio'],
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap =
                              (snapshot.data! as dynamic).docs[index];
                          return ProfilePostCard(
                            snap: snapshot.data!.docs[index].data(),
                          );
                          // Image(
                          //   image: NetworkImage(snap['postUrl']),
                          //   fit: BoxFit.cover,
                          // );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }

  noPostWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(
            height: 20,
          ),
          Text("No posts yet!!"),
        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
