import 'package:flutter/material.dart';
import 'package:garden/Filter/drawer.dart';
import 'package:garden/adminupdate.dart';
import 'package:garden/models/user.dart';

class AdminPage extends StatefulWidget {
  final MyUser user;
  AdminPage({this.user});
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Profile'),
      ),
      drawer: MainDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              height: 110,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: FadeInImage.assetNetwork(
                  placeholder: 'assets/user_placeholder.png',
                  image: widget.user.image),
            ),
          ),
          Center(
            child: Text(widget.user.name),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.blueGrey,
            height: 2,
            width: MediaQuery.of(context).size.width,
          ),
          IconButton(
            onPressed: () => {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminUpdate(
                      user: widget.user,
                    ),
                  ))
            },
            icon: Icon(Icons.edit),
          ),
          SizedBox(
            height: 40,
          ),
          Center(
            child: Text(
              'Contact Info\n',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '      Address:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text('                            ' +
              widget.user.address['houseName'] +
              '\n                           ' +
              widget.user.address['street'] +
              '\n                           ' +
              widget.user.address['district'] +
              '\n                           ' +
              widget.user.address['pincode']),
          Text(
            '\n      Phone Number:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
              '                                       ${widget.user.phonenumber}'),
        ],
      ),
    );
  }
}
