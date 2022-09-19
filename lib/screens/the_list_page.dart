import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

import 'package:flutter_todo_backend_test/screens/the_add_page.dart';

class TheListPage extends StatefulWidget {
  const TheListPage({super.key});

  @override
  State<TheListPage> createState() => _TheListPageState();
}

class _TheListPageState extends State<TheListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTodoList();
  }

  bool isLoading = true;
  List items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 238, 248, 1),
      appBar: AppBar(
        title: Text("The List of things to do"),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: getTodoList,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                "No task, click on Add todo",
                style: TextStyle(fontSize: 20),
              ),
            ),
            child: ListView.builder(
              padding: EdgeInsets.all(15),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index] as Map;
                final id = item["_id"] as String;
                return Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: Text(item["title"]),
                        subtitle: Text(item["description"]),
                        leading: CircleAvatar(child: Text("${index + 1}")),
                        trailing: PopupMenuButton(
                          onSelected: (value) {
                            if (value == "edit") {
                              navigateToEditPage(item);
                            } else if (value == "delete") {
                              //
                              deleteById(id);
                            }
                          },
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                child: Text("Edit"),
                                value: "edit",
                              ),
                              PopupMenuItem(
                                child: Text("Delete"),
                                value: "delete",
                              ),
                            ];
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToAddPage();
        },
        label: Text("Add to-do"),
      ),
    );
  }

//
// functionalities
//
//

  Future<void> getTodoList() async {
    // ignore: prefer_const_declarations
    final url = "https://api.nstack.in/v1/todos?page=page=1&limit=10";

    final res = await http.get(Uri.parse(url));
    print(res);
    print(res.statusCode);
    print(res.body);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map;
      final result = data["items"] as List;
      setState(() {
        items = result;
      });
    } else {
      showErrorMessage("Failed to get the data");
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigateToEditPage(Map item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TheAddPage(todo: item),
      ),
    );
    setState(() {
      isLoading = true;
    });
    getTodoList();
  }

  void navigateToAddPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TheAddPage(),
      ),
    );
    setState(() {
      isLoading = true;
    });
    getTodoList();
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> deleteById(id) async {
    final url = "http://api.nstack.in/v1/todos/$id";
    final res = await http.delete(Uri.parse(url));

    if (res.statusCode == 200) {
      showSuccessMessage("Succesfully deleted");
      final filtered = items.where((element) => element["_id"] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showErrorMessage("Unable to delete");
    }
  }
}
