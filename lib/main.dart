import 'package:flutter/material.dart';
import 'package:garden/models/Category.dart';
import 'package:garden/models/filter_model.dart';
import 'package:garden/models/order.dart';
import 'package:garden/models/product.dart';
import 'package:garden/models/user.dart';
import 'package:garden/services/auth.dart';
import 'package:garden/services/database.dart';
import 'package:garden/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => new FilterModel(),
      child: StreamProvider<MyUser>.value(
        value: AuthServices().user,
        child: StreamProvider<List<Category>>.value(
          value: DatabaseService().categories,
          child: StreamProvider<List<Product>>.value(
            value: DatabaseService().products,
            child: StreamProvider<List<POrder>>.value(
              value: DatabaseService().porders,
              child: MaterialApp(
                title: 'Home',
                theme: ThemeData(
                  primarySwatch: Colors.green,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: Wrapper(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
