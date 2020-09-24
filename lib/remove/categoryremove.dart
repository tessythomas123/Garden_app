import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:garden/Filter/drawer.dart';
import 'package:garden/add/categoryadd.dart';
import 'package:garden/home.dart';
import 'package:garden/services/database.dart';

class CategoryRemove extends StatefulWidget {
  _CategoryRemoveState createState() => _CategoryRemoveState();
}

class _CategoryRemoveState extends State<CategoryRemove> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService dbs = new DatabaseService();
  String cId = "";
  String _idMssg;
  String _nameMssg;
  String _imgMssg;
  final firestoreInstance = FirebaseFirestore.instance;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            'Update Category',
          )),
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
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            dbs.deleteCategory(cId);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Home(),
                                ));
                          }
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
                                  .get()
                                  .then(
                                (value) {
                                  setState(
                                    () {
                                      _idMssg = value.data()['CId'];
                                      _nameMssg = value.data()['Cname'];
                                      _imgMssg = value.data()['Cimage'];
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddCategory(
                                              imgMssg: _imgMssg,
                                              idMssg: _idMssg,
                                              nameMssg: _nameMssg,
                                              update: true,
                                            ),
                                          ));
                                    },
                                  );
                                },
                              );
                            }
                            if (_idMssg == "") {
                              throw "error";
                            }
                          } catch (e) {
                            Fluttertoast.showToast(
                                msg: "No such category",
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
