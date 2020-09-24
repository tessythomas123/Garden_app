import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garden/models/Category.dart';
import 'package:garden/models/order.dart';
import 'package:garden/models/product.dart';

class DatabaseService {
  final String uid;
  final String cId;
  final int pId;

  DatabaseService({this.uid, this.cId, this.pId});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');
  final Query orderCollection1 =
      FirebaseFirestore.instance.collectionGroup('Orders');

  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('Categories');

  Future<void> updateUserData(
      String name, String imageUrl, Map address, String phonenumber) async {
    try {
      return await userCollection.doc(uid).set({
        'Uname': name,
        'Uimage': imageUrl,
        'Upno': phonenumber,
        'Add1': address,
        'ProductsInCart': 0
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addProductData(String name, int quantity, int prize,
      String image, String features) async {
    try {
      return await categoryCollection
          .doc(cId)
          .collection('Products')
          .doc(pId.toString())
          .set({
        'PId': pId,
        'Pname': name,
        'Quantity': quantity,
        'Prize': prize,
        'Pimage': image,
        'Features': features
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> updateProductData(String name, int quantity, int prize,
      String image, String features) async {
    try {
      return await categoryCollection
          .doc(cId)
          .collection('Products')
          .doc(pId.toString())
          .update({
        'PId': pId,
        'Pname': name,
        'Quantity': quantity,
        'Prize': prize,
        'Pimage': image,
        'Features': features
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> deleteCategory(String cId) {
    try {
      return categoryCollection.doc(cId).delete();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> deleteProduct(String cid, String pid) {
    try {
      return categoryCollection
          .doc(cid)
          .collection('Products')
          .doc(pid)
          .delete();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> addCategoryData(String name, String id, String image) async {
    try {
      return await categoryCollection
          .doc(cId)
          .set({'CId': id, 'Cname': name, 'Cimage': image});
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> updateCategoryData(String name, String id, String image) async {
    try {
      return await categoryCollection
          .doc(cId)
          .update({'CId': id, 'Cname': name, 'Cimage': image});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateUser(
      String name, String image, Map address, String phonenumber) async {
    try {
      return await userCollection.doc(uid).update({
        'Uname': name,
        'Uimage': image,
        'Add1': address,
        'Upno': phonenumber
      });
    } catch (e) {
      print(e.toString());
    }
  }

  List<Category> _categoryListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        //print(doc.data);
        return Category(
          cname: doc.data()['Cname'] ?? '',
          cId: doc.data()['CId'] ?? '',
          cimage: doc.data()['Cimage'] ?? '',
        );
      }).toList();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  List<Product> _productListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return Product(
          pname: doc.data()['Pname'] ?? '',
          pid: doc.data()['PId'] ?? 0,
          image: doc.data()['Pimage'] ?? '',
          features: doc.data()['Features'] ?? '',
          prize: doc.data()['Prize'] ?? 0,
          quantity: doc.data()['Quantity'] ?? 0,
        );
      }).toList();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  List<POrder> _orderListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        //print(doc.data);
        return POrder(
          pname: doc.data()['Pname'] ?? '',
          pId: doc.data()['PId'] ?? 0,
          imageUrl: doc.data()['Pimage'] ?? '',
          features: doc.data()['Features'] ?? '',
          orderdate: doc.data()['OrderDate'].toDate() ?? DateTime.now(),
          address: doc.data()['Address'] ?? {},
          prize: doc.data()['Prize'] ?? 0,
          quantity: doc.data()['Quantity'] ?? 0,
          status: doc.data()['Status'] ?? '',
          phonenumber: doc.data()['phonenumber'] ?? '',
        );
      }).toList();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // get brews stream
  Stream<List<Category>> get categories {
    return categoryCollection.snapshots().map(_categoryListFromSnapshot);
  }

  Stream<List<Product>> get products {
    return categoryCollection
        .doc(cId)
        .collection('Products')
        .snapshots()
        .map(_productListFromSnapshot);
  }

  Stream<List<POrder>> get porders {
    return orderCollection1.snapshots().map((_orderListFromSnapshot));
  }
}
