import 'package:flutter/material.dart';
import '../pages/pages_export.dart';

//design of Tags
class TagsTile extends StatelessWidget {
  const TagsTile({
    super.key,
    required this.tagTitle,
  });
  final String tagTitle;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => PreviewPage(
              categorie: tagTitle,
              randomizeRezOrNo: true,
            ),
          ),
        );
      },
      child: Container(
        width: screenWidth * 0.2,
        margin: const EdgeInsets.only(right: 8.0, left: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).colorScheme.background,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              blurRadius: 5.0,
              offset: const Offset(-2, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            tagTitle,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ),
    );
  }
}
