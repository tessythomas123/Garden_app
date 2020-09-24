import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:garden/Filter/drawer.dart';
import 'package:garden/orderlist.dart';
import 'package:garden/services/auth.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  final String imgMssg;
  final String pidMssg;
  final String cidMssg;
  final String nameMssg;
  final String featureMssg;
  final String qtyMssg;
  final String prizeMssg;
  final bool update;

  AddProduct(
      {this.imgMssg,
      this.nameMssg,
      this.cidMssg,
      this.featureMssg,
      this.pidMssg,
      this.prizeMssg,
      this.qtyMssg,
      this.update});
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  String pname = "";
  int pid = 0;
  String cid = "";
  String pfeatures = "";
  int pquantity = 0;
  int prize = 0;
  String error = "";
  bool _pidChanged = false;
  bool _pnameChanged = false;
  bool _cidChanged = false;
  bool _quantityChanged = false;
  bool _featuresChanged = false;
  bool _prizeChanged = false;
  String btnMssg;
  String titleMssg;
  final AuthServices _auth = AuthServices();
  File imageFile;
  final imagePicker = ImagePicker();
  @override
  void initState() {
    if (widget.update) {
      btnMssg = 'Update';
      titleMssg = 'Update Product';
    } else {
      btnMssg = 'Add';
      titleMssg = 'Add Product';
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
                      hintText: 'Product Image',
                      labelText: 'Product Image',
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleMssg),
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
              Center(child: _imageView()),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                child: TextFormField(
                  initialValue: widget.pidMssg,
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.info),
                    hintText: ' Product Id',
                    labelText: ' Product Id',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() => {
                          pid = int.parse(val),
                          _pidChanged = true,
                        });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter product id';
                    }
                    if (!_pidChanged) {
                      setState(() {
                        pid = int.parse(widget.pidMssg);
                      });
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                child: TextFormField(
                  initialValue: widget.cidMssg,
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
                        cid = widget.cidMssg;
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
                    hintText: 'Product Name',
                    labelText: 'Product Name',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() => {pname = val, _pnameChanged = true});
                  },
                  validator: (value) {
                    if (!_pnameChanged) {
                      setState(() {
                        pname = widget.nameMssg;
                      });
                    }
                    if (value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
                child: TextFormField(
                  initialValue: widget.featureMssg,
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.details),
                    hintText: 'Features',
                    labelText: 'Features',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() => {pfeatures = val, _featuresChanged = true});
                  },
                  validator: (value) {
                    if (!_featuresChanged) {
                      setState(() {
                        pfeatures = widget.featureMssg;
                      });
                    }
                    if (value.isEmpty) {
                      return 'Please enter product features';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
                child: TextFormField(
                  initialValue: widget.qtyMssg,
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.shopping_cart),
                    hintText: 'Quantity',
                    labelText: 'Quantity',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() =>
                        {pquantity = int.parse(val), _quantityChanged = true});
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter available stock';
                    }
                    if (!_quantityChanged) {
                      setState(() {
                        pquantity = int.parse(widget.qtyMssg);
                      });
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
                child: TextFormField(
                  initialValue: widget.prizeMssg,
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.euro_symbol),
                    hintText: 'Prize',
                    labelText: 'Prize',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  onChanged: (val) {
                    setState(
                        () => {prize = int.parse(val), _prizeChanged = true});
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the prize';
                    }
                    if (!_prizeChanged) {
                      setState(() {
                        prize = int.parse(widget.prizeMssg);
                      });
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
                          await _auth.updateProduct(cid, pid, pname, pquantity,
                              prize, imageFile, widget.imgMssg, pfeatures);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderList(),
                              ));
                        } else {
                          await _auth.addProduct(cid, pid, pname, pquantity,
                              prize, imageFile, pfeatures);
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
