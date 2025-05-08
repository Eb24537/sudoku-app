import 'package:flutter/material.dart';

class NumberPad extends StatelessWidget {
  final void Function(int) onNumberSelected;

  const NumberPad({super.key, required this.onNumberSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(9, (i) {
        final number = i + 1;
        return ElevatedButton(
          onPressed: () => onNumberSelected(number),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.white,
            foregroundColor: Colors.indigo,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.indigo),
            ),
          ),
          child: Text(
            number.toString(),
            style: const TextStyle(fontSize: 20),
          ),
        );
      }),
    );
  }
}
