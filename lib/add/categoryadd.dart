import 'dart:io';

import 'package:flutter/material.dart';
import 'package:garden/Filter/drawer.dart';
import 'package:garden/orderlist.dart';
import 'package:garden/services/auth.dart';
import 'package:image_picker/image_picker.dart';

class AddCategory extends StatefulWidget {
  final String imgMssg;
  final String idMssg;
  final String nameMssg;
  final bool update;
  AddCategory({this.idMssg, this.imgMssg, this.nameMssg, this.update});
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _formKey = GlobalKey<FormState>();
  String cname = "";
  String cid = "";
  String error = "";
  final AuthServices _auth = AuthServices();
  File imageFile;
  String btnMssg;
  String titleMSsg;

  bool _cnameChanged = false;
  bool _cidChanged = false;

  final imagePicker = ImagePicker();
  @override
  void initState() {
    if (widget.update) {
      btnMssg = 'Update';
      titleMSsg = 'Update Category';
    } else {
      btnMssg = 'Add';
      titleMSsg = 'Add Category';
    }
    super.initState();
  }

  void _openGallery(BuildContext context) async {
    var picture = File(await imagePicker
        .getImage(source: ImageSource.gallery)
        .then((pickedFile) => pickedFile.path));
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    var picture = File(await imagePicker
        .getImage(source: ImageSource.camera)
        .then((pickedFile) => pickedFile.path));
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose the image:"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _openCamera(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _imageView() {
    if (widget.update) {
      if (imageFile == null) {
        return Column(
          children: <Widget>[
            Padding(
              padding: new EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.10,
                  MediaQuery.of(context).size.height * 0.10,
                  MediaQuery.of(context).size.width * 0.10,
                  MediaQuery.of(context).size.height * 0.05),
              child: Image.network(widget.imgMssg,
                  height: MediaQuery.of(context).size.height * 0.30),
            ),
            RaisedButton(
              child: Text("Update Image"),
              textColor: Colors.white,
              color: Colors.blue[900],
              onPressed: () {
                _showChoiceDialog(context);
              },
            )
          ],
        );
      } else {
        return Padding(
          padding: new EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.10,
              MediaQuery.of(context).size.height * 0.10,
              MediaQuery.of(context).size.width * 0.10,
              MediaQuery.of(context).size.height * 0.05),
          child: Image.file(imageFile,
              height: MediaQuery.of(context).size.height * 0.30),
        );
      }
    } else {
      if (imageFile == null) {
        return Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
          child: Column(
            children: [
              SizedBox(height: 30),
              TextFormField(
                  decoration: new InputDecoration(
                      icon: const Icon(Icons.image),
                      hintText: 'Category Image',
                      labelText: 'Category Image',
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                        borderSide: new BorderSide(),
                      ))),
              RaisedButton(
                child: Text("Insert Image"),
                textColor: Colors.white,
                color: Colors.blue[900],
                onPressed: () {
                  _showChoiceDialog(context);
                },
              )
            ],
          ),
        );
      } else {
        return Padding(
          padding: new EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.10,
              MediaQuery.of(context).size.height * 0.10,
              MediaQuery.of(context).size.width * 0.10,
              MediaQuery.of(context).size.height * 0.05),
          child: Image.file(imageFile,
              height: MediaQuery.of(context).size.height * 0.30),
        );
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleMSsg),
        backgroundColor: Colors.green,
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
              Center(
                child: _imageView(),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                child: TextFormField(
                  initialValue: widget.idMssg,
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.info),
                    hintText: 'Category Id',
                    labelText: ' Category Id',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() => {cid = val, _cidChanged = true});
                  },
                  validator: (value) {
                    if (!_cidChanged) {
                      setState(() {
                        cid = widget.idMssg;
                      });
                    }
                    if (value.isEmpty) {
                      return 'Please enter category id';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
                child: TextFormField(
                  initialValue: widget.nameMssg,
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.label),
                    hintText: 'Category Name',
                    labelText: 'Category Name',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() => {cname = val, _cnameChanged = true});
                  },
                  validator: (value) {
                    if (!_cnameChanged) {
                      setState(() {
                        cname = widget.nameMssg;
                      });
                    }
                    if (value.isEmpty) {
                      return 'Please enter category name';
                    }
                    return null;
                  },
                ),
              ),
              new Container(
                padding: const EdgeInsets.only(left: 130, top: 40.0),
                child: new RaisedButton(
                    child: Text(
                      btnMssg,
                    ),
                    textColor: Colors.white,
                    color: Colors.green[900],
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    disabledColor: Colors.grey[500],
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        if (widget.update) {
                          await _auth.updateCategory(
                              cid, cname, imageFile, widget.imgMssg);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderList(),
                              ));
                        } else {
                          await _auth.addCategory(cid, cname, imageFile);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderList(),
                              ));
                        }
                      }
                    }),
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
