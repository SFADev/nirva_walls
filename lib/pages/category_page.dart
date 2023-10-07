import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/models_export.dart';
import '../tiles/tiles_export.dart';
import '../data/data_export.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({
    super.key,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<CategorieModel> categories = [];
  List<CollectionsModel> collection = [];
  int numCollectionPage = 1;
  randomizeNumber() {
    final rand = Random.secure();
    numCollectionPage = rand.nextInt(20) + 1;
  }

  getCollections() async {
    try {
      await http.get(
          Uri.parse(
              "https://api.pexels.com/v1/collections/featured?per_page=10&page=$numCollectionPage"),
          headers: {"Authorization": apiKey}).then(
        (value) {
          Map<String, dynamic> jsonData = jsonDecode(value.body);
          jsonData["collections"].forEach((element) {
            CollectionsModel collectionsModel = CollectionsModel();
            collectionsModel = CollectionsModel.fromMap(element);
            // filter for specify your app images
            if (!collectionsModel.title!.toLowerCase().contains('person') &&
                !collectionsModel.title!.toLowerCase().contains('gay') &&
                !collectionsModel.title!.toLowerCase().contains('guy') &&
                !collectionsModel.title!.toLowerCase().contains('lgbt') &&
                !collectionsModel.title!.toLowerCase().contains('nude') &&
                !collectionsModel.title!.toLowerCase().contains('bikini') &&
                !collectionsModel.title!.toLowerCase().contains('man') &&
                !collectionsModel.title!.toLowerCase().contains('men') &&
                !collectionsModel.title!.toLowerCase().contains('male') &&
                !collectionsModel.title!.toLowerCase().contains('boy') &&
                !collectionsModel.title!.toLowerCase().contains('woman') &&
                !collectionsModel.title!.toLowerCase().contains('women') &&
                !collectionsModel.title!.toLowerCase().contains('girl') &&
                !collectionsModel.title!.toLowerCase().contains('female') &&
                !collectionsModel.title!.toLowerCase().contains('lady') &&
                !collectionsModel.title!.toLowerCase().contains('couple') &&
                !collectionsModel.title!.toLowerCase().contains('people') &&
                !collectionsModel.title!.toLowerCase().contains('friends') &&
                !collectionsModel.title!.toLowerCase().contains('church') &&
                !collectionsModel.title!.toLowerCase().contains('adult') &&
                !collectionsModel.title!.toLowerCase().contains('teenagers') &&
                !collectionsModel.title!.toLowerCase().contains('vintage') &&
                !collectionsModel.title!.toLowerCase().contains('anonymous') &&
                !collectionsModel.title!.toLowerCase().contains('stock') &&
                !collectionsModel.title!.toLowerCase().contains('tourist') &&
                !collectionsModel.title!.toLowerCase().contains('cross') &&
                !collectionsModel.title!.toLowerCase().contains('buddha') &&
                !collectionsModel.title!.toLowerCase().contains('bars') &&
                !collectionsModel.title!.toLowerCase().contains('dance') &&
                !collectionsModel.title!.toLowerCase().contains('wine') &&
                !collectionsModel.title!.toLowerCase().contains('video') &&
                collectionsModel.title != null &&
                collectionsModel.title != ' ' &&
                collectionsModel.title != '' &&
                collectionsModel.title!.length <= 20 &&
                collectionsModel.private == false) {
              collection.add(collectionsModel);
            }
          });
          if (!mounted) return;
          setState(() {});
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    randomizeNumber();
    getCollections();
    categories = getcategories();
    super.initState();
  }

  List<String> popularShearchTags = [
    'Sports',
    'Sky',
    'Forest',
    'Food',
    'Sunset',
    'Space',
    'Landscape',
    'Winter',
    'Dark',
    'Nature',
    'Abstract',
    'Technology',
    'Football',
    'Cat',
    'Car',
    'Dog',
    'Business',
  ];

  Map<String, Color> myColors = {
    'Yellow': const Color(0xfffbef52),
    'Green': const Color(0xffb7e786),
    'Blue': const Color(0xff63b5f8),
    'Orange': const Color(0xfff2bb74),
    'Pink': const Color(0xffee72eb),
    'Red': const Color(0xfff0905b),
    'Black': const Color(0xff585858),
  };

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        //appbar
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'CATEGORY',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          elevation: 0,
        ),
        body: ListView(
          children: [
            //Tags
            SizedBox(
              height: screenHight * 0.06,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, top: 1.0),
                scrollDirection: Axis.horizontal,
                itemCount: popularShearchTags.length,
                itemBuilder: ((context, index) => TagsTile(
                      tagTitle: popularShearchTags[index],
                    )),
              ),
            ),
            //Colors
            SizedBox(
              height: screenHight * 0.06,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: ((context, index) => ColorTile(
                      colorName: myColors.entries.elementAt(index).key,
                      colorType: myColors.entries.elementAt(index).value,
                    )),
              ),
            ),
            //Categories
            SizedBox(
              height: screenHight * 0.35,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8.0, bottom: 15.0, left: 8.0),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategorieTile(
                    imgPath: categories[index].imgPath,
                    categorieColor: categories[index].categorieColor,
                    title: categories[index].categorieName,
                  );
                },
              ),
            ),
            //collections text
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 8.0),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Collections',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            //collections
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: screenWidth * 0.5,
                childAspectRatio: 5 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: collection.length,
              itemBuilder: (context, index) {
                return CollectionsTile(
                  collectionTitle: collection[index].title,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
