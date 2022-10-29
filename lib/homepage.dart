// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mine_sweeper/bomb.dart';
import 'package:mine_sweeper/numberbox.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // variables
  int numberOfSquares = 9 * 9;
  int numberInEachRow = 9;

  // [ number of bombs ground, revealed = true / false ]
  var squareStatus = [];

  List<int> bombLocation = [];
  bool bombsRevealed = false;

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < numberOfSquares; i++) {
      squareStatus.add([0, false]);
    }

    bombLocation = getBombLocation();

    scanBombs();
  }

  List<int> getBombLocation() {
    List<int> currentBombLocation = [];
    Random random = Random();
    for (var i = 0; i < 10; i++) {
      do {
        int randomLocation = random.nextInt(numberOfSquares);
        if (!currentBombLocation.contains(randomLocation)) {
          currentBombLocation.add(randomLocation);
        }
      } while (currentBombLocation.length == i);
    }
    return currentBombLocation;
  }

  void restartGame() {
    setState(() {
      bombsRevealed = false;
      for (var i = 0; i < numberOfSquares; i++) {
        squareStatus[i][1] = false;
      }
      bombLocation = getBombLocation();
    });
  }

  void revealBoxNumbers(int index) {
    // reveal current box if it is a number; 1,2,3 etc
    if (squareStatus[index][0] != 0) {
      setState(() {
        squareStatus[index][1] = true;
      });
    }

    // if current box is 0
    else if (squareStatus[index][0] == 0) {
      // reveal current box, and the 8 surrounding boxes, unless you're on a wall
      setState(() {
        // reveal current box
        squareStatus[index][1] = true;

        // reveal left box (unless we are currently on the left wall)
        if (index % numberInEachRow != 0) {
          // if next box isn't revealed yet and it is a 0, the recurse
          if (squareStatus[index - 1][0] == 0 &&
              squareStatus[index - 1][1] == false) {
            revealBoxNumbers(index - 1);
          }
          // reveal current box
          squareStatus[index - 1][1] = true;
        }

        // reveal top left box (unless we are currently on the left wall)
        if (index % numberInEachRow != 0 && index >= numberInEachRow) {
          // if next box isn't revealed yet and it is a 0, the recurse
          if (squareStatus[index - 1 - numberInEachRow][0] == 0 &&
              squareStatus[index - 1 - numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1 - numberInEachRow);
          }
          // reveal current box
          squareStatus[index - 1 - numberInEachRow][1] = true;
        }

        // reveal top box (unless we are currently on the left wall)
        if (index >= numberInEachRow) {
          // if next box isn't revealed yet and it is a 0, the recurse
          if (squareStatus[index - numberInEachRow][0] == 0 &&
              squareStatus[index - numberInEachRow][1] == false) {
            revealBoxNumbers(index - numberInEachRow);
          }
          // reveal current box
          squareStatus[index - numberInEachRow][1] = true;
        }

        // reveal top right box (unless we are currently on the left wall)
        if (index >= numberInEachRow &&
            index % numberInEachRow != numberInEachRow - 1) {
          // if next box isn't revealed yet and it is a 0, the recurse
          if (squareStatus[index + 1 - numberInEachRow][0] == 0 &&
              squareStatus[index + 1 - numberInEachRow][1] == false) {
            revealBoxNumbers(index + 1 - numberInEachRow);
          }
          // reveal current box
          squareStatus[index + 1 - numberInEachRow][1] = true;
        }

        // reveal right box (unless we are currently on the left wall)
        if (index % numberInEachRow != numberInEachRow - 1) {
          // if next box isn't revealed yet and it is a 0, the recurse
          if (squareStatus[index + 1][0] == 0 &&
              squareStatus[index + 1][1] == false) {
            revealBoxNumbers(index + 1);
          }
          // reveal current box
          squareStatus[index + 1][1] = true;
        }

        // reveal bottom right box (unless we are currently on the left wall)
        if (index < numberOfSquares - numberInEachRow &&
            index % numberInEachRow != numberInEachRow - 1) {
          // if next box isn't revealed yet and it is a 0, the recurse
          if (squareStatus[index + 1 + numberInEachRow][0] == 0 &&
              squareStatus[index + 1 + numberInEachRow][1] == false) {
            revealBoxNumbers(index + 1 + numberInEachRow);
          }
          // reveal current box
          squareStatus[index + 1 + numberInEachRow][1] = true;
        }

        // reveal bottom box (unless we are currently on the left wall)
        if (index < numberOfSquares - numberInEachRow) {
          // if next box isn't revealed yet and it is a 0, the recurse
          if (squareStatus[index + numberInEachRow][0] == 0 &&
              squareStatus[index + numberInEachRow][1] == false) {
            revealBoxNumbers(index + numberInEachRow);
          }
          // reveal current box
          squareStatus[index + numberInEachRow][1] = true;
        }

        // reveal bottom left box (unless we are currently on the left wall)
        if (index < numberOfSquares - numberInEachRow &&
            index % numberInEachRow != 0) {
          // if next box isn't revealed yet and it is a 0, the recurse
          if (squareStatus[index - 1 + numberInEachRow][0] == 0 &&
              squareStatus[index - 1 + numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1 + numberInEachRow);
          }
          // reveal current box
          squareStatus[index - 1 + numberInEachRow][1] = true;
        }
      });
    }
  }

  void scanBombs() {
    for (var i = 0; i < numberOfSquares; i++) {
      // there are no bombs around initially
      int numberOfBombsAround = 0;

      /*

      check each square to see if it has bombs surrounding it,
      there are 8 surrounding boxes to check

      */

      // check square to the left, unless it is in the first column
      if (bombLocation.contains(i - 1) && i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }

      // check square to the top left, unless it is in the first column
      if (bombLocation.contains(i - 1 - numberInEachRow) &&
          i % numberInEachRow != 0 &&
          i >= numberInEachRow) {
        numberOfBombsAround++;
      }

      // check square to the top, unless it is in the first column
      if (bombLocation.contains(i - numberInEachRow) && i >= numberInEachRow) {
        numberOfBombsAround++;
      }

      // check square to the top right, unless it is in the first column
      if (bombLocation.contains(i + 1 - numberInEachRow) &&
          i % numberInEachRow != numberInEachRow - 1 &&
          i >= numberInEachRow) {
        numberOfBombsAround++;
      }

      // check square to the right, unless it is in the last column
      if (bombLocation.contains(i + 1) &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }

      // check square to the bottom right, unless it is in the last row or last row
      if (bombLocation.contains(i + 1 + numberInEachRow) &&
          i % numberInEachRow != numberInEachRow - 1 &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      }

      // check square to the bottom, unless it is in the last row
      if (bombLocation.contains(i + numberInEachRow) &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      }

      // check square to the bottom left, unless it is in the last row or first column
      if (bombLocation.contains(i - 1 + numberInEachRow) &&
          i % numberInEachRow != 0 &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      }

      // add total number of bombs around to square status
      setState(() {
        squareStatus[i][0] = numberOfBombsAround;
      });
    }
  }

  void playerLost() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.grey[800],
              title: Center(
                  child: Text(
                'You Lost',
                style: TextStyle(color: Colors.white),
              )),
              actions: [
                MaterialButton(
                  color: Colors.grey[100],
                  onPressed: () {
                    restartGame();
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.refresh),
                ),
              ]);
        });
  }

  void playerWon() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.grey[800],
              title: Center(
                  child: Text(
                'You Win',
                style: TextStyle(color: Colors.white),
              )),
              actions: [
                MaterialButton(
                  color: Colors.grey[100],
                  onPressed: () {
                    restartGame();
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.refresh),
                ),
              ]);
        });
  }

  void checkWinner() {
    // check how many boxes yet to reveal
    int unrevealedBoxes = 0;
    for (var i = 0; i < numberOfSquares; i++) {
      if (squareStatus[i][1] == false) {
        unrevealedBoxes++;
      }
    }

    // if this number is the same as number of bombs, then player Wins
    if (unrevealedBoxes == bombLocation.length) {
      playerWon();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(children: [
        // game stats and menu
        Container(
          height: 150,
          // color: Colors.grey,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            // display number of bombs
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(bombLocation.length.toString(),
                    style: TextStyle(fontSize: 40)),
                Text('B O M B'),
              ],
            ),

            // button to refresh the game
            GestureDetector(
              onTap: restartGame,
              child: Card(
                color: Colors.grey[700],
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),

            // display time taken
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('0', style: TextStyle(fontSize: 40)),
                Text('T I M E'),
              ],
            )
          ]),
        ),

        // grid
        Expanded(
          child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: numberOfSquares,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: numberInEachRow),
              itemBuilder: (context, index) {
                if (bombLocation.contains(index)) {
                  return MyBomb(
                    revealed: bombsRevealed,
                    function: () {
                      setState(() {
                        bombsRevealed = true;
                      });
                      playerLost();
                      // player tapped the bomb, so player loses
                    },
                  );
                } else {
                  return MyNumberBox(
                    child: squareStatus[index][0],
                    revealed: squareStatus[index][1],
                    function: () {
                      // reveal current box
                      revealBoxNumbers(index);
                      checkWinner();
                    },
                  );
                }
              }),
        ),

        // branding
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Text('C R E A T E D B Y J O H N S O N'),
        ),
      ]),
    );
  }
}
