import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String _baseURL = 'csci410alihussein.atwebpages.com';

class ViewWords extends StatefulWidget {
  @override
  _ViewWordsState createState() => _ViewWordsState();
}

class _ViewWordsState extends State<ViewWords> {
  List words = [];

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
    fetchWords(update);
  }

  void fetchWords(Function(bool success) update) async {
    final url = Uri.http(_baseURL, 'getWords.php');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        words = json.decode(response.body);
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
    return Scaffold(
      appBar: AppBar(title: Text("All Available Words")),
      body: !_load ? Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          return Column(
            children: [
              Text(
                word['word'],
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20.0),
            ],
          );
        },
      ),
    );
  }


}
