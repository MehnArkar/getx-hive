import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_hive/controllers/todo_controller.dart';
import 'package:getx_hive/models/todo.dart';

class EditTodoScreen extends StatelessWidget {
  final controller = Get.put(TodoController());
  final Todo todo;
  EditTodoScreen(this.todo);

  void updateTodo() {
    print(controller.titleController.text);
    print(controller.descriptionController.text);
    if (controller.titleController.text.isEmpty ||
        controller.descriptionController.text.isEmpty) return;
    var newTodo = Todo(
      id: UniqueKey().toString(),
      title: controller.titleController.text,
      description: controller.descriptionController.text,
      cdt: DateTime.now(),
    );
    controller.titleController.text = '';
    controller.descriptionController.text = '';
    controller.updateTodo(todo, newTodo);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    controller.titleController.text = todo.title;
    controller.descriptionController.text = todo.description;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Add Todo"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 40,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Add your task",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      borderRadius: BorderRadius.circular(25),
                      controller: controller.titleController,
                      height: 50.0,
                      hintText: "Enter todo title",
                      nextFocus: controller.descriptioinFocus,
                    ),
                    CustomTextFormField(
                      padding: const EdgeInsets.fromLTRB(25, 10, 10, 10),
                      focus: controller.descriptioinFocus,
                      borderRadius: BorderRadius.circular(10),
                      controller: controller.descriptionController,
                      height: 100.0,
                      hintText: "Enter description",
                      maxLines: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              CustomButton(
                title: "Update",
                icon: Icons.done,
                onPressed: updateTodo,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.title,
    required this.icon,
    this.height = 40.0,
    this.color,
  }) : super(key: key);
  final VoidCallback onPressed;
  final String title;
  final IconData icon;
  final double height;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: color ?? Theme.of(context).primaryColor,
              ),
              child: TextButton.icon(
                onPressed: onPressed,
                icon: Icon(
                  icon,
                  color: Colors.white,
                ),
                label: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.height,
    required this.hintText,
    this.borderRadius,
    this.nextFocus,
    this.focus,
    this.maxLines,
    this.padding,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final double height;
  final BorderRadius? borderRadius;
  final FocusNode? nextFocus;
  final FocusNode? focus;
  final int? maxLines;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
      ),
      child: TextFormField(
        autofocus: true,
        focusNode: focus,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
        controller: controller,
        onEditingComplete: () {
          nextFocus?.requestFocus();
        },
      ),
    );
  }
}
