import 'package:flutter/material.dart';
import 'package:garden/bottom_navigation.dart';
import 'package:garden/home.dart';
import 'package:garden/models/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    // return either the Home or Authenticate widget
    if (user == null) {
      return BottomNavigation();
    } else {
      return Home();
    }
  }
}
