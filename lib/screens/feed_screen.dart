import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snap_shield_alpha/screens/message/message_page.dart';
import 'package:snap_shield_alpha/utils/colors.dart';
import 'package:snap_shield_alpha/utils/global_variable.dart';
import 'package:snap_shield_alpha/utils/utils.dart';
import 'package:snap_shield_alpha/widgets/post_card.dart';
// import 'package:snap_shield_alpha/resources/auth_methods.dart';
// import 'package:snap_shield_alpha/screens/login_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    var ctime;
    final width = MediaQuery.of(context).size.width;

    setState(() {});

    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: secondaryColor,
              centerTitle: false,
              title: Text(
                "Snap Shield",
                style: GoogleFonts.kaushanScript(
                  // fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: textColor,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    nextScreen(context, const MessagePage());
                  },
                  // () async {
                  //   await AuthMethods().signOut();
                  //   Navigator.of(context).pushReplacement(
                  //     MaterialPageRoute(
                  //       builder: (context) => const LoginScreen(),
                  //     ),
                  //   );
                  // },
                  icon: const Icon(
                    MaterialCommunityIcons.facebook_messenger,
                    color: primaryColor,
                  ),
                )
              ],
            ),
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
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    int reverseIndex = snapshot.data!.docs.length - index - 1;
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: width > webScreenSize ? width * 0.3 : 0,
                        vertical: width > webScreenSize ? 15 : 0,
                      ),
                      child: snapshot.data!.docs.isEmpty
                          ? noPostWidget()
                          : PostCard(
                              snap: snapshot.data!.docs[reverseIndex].data(),
                            ),
                    );
                  });
            } else {
              return noPostWidget();
            }
          },
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
}
