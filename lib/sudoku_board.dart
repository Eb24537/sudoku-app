import 'package:flutter/material.dart';

class SudokuBoard extends StatelessWidget {
  final List<List<int>> board;
  final List<List<bool>> fixed;
  final int? selectedRow;
  final int? selectedCol;
  final Set<String> wrongCells;
  final Function(int, int) onCellTap;

  const SudokuBoard({
    super.key,
    required this.board,
    required this.fixed,
    required this.selectedRow,
    required this.selectedCol,
    required this.wrongCells,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade600),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: List.generate(9, (row) {
          return Row(
            children: List.generate(9, (col) {
              final isSelected = selectedRow == row && selectedCol == col;
              final isFixed = fixed[row][col];
              final key = '$row-$col';
              final isWrong = wrongCells.contains(key);

              return GestureDetector(
                onTap: () => onCellTap(row, col),
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    right: (col + 1) % 3 == 0 && col != 8 ? 6 : 1,
                    bottom: (row + 1) % 3 == 0 && row != 8 ? 6 : 1,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.indigo.shade100
                        : isWrong
                            ? Colors.red.shade100
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    board[row][col] == 0 ? '' : board[row][col].toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: isFixed ? FontWeight.bold : FontWeight.normal,
                      color: isFixed
                          ? Colors.black
                          : isWrong
                              ? Colors.red
                              : Colors.indigo,
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
