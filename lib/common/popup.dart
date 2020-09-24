import 'package:flutter/material.dart';
import 'package:garden/models/order.dart';

Future buildAboutDialog(BuildContext context, POrder order) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return new AlertDialog(
        title: const Text('Contact Info'),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Address:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('      ' +
                order.address['houseName'] +
                '\n      ' +
                order.address['street'] +
                '\n      ' +
                order.address['district'] +
                '\n      ' +
                order.address['pincode']),
            Text(
              'Phone number:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('       ' + order.phonenumber),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}

int totalOrder(int q, int p) {
  int total = 0;
  total = q * p;
  return total;
}
