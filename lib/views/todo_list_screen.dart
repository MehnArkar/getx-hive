import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_hive/controllers/todo_controller.dart';
import 'package:getx_hive/models/todo.dart';
import 'package:getx_hive/views/add_todo_screen.dart';
import 'package:getx_hive/views/edit_todo_screen.dart';
import 'package:getx_hive/views/view_todo_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyTodosScreen extends StatefulWidget {
  @override
  State<MyTodosScreen> createState() => _MyTodosScreenState();
}

class _MyTodosScreenState extends State<MyTodosScreen> {
  final controller = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.off(() => TodosScreen());
        },
        label: Row(
          children: [
            Icon(Icons.add),
            SizedBox(width: 10),
            Text("Add todo"),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 45),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back_ios_new),
                ),
                Text(
                  "My Todos",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                // Icon(Icons),
                SizedBox()
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Remaining",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: _buildInCompleted(),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Completed",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: _buildCompleted(),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleted() {
    return Obx(
      () => Container(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: controller.done.length,
          itemBuilder: (context, index) {
            var reversedDone = controller.done.reversed.toList();
            Todo todo = reversedDone[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => ViewTodoScreen(todo: todo));
              },
              onLongPress: () {
                controller.toggleTodo(todo);
              },
              child: TodoCard(
                todo: todo,
                isDone: todo.isDone,
                title: todo.title,
                date: todo.cdt,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInCompleted() {
    return Obx(
      () => Container(
        child: ListView.builder(
          itemCount: controller.remaining.length,
          itemBuilder: (context, index) {
            var reverseRemaining = controller.remaining.reversed.toList();
            Todo todo = reverseRemaining[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => EditTodoScreen(todo));
              },
              onLongPress: () {
                controller.toggleTodo(todo);
              },
              child: TodoCard(
                todo: todo,
                isDone: todo.isDone,
                title: todo.title,
                date: todo.cdt,
              ),
            );
          },
        ),
      ),
    );
  }
}

class TodoCard extends StatelessWidget {
  final TodoController controller = Get.put(TodoController());
  TodoCard(
      {Key? key,
      required this.title,
      required this.date,
      required this.isDone,
      required this.todo})
      : super(key: key);
  final String title;
  final DateTime date;
  final bool isDone;
  final Todo todo;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      height: 100,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 20,
            spreadRadius: 1,
          )
        ],
        color: isDone ? Colors.green[50] : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.task_alt,
                  color: isDone ? Colors.green : Colors.grey,
                ),
                SizedBox(width: 5),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          !isDone
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        controller.deleteTodo(todo);
                      },
                    ),
                    Text(timeago.format(date)),
                  ],
                )
              : Text(timeago.format(date)),
        ],
      ),
    );
  }
}
