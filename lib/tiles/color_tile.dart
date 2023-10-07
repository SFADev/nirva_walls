import 'package:flutter/material.dart';
import '../pages/pages_export.dart';

//design of Colrs
class ColorTile extends StatelessWidget {
  const ColorTile({
    super.key,
    required this.colorName,
    required this.colorType,
  });
  final String colorName;
  final Color colorType;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => PreviewPage(
              categorie: colorName,
              randomizeRezOrNo: true,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8.0, left: 8.0),
        width: screenWidth * 0.11,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: colorType,
        ),
      ),
    );
  }
}
