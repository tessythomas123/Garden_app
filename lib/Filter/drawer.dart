import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garden/Filter/filter.dart';
import 'package:garden/add/categoryadd.dart';
import 'package:garden/add/productadd.dart';
import 'package:garden/admin.dart';
import 'package:garden/categorylist.dart';
import 'package:garden/models/user.dart';
import 'package:garden/orderlist.dart';
import 'package:garden/remove/categoryremove.dart';
import 'package:garden/remove/productremove.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatefulWidget {
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final firestoreInstance = FirebaseFirestore.instance;
  MyUser muser;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 150,
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 30),
            child: Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.green[900],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              size: 20,
            ),
            title: Text(
              'Admin Account',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              await firestoreInstance
                  .collection("Users")
                  .doc(user.uid)
                  .get(GetOptions(source: Source.server))
                  .then((value) => {
                        muser = MyUser(
                          address: value.data()['Add1'],
                          name: value.data()['Uname'],
                          phonenumber: value.data()['Upno'],
                          image: value.data()['Uimage'],
                        ),
                      });
              print(muser.image);
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminPage(user: muser),
                  ));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.shopping_cart,
              size: 20,
            ),
            title: Text(
              'Orders',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderList(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.category,
              size: 20,
            ),
            title: Text(
              'Categories',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryList(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.plus_one,
              size: 20,
            ),
            title: Text(
              'Add Category',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCategory(
                      imgMssg: '',
                      idMssg: '',
                      nameMssg: '',
                      update: false,
                    ),
                  ));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.update,
              size: 20,
            ),
            title: Text(
              'Update Category',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryRemove(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.plus_one,
              size: 20,
            ),
            title: Text(
              'Add Product ',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProduct(
                      pidMssg: '',
                      imgMssg: '',
                      cidMssg: '',
                      nameMssg: '',
                      featureMssg: '',
                      qtyMssg: '',
                      prizeMssg: '',
                      update: false,
                    ),
                  ));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.update,
              size: 20,
            ),
            title: Text(
              'Update Product ',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductRemove(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 20,
            ),
            title: Text(
              'Filters',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Filter(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
