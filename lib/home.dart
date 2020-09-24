import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:garden/orderlist.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget build(context) {
    return Scaffold(
      body: OrderList(),
    );
  }
}
