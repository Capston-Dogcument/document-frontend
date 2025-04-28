import 'package:flutter/material.dart';

class BasicButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const BasicButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: ShapeDecoration(
        color: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'pretendard',
            fontWeight: FontWeight.w500,
            height: 1.38,
          ),
        ),
      ),
    );
  }
}
