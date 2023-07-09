import 'package:flutter/material.dart';

enum Player { X, O }

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
 late List<List<Player?>> board;
 late Player userPlayer;
 late Player computerPlayer;
 late  Player currentPlayer;
 late bool gameEnded;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    board = List<List<Player?>>.generate(
      3,
          (_) => List<Player?>.filled(3, null),
    );
    userPlayer = Player.X;
    computerPlayer = Player.O;
    currentPlayer = Player.X;
    gameEnded = false;
  }

  void makeMove(int row, int col) {
    if (!gameEnded && board[row][col] == null) {
      setState(() {
        board[row][col] = currentPlayer;

        Player? winner = checkWinner();
        if (winner != null) {
          gameEnded = true;
          showDialog(
            context: context,
            builder: (_) => GameOverDialog(winner, resetGame),
          );
          return;
        } else if (isBoardFull()) {
          gameEnded = true;
          showDialog(
            context: context,
            builder: (_) => GameOverDialog(null, resetGame),
          );
          return;
        }

        currentPlayer = currentPlayer == Player.X ? Player.O : Player.X;

        if (currentPlayer == computerPlayer) {
          makeComputerMove();
        }
      });
    }
  }

  Player? checkWinner() {
    for (int i = 0; i < 3; i++) {
      if (board[i][0] != null &&
          board[i][0] == board[i][1] &&
          board[i][0] == board[i][2]) {
        return board[i][0];
      }
      if (board[0][i] != null &&
          board[0][i] == board[1][i] &&
          board[0][i] == board[2][i]) {
        return board[0][i];
      }
    }
    if (board[0][0] != null &&
        board[0][0] == board[1][1] &&
        board[0][0] == board[2][2]) {
      return board[0][0];
    }
    if (board[0][2] != null &&
        board[0][2] == board[1][1] &&
        board[0][2] == board[2][0]) {
      return board[0][2];
    }
    return null;
  }

  bool isBoardFull() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == null) {
          return false;
        }
      }
    }
    return true;
  }

  void makeComputerMove() {
    int bestScore = -1000;
    int? bestRow, bestCol;

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (board[row][col] == null) {
          board[row][col] = computerPlayer;
          int score = minimax(board, 0, false);
          board[row][col] = null;

          if (score > bestScore) {
            bestScore = score;
            bestRow = row;
            bestCol = col;
          }
        }
      }
    }

    if (bestRow != null && bestCol != null) {
      board[bestRow][bestCol] = computerPlayer;
      currentPlayer = userPlayer;

      Player? winner = checkWinner();
      if (winner != null || isBoardFull()) {
        gameEnded = true;
        showDialog(
          context: context,
          builder: (_) => GameOverDialog(winner, resetGame),
        );
      }
    }
  }

  int minimax(List<List<Player?>> board, int depth, bool maximizingPlayer) {
    Player? winner = checkWinner();
    if (winner == computerPlayer) {
      return 10 - depth;
    } else if (winner == userPlayer) {
      return depth - 10;
    } else if (isBoardFull()) {
      return 0;
    }

    if (maximizingPlayer) {
      int bestScore = -1000;
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          if (board[row][col] == null) {
            board[row][col] = computerPlayer;
            int score = minimax(board, depth + 1, false);
            board[row][col] = null;
            bestScore = score > bestScore ? score : bestScore;
          }
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          if (board[row][col] == null) {
            board[row][col] = userPlayer;
            int score = minimax(board, depth + 1, true);
            board[row][col] = null;
            bestScore = score < bestScore ? score : bestScore;
          }
        }
      }
      return bestScore;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VS Computer(hard)'),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Text(
            'User: ${userPlayer.toString()}',
            style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Computer: ${computerPlayer.toString()}',
            style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 50),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                int row = index ~/ 3;
                int col = index % 3;
                return GestureDetector(
                  onTap: () => makeMove(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        board[row][col]?.toString() ?? '',
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                );
              },
              itemCount: 9,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: new Text(
                "Reset",
                style: new TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor:Colors.red,
                  padding: const EdgeInsets.all(20.0)
              ),
              onPressed: () {
                setState(() {
                  resetGame();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GameOverDialog extends StatelessWidget {
  final Player? winner;
  final VoidCallback resetGame;

  GameOverDialog(this.winner, this.resetGame);

  String getMessage() {
    if (winner == null) {
      return "It's a draw!";
    } else {
      return "Player ${winner.toString()} wins!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Game Over'),
      content: Text(getMessage()),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            resetGame();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TicTacToeGame(),
  ));
}
