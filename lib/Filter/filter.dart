import 'package:flutter/material.dart';
import 'package:garden/Filter/drawer.dart';
import 'package:garden/models/filter_model.dart';
import 'package:garden/orderlist.dart';
import 'package:provider/provider.dart';

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  Widget _buildSwitchListTile(
      String title, bool currentValue, Function updateValue) {
    return SwitchListTile(
      activeColor: Colors.green,
      title: Text(
        title,
        style: TextStyle(color: Colors.green[900]),
      ),
      value: currentValue,
      onChanged: updateValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fm = Provider.of<FilterModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Your Filters'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderList(),
                  ));
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: Container(
          child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                _buildSwitchListTile('By Latest', fm.getDateFilter(),
                    (newValue) {
                  fm.setDateFilter(newValue);
                }),
                _buildSwitchListTile('Pending orders', fm.getStatusFilter(),
                    (newValue) {
                  fm.setStatusFilter(newValue);
                }),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
