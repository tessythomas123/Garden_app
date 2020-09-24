import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:garden/common/loading_screen.dart';
import 'package:garden/services/auth.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationForm extends StatefulWidget {
  @override
  RegistrationFormState createState() {
    return RegistrationFormState();
  }
}

class RegistrationFormState extends State<RegistrationForm> {
  String error = '';
  bool loading = false;
  String email = "";
  String password = "";
  String name = "";
  String imageUrl = "";
  String houseName = "";
  String streetName = "";
  String district = "";
  String pincode = "";
  String pno = "";

  final _formKey = GlobalKey<FormState>();
  //final TextEditingController _pass = TextEditingController();
  //final TextEditingController _username = TextEditingController();
  final AuthServices _auth = AuthServices();

  void initState() {
    super.initState();
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  File imageFile;
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
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
        child: Column(
          children: [
            SizedBox(height: 30),
            TextFormField(
                decoration: new InputDecoration(
                    icon: const Icon(Icons.image),
                    hintText: "User Image",
                    labelText: 'User Image',
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

  @override
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
              _imageView(),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: TextFormField(
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
                    setState(() => name = val);
                  },
                  validator: (value) {
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
                    setState(() => houseName = val);
                  },
                  validator: (value) {
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
                    setState(() => streetName = val);
                  },
                  validator: (value) {
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
                    setState(() => district = val);
                  },
                  validator: (value) {
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
                    setState(() => pincode = val);
                  },
                  validator: (value) {
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
                    setState(() => pno = val);
                  },
                  validator: (value) {
                    if (value.length != 10) {
                      return 'Please enter a valid Phone Number';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                child: TextFormField(
                    decoration: new InputDecoration(
                      icon: const Icon(Icons.mail),
                      hintText: 'example@gmail.com',
                      labelText: 'Email',
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                    validator: (value) {
                      if (!validateEmail(value)) {
                        return 'not a valid email';
                      } else {
                        return null;
                      }
                    }),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                child: TextFormField(
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.lock),
                    hintText: 'Password',
                    labelText: 'Password',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  obscureText: true,
                  validator: (val) =>
                      val.length < 6 ? 'Enter a password 6+ chars long' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
              ),
              new Container(
                padding: const EdgeInsets.only(left: 130, top: 40.0),
                child: new RaisedButton(
                    child: const Text(
                      "Register",
                    ),
                    textColor: Colors.white,
                    color: Colors.green[900],
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    disabledColor: Colors.grey[500],
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() => loading = true);
                        dynamic result =
                            await _auth.registerWithEmailAndPassword(
                                email,
                                password,
                                name,
                                imageFile,
                                {
                                  'houseName': houseName,
                                  'street': streetName,
                                  'district': district,
                                  'pincode': pincode
                                },
                                pno);
                        if (result == null) {
                          setState(() {
                            loading = false;
                            error = 'Please supply a valid email';
                          });
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
