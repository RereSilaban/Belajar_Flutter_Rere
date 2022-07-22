import 'package:flutter/material.dart';
void main() => runApp(new TodoApp());

class Todo {
  Todo({required this.name, required this.checked});
  late final String name;
  bool checked;
}

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final onTodoChanged;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return TextStyle(
      color: Color.fromARGB(137, 183, 49, 49),
      decoration: TextDecoration.lineThrough, //coret list
    );
  }


  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTodoChanged(todo);
      },
      //logo avatar huruf
      leading: CircleAvatar( backgroundColor: Colors.green[100],
        child: Text(todo.name[0]),
      ),
      title: Text(todo.name, style: _getTextStyle(todo.checked)),
      trailing: IconButton(
        onPressed: () {
       _TodoListState()._deleteItem();
        }, 
        icon: Icon(Icons.delete))
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => new _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<Todo> _todos = <Todo>[];
  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: Image.asset('assets/alarm.png'),
        backgroundColor: Colors.lightGreen,
        title: new Text('My Todo List')
      ),
      body: 
      ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: _todos.map((Todo todo) {
          return TodoItem( //loopinggetindex
            todo: todo,
            onTodoChanged: _handleTodoChange,
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor:  Colors.lightGreen,
          onPressed: () => _displayDialog(),
          tooltip: 'Add Item',
          child:  Icon(
            Icons.add,
            color: Colors.white,))
    );
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }


  void _addTodoItem(String name) {
    setState(() {
      _todos.add(Todo(name: name, checked: false));
    });
    _textFieldController.clear(); //untuk membersihkan field sehingga saat kembali ke awal data sebelumnya terhapus
  }

  void _deleteItem(){
       _todos.removeWhere((element) => element.name == element);
       //tambah parameter indeks
       //loopingindexs
      // _todos.removeWhere((Todo todo) => todo.name == true
  
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new todo item'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'input your todo item'),
          ),
          actions: <Widget>[TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
              },
            ),  IconButton(
            onPressed: () => Navigator.pop(context, true),
            icon: Icon (Icons.cancel),)
          ],
        );
      },
    );
  }
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'My Todo list',
      home: new TodoList(),
    );
  }
}

