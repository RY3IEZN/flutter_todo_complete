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
      appBar: AppBar(
        title: Text("The List of things to do"),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: items == ""
            ? Center(child: Text("Click on the button below and add a task"))
            : RefreshIndicator(
                onRefresh: getTodoList,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = items[index] as Map;
                    return Column(
                      children: [
                        ListTile(
                          title: Text(item["title"]),
                          subtitle: Text(item["description"]),
                          leading: CircleAvatar(child: Text("${index + 1}")),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) {
                              return [PopupMenuItem(child: Text("Edit"))];
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TheAddPage(),
            ),
          );
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

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
