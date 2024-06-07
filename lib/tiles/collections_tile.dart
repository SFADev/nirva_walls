import 'package:flutter/material.dart';
import '../pages/pages_export.dart';

class CollectionsTile extends StatelessWidget {
  final String? collectionTitle;

  const CollectionsTile({
    super.key,
    required this.collectionTitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => PreviewPage(
              categorie: collectionTitle as String,
              randomizeRezOrNo: false,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
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
        //content
        child: Center(
          child: ListTile(
            leading: const SizedBox(
              height: 25,
              width: 25,
              child: Icon(
                Icons.image_rounded,
                color: Colors.deepPurpleAccent,
              ),
            ),
            title: Text(
              '$collectionTitle',
            ),
          ),
        ),
      ),
    );
  }
}
