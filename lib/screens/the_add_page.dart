import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class TheAddPage extends StatefulWidget {
  const TheAddPage({super.key});

  @override
  State<TheAddPage> createState() => _TheAddPageState();
}

class _TheAddPageState extends State<TheAddPage> {
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();

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
      appBar: AppBar(
        title: Text("Add stuff to the list"),
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
          ElevatedButton(onPressed: submitData, child: Text("Submit"))
        ],
      ),
    );
  }

//
// functionalities
//
//
//

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

    // print the success or fail message
    // remove this later
    print(res.statusCode);
    print(res.body);

    //  show a dialog the user if 200/400
    // success
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

    // error
    void showErrorMessage(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (res.statusCode == 201) {
      showSuccessMessage("Created Successfully");
    } else {
      showErrorMessage("Failed to Add task");
    }
  }
}
