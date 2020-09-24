import 'package:flutter/material.dart';
import 'package:garden/Filter/drawer.dart';
import 'package:garden/models/Category.dart';
import 'package:garden/productlist.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String cId;

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<List<Category>>(context);
    if (categories == null) {
      return Center(child: Text("Loading"));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Categories'),
          backgroundColor: Colors.green,
        ),
        drawer: MainDrawer(),
        body: new GridView.builder(
          itemCount: categories.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.7),
          ),
          itemBuilder: (BuildContext context, int index) {
            return GridTile(
              child: Flex(
                direction: Axis.vertical,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      setState(() {
                        cId = categories[index].cId;
                      });

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductList(
                              cId: cId,
                            ),
                          ));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.13,
                            width: 130,
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/product_placeholder.png',
                              image: categories[index].cimage,
                              width: 130,
                            ),
                          ),
                          Text(
                            categories[index].cname,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Category Id: ' + categories[index].cId,
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                            style: BorderStyle.solid,
                            color: Colors.blueGrey,
                            width: 1.0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }
}
