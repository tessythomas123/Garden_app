import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:garden/services/auth.dart';

class ProductList extends StatefulWidget {
  final String cId;
  ProductList({
    this.cId,
  });
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final AuthServices _auth = AuthServices();
  FirebaseFirestore _firestoreinstance = FirebaseFirestore.instance;
  List<DocumentSnapshot> products = [];
  DocumentSnapshot _lastdocument;
  ScrollController _scrollController = ScrollController();
  int perPage = 7;
  bool _gettingMoreProducts = false;
  bool _moreProductsAvailable = true;

  bool _loadingproducts = true;
  _getProducts() async {
    Query q = _firestoreinstance
        .collection("Categories")
        .doc(widget.cId)
        .collection("Products")
        .orderBy("PId")
        .limit(perPage);

    setState(() {
      _loadingproducts = true;
    });
    QuerySnapshot querySnapshot = await q.get();
    products = querySnapshot.docs;
    if (products.length == 0) {
      setState(() {
        _loadingproducts = false;
      });
    }
    _lastdocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    setState(() {
      _loadingproducts = false;
    });
  }

  _getMoreProducts() async {
    if (_moreProductsAvailable == false) {
      return;
    }
    if (_gettingMoreProducts == true) {
      return;
    }
    _gettingMoreProducts = true;
    Query q = _firestoreinstance
        .collection("Categories")
        .doc(widget.cId)
        .collection("Products")
        .orderBy("PId")
        .startAfter([_lastdocument.data()['PId']]).limit(perPage);
    QuerySnapshot querySnapshot = await q.get();
    if (querySnapshot.docs.length < perPage) {
      _moreProductsAvailable = false;
    }
    _lastdocument = querySnapshot.docs[querySnapshot.docs.length - 1];

    products.addAll(querySnapshot.docs);
    setState(() {
      _gettingMoreProducts = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getProducts();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      if ((maxScroll - currentScroll) <= delta) {
        _getMoreProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_moreProductsAvailable == false) {
      Fluttertoast.showToast(
          msg: "No more products",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Products'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: _loadingproducts
          ? Center(
              child: Text('Loading'),
            )
          : (products.length == 0)
              ? Center(
                  child: Text('No Products'),
                )
              : Container(
                  margin: EdgeInsets.only(top: 20),
                  child: ListView.builder(
                    itemCount: products.length,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: const EdgeInsets.only(
                              bottom: 10.0,
                              left: 5.0,
                              right: 5.0), //Same as `blurRadius` i guess
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 8.0,
                              ),
                            ],
                          ),

                          child: ListTile(
                            leading: Container(
                                width: 40,
                                child: FadeInImage.assetNetwork(
                                    placeholder:
                                        'assets/product_placeholder.png',
                                    image: products[index].data()['Pimage'])),
                            title: Text(products[index].data()['Pname']),
                            subtitle: Text('Product Id: ' +
                                products[index].data()['PId'].toString() +
                                '\nprize: ' +
                                products[index].data()['Prize'].toString() +
                                '\nQuantity: ${products[index].data()['Quantity']}'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
