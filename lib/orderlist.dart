import 'package:flutter/material.dart';
import 'package:garden/Filter/drawer.dart';
import 'package:garden/Filter/settingfilter.dart';
import 'package:garden/common/popup.dart';

import 'package:garden/models/filter_model.dart';
import 'package:garden/models/order.dart';

import 'package:garden/services/auth.dart';
import 'package:provider/provider.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final AuthServices _auth = AuthServices();
  List<POrder> orders = [];
  int pendingOrders = 0;

  @override
  Widget build(BuildContext context) {
    final orderslist = Provider.of<List<POrder>>(context);
    final fm = Provider.of<FilterModel>(context);

    if (orderslist == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Orders',
            style: TextStyle(fontSize: 22),
          ),
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
        body: Center(
          child: Text('Loading.......'),
        ),
      );
    } else {
      pendingOrders = getPendingOrderCount(orderslist);
      orders = statusFilter(fm.getStatusFilter(), orderslist);
      orders = dateFilter(fm.getDateFilter(), orders);

      return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Column(children: [
            Text(
              'Orders',
              style: TextStyle(fontSize: 22),
            ),
            Text(
              'pending: ($pendingOrders)',
              style: TextStyle(fontSize: 12),
            )
          ]),
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
        body: Container(
          margin: EdgeInsets.only(top: 20),
          child: ListView.builder(
            itemCount: orders.length,
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
                    leading: FadeInImage.assetNetwork(
                      placeholder: "assets/product_placeholder.png",
                      image: orders[index].imageUrl,
                    ),
                    title: Text(
                      orders[index].pname,
                      style: TextStyle(fontSize: 15),
                    ),
                    subtitle: Text(
                      'Id: ' +
                          orders[index].pId.toString() +
                          '   Quantity: ${orders[index].quantity}' +
                          '\nOrdered on: ' +
                          orders[index].orderdate.toString().substring(0, 10) +
                          '\nTotal Amount: ${totalOrder(orders[index].prize, orders[index].quantity)}' +
                          '\nStatus: ${orders[index].status}',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: Container(
                      width: 20,
                      height: 40,
                      child: IconButton(
                        onPressed: () {
                          buildAboutDialog(context, orders[index]);
                        },
                        icon: Icon(
                          Icons.contact_phone,
                          color: Colors.green[900],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
