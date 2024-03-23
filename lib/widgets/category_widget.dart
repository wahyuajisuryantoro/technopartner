import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onPressed;

  const CategoryItem({
    required this.title,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: isActive ? Colors.blue : Colors.grey,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
