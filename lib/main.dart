import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

import 'sudoku_board.dart';
import 'sudoku_model.dart';
import 'number_pad.dart';

void main() => runApp(const SudokuApp());

class SudokuApp extends StatelessWidget {
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sudoku Classic',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: GoogleFonts.latoTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF2F2F2),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E3B4E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const SudokuHomePage(),
    );
  }
}

class SudokuHomePage extends StatefulWidget {
  const SudokuHomePage({super.key});

  @override
  State<SudokuHomePage> createState() => _SudokuHomePageState();
}

class _SudokuHomePageState extends State<SudokuHomePage> {
  final SudokuModel sudokuModel = SudokuModel();
  late ConfettiController _confettiController;

  String _difficulty = "Easy";

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    sudokuModel.generatePuzzle(difficulty: _difficulty);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _onCellTap(int row, int col) {
    setState(() {
      sudokuModel.selectCell(row, col);
    });
  }

  void _onNumberInput(int number) {
    setState(() {
      sudokuModel.setNumber(number);
    });

    if (sudokuModel.isComplete() && sudokuModel.isValidSudoku()) {
      _confettiController.play();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("🎉 You Win!"),
          content: const Text("Congratulations! You completed the Sudoku."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  sudokuModel.generatePuzzle(difficulty: _difficulty);
                });
              },
              child: const Text("Play Again"),
            ),
          ],
        ),
      );
    }
  }

  void _onReset() {
    setState(() {
      sudokuModel.generatePuzzle(difficulty: _difficulty);
    });
  }

  void _onDifficultyChange(String? value) {
    if (value != null) {
      setState(() {
        _difficulty = value;
        sudokuModel.generatePuzzle(difficulty: _difficulty);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sudoku')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SudokuBoard(
                      board: sudokuModel.board,
                      fixed: sudokuModel.fixed,
                      selectedRow: sudokuModel.selectedRow,
                      selectedCol: sudokuModel.selectedCol,
                      wrongCells: sudokuModel.wrongCells,
                      onCellTap: _onCellTap,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: NumberPad(onNumberSelected: _onNumberInput),
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: ["Easy", "Medium", "Hard"].map((level) {
                        final isSelected = _difficulty == level;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(
                              level,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: Colors.indigo,
                            backgroundColor: Colors.grey[300],
                            elevation: 2,
                            pressElevation: 4,
                            onSelected: (_) => _onDifficultyChange(level),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _onReset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('New Puzzle'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
