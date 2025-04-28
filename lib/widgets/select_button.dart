import 'package:flutter/material.dart';

class SelectableButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const SelectableButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: ShapeDecoration(
            color: isSelected
                ? Colors.blue.withOpacity(0.2)
                : Colors.black.withOpacity(0.1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'pretendard',
                fontWeight: FontWeight.w400,
                height: 1.43,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
