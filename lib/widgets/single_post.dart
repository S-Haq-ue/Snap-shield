import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snap_shield_alpha/models/user.dart' as model;
import 'package:snap_shield_alpha/providers/user_provider.dart';
import 'package:snap_shield_alpha/resources/firestore_methods.dart';
import 'package:snap_shield_alpha/screens/comments_screen.dart';
import 'package:snap_shield_alpha/screens/profile_screen.dart';
import 'package:snap_shield_alpha/utils/colors.dart';
import 'package:snap_shield_alpha/utils/global_variable.dart';
import 'package:snap_shield_alpha/utils/utils.dart';
import 'package:snap_shield_alpha/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SinglePost extends StatefulWidget {
  final String postId;
  final String profImage;
  final String username;
  final String uid;
  final List likes;
  final String postUrl;
  final String description;
  final int commentLength;
  const SinglePost({
    Key? key,
    required this.postId,
    required this.profImage,
    required this.username,
    required this.uid,
    required this.likes,
    required this.postUrl,
    required this.description,
    required this.commentLength,
  }) : super(key: key);

  @override
  State<SinglePost> createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  // int commentLen = 0;
  bool isLikeAnimating = false;
  // List<String> likes=[];
  var data;
  @override
  void initState() {
    super.initState();
    // fetchCommentLen();
    // likeshere();
  }

  // likeshere() async {
  //   try {
  //     var snapshot =
  //         await FirebaseFirestore.instance.collection('posts').doc('postId');
  //     setState(() {
  //       snapshot.get().then((value) {
  //         data = value.data();
  //       });
  //       likes=data.likes;
  //     });
  //   } catch (err) {
  //     showSnackBar(
  //       context,
  //       err.toString(),
  //     );
  //   }
  //   setState(() {});
  // }

  // fetchCommentLen() async {
  //   try {
  //     QuerySnapshot snap = await FirebaseFirestore.instance
  //         .collection('posts')
  //         .doc('postId')
  //         .collection('comments')
  //         .get();
  //     setState(() {
  //       commentLen = snap.docs.length;
  //       print("object");
  //       print(commentLen);
  //     });
  //   } catch (err) {
  //     showSnackBar(
  //       context,
  //       err.toString(),
  //     );
  //   }
  //   setState(() {});
  // }

  Future deletePost(String postId) async {
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
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: secondaryColor,
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.arrow_back,
        //     color: textColor,
        //   ),
        //   onPressed: () {
        //     nextScreenReplace(context, const ProfileScreen());
        //   },
        // ),
        title: Text(
          "post",
          style: GoogleFonts.kaushanScript(
            // fontWeight: FontWeight.bold,
            fontSize: 30,
            color: textColor,
          ),
        ),
      ),
      body: Container(
        // boundary needed for web
        decoration: BoxDecoration(
          border: Border.all(
            color:
                width > webScreenSize ? secondaryColor : mobileBackgroundColor,
          ),
          color: mobileBackgroundColor,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(
          children: [
            // HEADER SECTION OF THE POST
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ).copyWith(right: 0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(widget.profImage),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget.uid == user.uid
                      ? IconButton(
                          onPressed: () {
                            showDialog(
                              useRootNavigator: false,
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shrinkWrap: true,
                                      children: [
                                        'Delete',
                                      ]
                                          .map(
                                            (e) => InkWell(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  child: Text(e),
                                                ),
                                                onTap: () {
                                                  deletePost(widget.postId).then(
                                                      (value) => nextScreenReplace(
                                                          context,
                                                          const ProfileScreen()));
                                                  // remove the dialog box
                                                }),
                                          )
                                          .toList()),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.more_vert,
                            color: textColor,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            // IMAGE SECTION OF THE POST
            GestureDetector(
              // onDoubleTap: () {
              //   FireStoreMethods().likePost(
              //     widget.postId,
              //     user.uid,
              //     widget.likes,
              //   );
              //   setState(() {

              // isLikeAnimating = true;
              //   });
              // },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // height: MediaQuery.of(context).size.height * 0.35,
                  // width: double.infinity,
                  // child: PhotoView(
                  //   imageProvider: AssetImage(widget.snap['postUrl'].toString(),),
                  // )
                  Image.network(
                    widget.postUrl,
                    fit: BoxFit.fitWidth,
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // LIKE, COMMENT SECTION OF THE POST
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: <Widget>[
            //     LikeAnimation(
            //       isAnimating: widget.likes.contains(user.uid),
            //       smallLike: true,
            //       child: Container(
            //         width: MediaQuery.of(context).size.width * 0.49,
            //         decoration: BoxDecoration(
            //             border: Border.all(),
            //             borderRadius: BorderRadius.circular(2),
            //             color: darkGreyColor),
            //         child: IconButton(
            //           icon: widget.likes.contains(user.uid)
            //               ? const Icon(
            //                   Icons.favorite,
            //                   color: Colors.red,
            //                 )
            //               : const Icon(
            //                   Icons.favorite_border,
            //                 ),
            //           onPressed: () => FireStoreMethods().likePost(
            //             widget.postId,
            //             user.uid,
            //             widget.likes,
            //           ),
            //         ),
            //       ),
            //     ),
            //     Container(
            //       width: MediaQuery.of(context).size.width * 0.49,
            //       decoration: BoxDecoration(
            //           border: Border.all(),
            //           borderRadius: BorderRadius.circular(2),
            //           color: darkGreyColor),
            //       child: IconButton(
            //         icon: const Icon(
            //           Icons.comment_outlined,
            //         ),
            //         onPressed: () => Navigator.of(context).push(
            //           MaterialPageRoute(
            //             builder: (context) => CommentsScreen(
            //               postId: widget.postId,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: 10,
            ),
            //DESCRIPTION AND NUMBER OF COMMENTS
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DefaultTextStyle(
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w800),
                      child: Text(
                        '${widget.likes.length} likes',
                        style: const TextStyle(color: textColor),
                      )),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            text: widget.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          TextSpan(
                            text: ' ${widget.description}',
                            style: const TextStyle(color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'View all ${widget.commentLength} comments',
                        style: const TextStyle(
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                          postId: widget.postId,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
