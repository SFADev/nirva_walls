import 'package:flutter/material.dart';
import '../pages/pages_export.dart';

//design of categories
class CategorieTile extends StatelessWidget {
  const CategorieTile({
    super.key,
    required this.imgPath,
    required this.categorieColor,
    required this.title,
  });
  final String imgPath, title;
  final int categorieColor;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => PreviewPage(
              categorie: title,
              randomizeRezOrNo: true,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        width: screenWidth * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              blurRadius: 5.0,
              offset: const Offset(-3, 6),
            )
          ],
        ),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                color: Color(categorieColor),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                imgPath,
                scale: 3.6,
              ),
            ),
            Align(
              heightFactor: 7,
              alignment: Alignment.bottomCenter,
              //categorie name
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
