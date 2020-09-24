import 'dart:io';

import 'package:flutter/material.dart';
import 'package:garden/models/user.dart';
import 'package:garden/orderlist.dart';
import 'package:garden/services/auth.dart';
import 'package:image_picker/image_picker.dart';

class AdminUpdate extends StatefulWidget {
  final MyUser user;
  AdminUpdate({this.user});
  _AdminUpdatestate createState() => _AdminUpdatestate();
}

class _AdminUpdatestate extends State<AdminUpdate> {
  String error = '';
  bool loading = false;
  String name = "";
  String imageUrl = "";
  String houseName = "";
  String streetName = "";
  String district = "";
  String pincode = "";
  String pno = "";
  bool _nameChanged = false;
  bool _housenameChanged = false;
  bool _streetChanged = false;
  bool _districtChanged = false;
  bool _pincodeChanged = false;
  bool _pnoChanged = false;
  File imageFile;

  final _formKey = GlobalKey<FormState>();

  final AuthServices _auth = AuthServices();
  final imagePicker = ImagePicker();
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
    if (imageFile == null) {
      return Column(
        children: <Widget>[
          Padding(
            padding: new EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.10,
                MediaQuery.of(context).size.height * 0.10,
                MediaQuery.of(context).size.width * 0.10,
                MediaQuery.of(context).size.height * 0.05),
            child: Image.network(widget.user.image,
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
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Center(child: _imageView()),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: TextFormField(
                  initialValue: widget.user.name,
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: ' Name',
                    labelText: ' Name',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() => {name = val, _nameChanged = true});
                  },
                  validator: (value) {
                    if (!_nameChanged) {
                      setState(() {
                        name = widget.user.name;
                      });
                    }
                    if (value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                child: TextFormField(
                  initialValue: widget.user.address['houseName'],
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.home),
                    hintText: ' House Name',
                    labelText: 'House Name',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() => {houseName = val, _housenameChanged = true});
                  },
                  validator: (value) {
                    if (!_housenameChanged) {
                      setState(() {
                        houseName = widget.user.address['houseName'];
                      });
                    }
                    if (value.isEmpty) {
                      return 'Please enter house name';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                child: TextFormField(
                  initialValue: widget.user.address['street'],
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.home),
                    hintText: 'Street Name  ',
                    labelText: 'Street Name  ',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() => {
                          streetName = val,
                          _streetChanged = true,
                        });
                  },
                  validator: (value) {
                    if (!_streetChanged) {
                      setState(() {
                        streetName = widget.user.address['street'];
                      });
                    }
                    if (value.isEmpty) {
                      return 'Please enter street name and number';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                child: TextFormField(
                  initialValue: widget.user.address['district'],
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.home),
                    hintText: 'District',
                    labelText: 'District',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() => {district = val, _districtChanged = true});
                  },
                  validator: (value) {
                    if (!_districtChanged) {
                      setState(() {
                        district = widget.user.address['district'];
                      });
                    }
                    if (value.isEmpty) {
                      return 'Please enter district';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                child: TextFormField(
                  initialValue: widget.user.address['pincode'],
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.mail),
                    hintText: 'Pincode',
                    labelText: 'Pincode',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    setState(() => {pincode = val, _pincodeChanged = true});
                  },
                  validator: (value) {
                    if (!_pincodeChanged) {
                      setState(() {
                        pincode = widget.user.address['pincode'];
                      });
                    }
                    if (value.length != 6) {
                      return 'Please enter a valid Pincode';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                child: TextFormField(
                  initialValue: widget.user.phonenumber,
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.phone),
                    hintText: 'Phone Number',
                    labelText: 'Phone Number',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    setState(() => {pno = val, _pnoChanged = true});
                  },
                  validator: (value) {
                    if (!_pnoChanged) {
                      setState(() {
                        pno = widget.user.phonenumber;
                      });
                    }
                    if (value.length != 10) {
                      return 'Please enter a valid Phone Number';
                    }
                    return null;
                  },
                ),
              ),
              new Container(
                padding: const EdgeInsets.only(left: 130, top: 40.0),
                child: new RaisedButton(
                    child: const Text(
                      "Update",
                    ),
                    textColor: Colors.white,
                    color: Colors.green[900],
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    disabledColor: Colors.grey[500],
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await _auth.updateUser(
                            widget.user.uid,
                            name,
                            imageFile,
                            widget.user.image,
                            {
                              'houseName': houseName,
                              'street': streetName,
                              'district': district,
                              'pincode': pincode
                            },
                            pno);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderList(),
                            ));
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
