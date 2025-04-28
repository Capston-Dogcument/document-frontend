import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final String hintText;

  const InputField({super.key, required this.label, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'pretendard',
            fontWeight: FontWeight.w500,
            height: 1.43,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Colors.black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
