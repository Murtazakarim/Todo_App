import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToDoItem extends StatelessWidget {
  String? _itemName;
  String? _dateCreated;
  int? _id;

  ToDoItem(this._itemName, this._dateCreated);
  //RUN TIME GETTING VALUES
  ToDoItem.map(dynamic obj) {
    this._itemName = obj['itemName'];
    this._dateCreated = obj['dateCreated'];
    this._id = obj['id'];
  }

  void setId(int id) {
    this._id = id;
  }

  // GETTER
  String get itemName => _itemName!;
  String get dateCreated => _dateCreated!;
  int get id => _id!;
//MAP ADDING VALUES
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['itemName'] = _itemName;
    map['dateCreated'] = _dateCreated;
    if (_id != null) {
      map['id'] = _id;
    }
    print(map.toString());
    return map;
  }

  //MAP VALUES SHIFTING IN TODOiTEM
  ToDoItem.fromMap(Map<String, dynamic> map) {
    print(map.toString());
    this._itemName = map['itemName'];
    this._dateCreated = map['dateCreated'];
    this._id = map['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _itemName!,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.9,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(
                  'Created on: ${_dateCreated!}',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
