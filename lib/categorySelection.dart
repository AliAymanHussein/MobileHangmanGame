import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'hangman.dart';
const String _baseURL = 'csci410alihussein.atwebpages.com';

class CategorySelection extends StatefulWidget {
  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  List categories = [];

  bool _load = false;

  void update(bool success) {
    setState(() {
      _load = true;
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('failed to load data')));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCategories(update);
  }

  void fetchCategories(Function(bool success) update) async {
    final url = Uri.http(_baseURL, 'getCategories.php');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        categories = json.decode(response.body);
        update(true);
      } else {
        update(false);
      }
    } catch (e) {
      update(false);
    }
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text("Select Category")),
      body: !_load
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Column(
            children: [
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  backgroundColor:
                  index % 2 == 0 ? Colors.amber : Colors.cyan,
                  elevation: 0,
                  alignment: Alignment.center,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HangmanGame(
                        categoryId: int.parse(category['id']),
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  width: width * 0.9,
                  child: Text(
                    category['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.045,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }


}
