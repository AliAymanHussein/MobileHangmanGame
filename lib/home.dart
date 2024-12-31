import 'package:flutter/material.dart';
import 'categorySelection.dart';
import 'viewWords.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 70),
            Text("Hangman", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
            SizedBox(height: 200),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CategorySelection(),
                  ),
                );
              },
              icon: const Icon(Icons.gamepad),
              label: const Text('Play'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ViewWords(),
                  ),
                );
              },
              icon: const Icon(Icons.search),
              label: const Text('View All Words'),
            ),
          ],
        ),
      ),
    );
  }





}
