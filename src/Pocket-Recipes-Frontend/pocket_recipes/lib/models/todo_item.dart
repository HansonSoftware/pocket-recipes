import 'package:flutter/material.dart';
import 'package:pocket_recipes/models/todo.dart';

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final onTodoChanged;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return TextStyle(fontSize: 22);

    return TextStyle(
      fontSize: 20,
      color: Colors.orange,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ObjectKey(todo),
        child: ListTile(
          onTap: () {
            onTodoChanged(todo);
          },
          leading: Icon(
            Icons.circle,
            color: Colors.black,
            size: 14,
          ),
          title: Text(
            todo.name,
            style: _getTextStyle(todo.checked),
          ),
        ));
  }
}
