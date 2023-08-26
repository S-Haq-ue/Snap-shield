import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snap_shield_alpha/models/user.dart' as model;
import 'package:snap_shield_alpha/providers/user_provider.dart';
import 'package:snap_shield_alpha/resources/firestore_methods.dart';
import 'package:snap_shield_alpha/screens/comments_screen.dart';
import 'package:snap_shield_alpha/utils/colors.dart';
import 'package:snap_shield_alpha/utils/global_variable.dart';
import 'package:snap_shield_alpha/utils/utils.dart';
import 'package:snap_shield_alpha/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:snap_shield_alpha/widgets/post_card.dart';
import 'package:snap_shield_alpha/widgets/single_post.dart';

class ProfilePostCard extends StatefulWidget {
  final snap;
  const ProfilePostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<ProfilePostCard> createState() => _ProfilePostCardState();
}

class _ProfilePostCardState extends State<ProfilePostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      setState(() {
        commentLen = snap.docs.length;
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    // print("print profile");
    // print(widget.snap['likes']);
    return Container(
      // boundary needed for web
      decoration: BoxDecoration(
        border: Border.all(
          color: width > webScreenSize ? secondaryColor : mobileBackgroundColor,
        ),
        color: mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: GestureDetector(
        onTap: () => nextScreen(
          context,
          SinglePost(
            profImage: widget.snap['profImage'].toString(),
            postId: widget.snap['postId'].toString(),
            username: widget.snap['username'].toString(),
            uid: user.uid,
            likes: widget.snap['likes'],
            description: widget.snap['description'].toString(),
            postUrl: widget.snap['postUrl'].toString(),
            commentLength: commentLen,
          ),
        ),
        child: Image.network(
          widget.snap['postUrl'].toString(),
          fit: BoxFit.fitWidth,
        ),
        //
      ),
    );
  }
}
