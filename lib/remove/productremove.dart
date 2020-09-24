import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:garden/Filter/drawer.dart';
import 'package:garden/add/productadd.dart';
import 'package:garden/orderlist.dart';
import 'package:garden/services/database.dart';

class ProductRemove extends StatefulWidget {
  _ProductRemoveState createState() => _ProductRemoveState();
}

class _ProductRemoveState extends State<ProductRemove> {
  final firestoreInstance = FirebaseFirestore.instance;
  String _imgMssg = "";
  String _pidMssg = "";

  String _nameMssg = "";
  String _featureMssg = "";
  String _qtyMssg = "";
  String _prizeMssg = "";

  final _formKey = GlobalKey<FormState>();
  final DatabaseService dbs = new DatabaseService();
  String pId = "";
  String cId = "";
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Update Product'),
      ),
      drawer: MainDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                child: TextFormField(
                    decoration: new InputDecoration(
                      icon: const Icon(Icons.category),
                      hintText: 'Product Id',
                      labelText: 'Product Id',
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() => pId = val);
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Product id cannot be empty';
                      } else {
                        return null;
                      }
                    }),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                child: TextFormField(
                    decoration: new InputDecoration(
                      icon: const Icon(Icons.category),
                      hintText: 'Category Id',
                      labelText: 'Category Id',
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() => cId = val);
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Category id cannot be empty';
                      } else {
                        return null;
                      }
                    }),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: RaisedButton(
                        color: Colors.green[900],
                        onPressed: () async {
                          await dbs.deleteProduct(cId, pId);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderList(),
                              ));
                        },
                        child: Text('Delete'),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: RaisedButton(
                        color: Colors.green[900],
                        onPressed: () async {
                          try {
                            if (_formKey.currentState.validate()) {
                              await firestoreInstance
                                  .collection('Categories')
                                  .doc(cId)
                                  .collection('Products')
                                  .doc(pId)
                                  .get()
                                  .then((value) => {
                                        setState(() {
                                          _pidMssg =
                                              value.data()['PId'].toString();
                                          _nameMssg = value.data()['Pname'];
                                          _featureMssg =
                                              value.data()['Features'];
                                          _qtyMssg = value
                                              .data()['Quantity']
                                              .toString();
                                          _prizeMssg =
                                              value.data()['Prize'].toString();
                                          _imgMssg = value.data()['Pimage'];
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddProduct(
                                                  pidMssg: _pidMssg,
                                                  nameMssg: _nameMssg,
                                                  featureMssg: _featureMssg,
                                                  qtyMssg: _qtyMssg,
                                                  prizeMssg: _prizeMssg,
                                                  imgMssg: _imgMssg,
                                                  cidMssg: cId,
                                                  update: true,
                                                ),
                                              ));
                                        }),
                                        if (_pidMssg == "") {throw 'error'}
                                      });
                            }
                          } catch (e) {
                            print(e.toString());
                            Fluttertoast.showToast(
                                msg: "No such product",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        child: Text('Update'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
