import 'dart:math';

class SudokuModel {
  List<List<int>> board = List.generate(9, (_) => List.filled(9, 0));
  List<List<int>> solution = List.generate(9, (_) => List.filled(9, 0));
  List<List<bool>> fixed = List.generate(9, (_) => List.filled(9, false));
  Set<String> wrongCells = {};

  int? selectedRow;
  int? selectedCol;

  void generatePuzzle({String difficulty = "Easy"}) {
    int clues;
    switch (difficulty) {
      case "Easy":
        clues = 40;
        break;
      case "Medium":
        clues = 32;
        break;
      case "Hard":
        clues = 24;
        break;
      default:
        clues = 40;
    }

    final fullBoard = _generateFullBoard();
    solution = List.generate(9, (i) => List.from(fullBoard[i]));
    final puzzle = _removeCells(List.from(fullBoard.map((row) => List.of(row))), 81 - clues);

    board = puzzle;
    fixed = List.generate(9, (i) => List.generate(9, (j) => puzzle[i][j] != 0));
    wrongCells.clear();
    selectedRow = null;
    selectedCol = null;
  }

  List<List<int>> _generateFullBoard() {
    List<List<int>> b = List.generate(9, (_) => List.filled(9, 0));
    _fillBoard(b);
    return b;
  }

  bool _fillBoard(List<List<int>> b, [int row = 0, int col = 0]) {
    if (row == 9) return true;
    if (col == 9) return _fillBoard(b, row + 1, 0);

    List<int> nums = List.generate(9, (i) => i + 1)..shuffle();
    for (int num in nums) {
      if (_isSafe(b, row, col, num)) {
        b[row][col] = num;
        if (_fillBoard(b, row, col + 1)) return true;
        b[row][col] = 0;
      }
    }
    return false;
  }

  bool _isSafe(List<List<int>> b, int row, int col, int num) {
    for (int i = 0; i < 9; i++) {
      if (b[row][i] == num || b[i][col] == num) return false;
      if (b[row - row % 3 + i ~/ 3][col - col % 3 + i % 3] == num) return false;
    }
    return true;
  }

  List<List<int>> _removeCells(List<List<int>> b, int count) {
    final rand = Random();
    while (count > 0) {
      int i = rand.nextInt(9);
      int j = rand.nextInt(9);
      if (b[i][j] != 0) {
        b[i][j] = 0;
        count--;
      }
    }
    return b;
  }

  void selectCell(int row, int col) {
    if (!fixed[row][col]) {
      selectedRow = row;
      selectedCol = col;
    }
  }

  void setNumber(int number) {
    if (selectedRow != null && selectedCol != null && !fixed[selectedRow!][selectedCol!]) {
      board[selectedRow!][selectedCol!] = number;
      String key = '${selectedRow!}-${selectedCol!}';

      if (number != solution[selectedRow!][selectedCol!]) {
        wrongCells.add(key);
      } else {
        wrongCells.remove(key);
      }
    }
  }

  bool isComplete() {
    for (var row in board) {
      if (row.contains(0)) return false;
    }
    return true;
  }

  bool isValidSudoku() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] != solution[i][j]) return false;
      }
    }
    return true;
  }
}
