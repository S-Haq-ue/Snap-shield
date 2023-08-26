import 'package:flutter/material.dart';

class UserAlert {
  AlertingUser(bool isToxic,bool isInformative){
    if(isToxic){
      AlertDialog(title: Text("Selected image contains toxic data"),);
    }
  }
}