import 'package:flutter/material.dart';
import 'package:tictactoe/vs_ai.dart';
import 'two_player_page.dart';
import 'vs_computer_page.dart';

class GameModePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage2()),
                );
              },
              child: Text('Two-Player Mode'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage1()),
                );
              },
              child: Text('Versus Computer Mode(easy)'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TicTacToeGame()),
                );
              },
              child: Text('Versus Computer Mode(hard)'),
            )
          ],
        ),
      ),
    );
  }
}
