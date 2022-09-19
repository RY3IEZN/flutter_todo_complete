import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class TheAddPage extends StatefulWidget {
  const TheAddPage({super.key, this.todo});
  final Map? todo;

  @override
  State<TheAddPage> createState() => _TheAddPageState();
}

class _TheAddPageState extends State<TheAddPage> {
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final selectedToDoItem = widget.todo;
    if (selectedToDoItem != null) {
      isEdit = true;
      final title = selectedToDoItem["title"];
      final description = selectedToDoItem["description"];

      titleTextController.text = title;
      descriptionTextController.text = description;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleTextController.dispose();
    descriptionTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 238, 248, 1),
      appBar: AppBar(
        title: isEdit
            ? Text("Edit the task at hand")
            : Text("Add stuff to the list"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: titleTextController,
            decoration: InputDecoration(hintText: "Title"),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: descriptionTextController,
            decoration: InputDecoration(hintText: "Description"),
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: isEdit ? Text("Update") : Text("Submit"),
              ))
        ],
      ),
    );
  }

//
// functionalities
//
//
//

  Future<void> updateData() async {
    final selectedToDoItem = widget.todo;
    if (selectedToDoItem == null) {
      print("you cant update without an existing task");
      return;
    }
    final id = selectedToDoItem["_id"];
    final title = titleTextController.text;
    final description = descriptionTextController.text;
    final body = {
      "title": title,
      "description": description,
      "isCompleted": false
    };

    final url = "https://api.nstack.in/v1/todos/$id";

    final res = await http.put(Uri.parse(url),
        body: jsonEncode(body), headers: {"Content-Type": "application/json"});
    if (res.statusCode == 200) {
      showSuccessMessage("updated succesfully");

      Navigator.pop(context);
    } else {
      showErrorMessage("update failed");
    }
  }

  Future<void> submitData() async {
    // get the inout data
    final title = titleTextController.text;
    final description = descriptionTextController.text;
    final body = {
      "title": title,
      "description": description,
      "isCompleted": false
    };

    // submit to the server
    final url = "https://api.nstack.in/v1/todos";

    final res = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: {"Content-Type": "application/json"});

    //  show a dialog the user if 200/400

    if (res.statusCode == 201) {
      showSuccessMessage("Created Successfully");
      titleTextController.text = "";
      descriptionTextController.text = "";
      Navigator.pop(context);
    } else {
      showErrorMessage("Failed to Add task");
    }
  }

  // error snackbar
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // success snackbar
  void showSuccessMessage(String message) {
    titleTextController.text = "";
    descriptionTextController.text = "";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
