import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snap_shield_alpha/screens/add_post_screen.dart';
import 'package:snap_shield_alpha/screens/feed_screen.dart';
import 'package:snap_shield_alpha/screens/profile_screen.dart';
import 'package:snap_shield_alpha/screens/message/search_page.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchPage(),
  const AddPostScreen(),
  ProfileScreen(),
];
