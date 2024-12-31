import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
const String _baseURL = 'csci410alihussein.atwebpages.com';

class HangmanGame extends StatefulWidget {
  final int categoryId;

  HangmanGame({required this.categoryId});

  @override
  _HangmanGameState createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {

  String? wordToGuess;

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
    fetchRandomWord(update);
  }

  void fetchRandomWord(Function(bool success) update) async {
    //final url = Uri.parse("http://csci410alihussein.atwebpages.com/getRandomWord.php?category_id=${widget.categoryId}");
    final url = Uri.http(_baseURL, 'getRandomWord.php',{'category_id' : widget.categoryId.toString()});
    try{
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          wordToGuess = data['word'] ?? "No word found";
        });
        update(true);
      } else {
        update(false);
      }
    } catch (e) {
      update(false);
    }
  }

  final Set<String> correctGuesses = {};
  final Set<String> incorrectGuesses = {};
  final int maxAttempts = 6;

  void makeGuess(String letter) {
    if (wordToGuess == null) return;

    String lowerCaseWord = wordToGuess!.toLowerCase();

    setState(() {
      if (lowerCaseWord.contains(letter)) {
        correctGuesses.add(letter);
      } else {
        incorrectGuesses.add(letter);
      }
    });
  }

  String getDisplayedWord() {
    if (wordToGuess == null) return '';

    String displayedWord = '';
    for (var letter in wordToGuess!.split('')) {
      if (correctGuesses.contains(letter.toLowerCase())) {
        displayedWord += '$letter ';
      } else {
        displayedWord += '_ ';
      }
    }

    return displayedWord.trim();
  }


  bool isGameOver() {
    return incorrectGuesses.length >= maxAttempts || isGameWon();
  }

  bool isGameWon() {
    if (wordToGuess == null) return false;

    String lowerCaseWord = wordToGuess!.toLowerCase();

    for (var letter in lowerCaseWord.split('')) {
      if (!correctGuesses.contains(letter)) {
        return false;
      }
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> rows = buildLetterRows();

    return Scaffold(
      appBar: AppBar(title: Text('Guess The Word'), centerTitle: true,),
      body: !_load ? Center(child: CircularProgressIndicator()) : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getDisplayedWord(),
              style: TextStyle(fontSize: 32, letterSpacing: 4),
            ),
            SizedBox(height: 20),

            Text(
              "Attempts Left: ${maxAttempts - incorrectGuesses.length}",
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            SizedBox(height: 20),

            for (Widget row in rows) row,

            if (isGameOver())
              Text(
                isGameWon() ? "You Win!" : "You Lose! The word was '$wordToGuess'.",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildLetterRows() {
    List<String> letters = 'abcdefghijklmnopqrstuvwxyz'.split('');
    List<Widget> rows = [];

    for (int i = 0; i < letters.length; i += 5) {
      List<Widget> rowChildren = [];
      for (int j = i; j < i + 5 && j < letters.length; j++) {
        rowChildren.add(
          Container(
            margin: EdgeInsets.all(4.0),
            child: ElevatedButton(
              onPressed: isGameOver() ? null : (correctGuesses.contains(letters[j]) || incorrectGuesses.contains(letters[j])) ? null : () => makeGuess(letters[j]),
              child: Text(letters[j].toUpperCase()),
            ),
          ),
        );
      }

      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rowChildren,
        ),
      );
    }

    return rows;
  }
}
