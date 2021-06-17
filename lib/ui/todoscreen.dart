import 'package:flutter/material.dart';
import 'package:todoapp/model/todoitem.dart';
import 'package:todoapp/util/database_client.dart';
import 'package:todoapp/ui/date_formated.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  var db = new DatabaseHelper();
  final List<ToDoItem> _itemList = <ToDoItem>[];
  @override
  void initState() {
    super.initState();

    _readNoDoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: false,
              itemCount: _itemList.length,
              itemBuilder: (_, int index) => Card(
                color: Colors.white10,
                child: ListTile(
                  title: _itemList[index],
                  onLongPress: () => _udateItem(_itemList[index], index),
                  trailing: Listener(
                    key: Key(_itemList[index].itemName),
                    child: Icon(
                      Icons.remove_circle,
                      color: Colors.redAccent,
                    ),
                    onPointerDown: (pointerEvent) =>
                        _deleteNoDo(_itemList[index].id, index),
                  ),
                ),
              ),
            ),
          ),
          new Divider(
            height: 1.0,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: "Add Item",
          backgroundColor: Colors.redAccent,
          child: ListTile(
            title: Icon(Icons.add),
          ),
          onPressed: _showFormDialog),
    );
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: InputDecoration(
                labelText: "Item",
                hintText: "eg. Don't buy stuff",
                icon: Icon(Icons.note_add)),
          ))
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              _handleSubmitted(_textEditingController.text);
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: Text("Save")),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmitted(String text) async {
    _textEditingController.clear();

    ToDoItem noDoItem = ToDoItem(text, dateFormatted());
    int savedItemId = await db.saveItem(noDoItem);

    ToDoItem addedItem = await db.getItem(savedItemId);
    print(addedItem.toString());
    setState(() {
      _itemList.insert(0, addedItem);
    });

    print("Item saved id: $savedItemId");
  }

  _readNoDoList() async {
    List items = await db.getItems();
    print(items.toString());
    items.forEach((item) {
      // NoDoItem noDoItem = NoDoItem.fromMap(item);
      setState(() {
        _itemList.add(ToDoItem.map(item));
      });
      // print("Db items: ${noDoItem.itemName}");
    });
  }

  _deleteNoDo(int id, int index) async {
    debugPrint("Deleted Item!");

    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  _udateItem(ToDoItem item, int index) {
    var alert = new AlertDialog(
      title: new Text("Update Item"),
      content: new Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: InputDecoration(
                labelText: "Item",
                hintText: "eg. Don't buy stuff",
                icon: Icon(Icons.update)),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () async {
              ToDoItem newItemUpdated = ToDoItem.fromMap({
                "itemName": _textEditingController.text,
                "dateCreated": dateFormatted(),
                "id": item.id
              });

              _handleSubmittedUpdate(index, item); //redrawing the screen
              await db.updateItem(newItemUpdated); //updating the item
              setState(() {
                _readNoDoList(); // redrawing the screen with all items saved in the db
              });

              Navigator.pop(context);
            },
            child: new Text("Update")),
        new FlatButton(
            onPressed: () => Navigator.pop(context), child: new Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmittedUpdate(int index, ToDoItem item) {
    setState(() {
      _itemList
          .removeWhere((element) => _itemList[index].itemName == item.itemName);
    });
  }
}
