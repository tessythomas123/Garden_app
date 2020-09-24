import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:garden/models/user.dart';
import 'package:garden/services/database.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore store = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  MyUser _userFromFirebaseUser(user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<MyUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);

    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password,
      String name, File image, Map address, String phonenumber) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      imageAdd(image, name).then((value) async {
        await DatabaseService(uid: user.uid)
            .updateUserData(name, value, address, phonenumber);
      });
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future addCategory(String cid, String cname, File cimage) async {
    try {
      imageAdd(cimage, cname).then((value) async {
        await DatabaseService(cId: cid).addCategoryData(cname, cid, value);
      });
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<String> imageAdd(File img, String name) async {
    final StorageReference reference = storage.ref().child(name + ".jpg");
    final StorageUploadTask task = reference.putFile(img);
    var url = await (await task.onComplete).ref.getDownloadURL();
    return url.toString();
  }

  Future<String> imageUpdate(File img, String name) async {
    final StorageReference reference = storage.ref().child(name + ".jpg");
    reference.delete();
    final StorageUploadTask task = reference.putFile(img);
    var url = await (await task.onComplete).ref.getDownloadURL();
    return url.toString();
  }

  Future addProduct(String cid, int pid, String pname, int quantity, int prize,
      File image, String features) async {
    try {
      imageAdd(image, pname).then((value) async {
        await DatabaseService(cId: cid, pId: pid)
            .addProductData(pname, quantity, prize, value, features);
      });
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateProduct(String cid, int pid, String pname, int quantity,
      int prize, File image, String imgMssg, String features) async {
    try {
      if (image != null) {
        imageUpdate(image, pname).then((value) async {
          await DatabaseService(cId: cid, pId: pid)
              .updateProductData(pname, quantity, prize, value, features);
        });
      } else {
        await DatabaseService(cId: cid, pId: pid)
            .updateProductData(pname, quantity, prize, imgMssg, features);
      }
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateCategory(
      String cid, String cname, File cimage, String imgMssg) async {
    try {
      if (cimage != null) {
        imageUpdate(cimage, cname).then((value) async {
          await DatabaseService(cId: cid).updateCategoryData(cname, cid, value);
        });
      } else {
        await DatabaseService(cId: cid).updateCategoryData(cname, cid, imgMssg);
      }
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateUser(String uid, String uname, File uimage, String imgMssg,
      Map address, String pno) async {
    try {
      if (uimage != null) {
        imageUpdate(uimage, uname).then((value) async {
          await DatabaseService(uid: uid)
              .updateUser(uname, value, address, pno);
        });
      } else {
        await DatabaseService(uid: uid)
            .updateUser(uname, imgMssg, address, pno);
      }
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
