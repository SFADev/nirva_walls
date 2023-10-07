import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../data/data_export.dart';
import '../models/models_export.dart';
import '../widget/widget_export.dart';

class PreviewPage extends StatefulWidget {
  final String categorie;
  final bool randomizeRezOrNo;

  const PreviewPage({
    super.key,
    required this.categorie,
    required this.randomizeRezOrNo,
  });

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  //every time open app get a random page
  int numOfPage = 1;
  randomizeNumber(bool yesOrNo) {
    final rnd = Random.secure();
    if (yesOrNo) {
      numOfPage = rnd.nextInt(200) + 1;
    }
    return numOfPage;
  }

  List<PhotosModel> photos = [];

  getCategorieWallpaper() async {
    try {
      await http.get(
          Uri.parse(
              "https://api.pexels.com/v1/search?query=${widget.categorie}&per_page=20&page=$numOfPage"),
          headers: {"Authorization": apiKey}).then(
        (value) {
          Map<String, dynamic> jsonData = jsonDecode(value.body);
          jsonData["photos"].forEach(
            (element) {
              PhotosModel photosModel = PhotosModel();
              photosModel = PhotosModel.fromMap(element);
              if (!photosModel.alt!.toLowerCase().contains('gay') &&
                  !photosModel.alt!.toLowerCase().contains('lgbt') &&
                  !photosModel.alt!.toLowerCase().contains('pride') &&
                  !photosModel.alt!.toLowerCase().contains('crowd') &&
                  !photosModel.alt!.toLowerCase().contains('stock') &&
                  !photosModel.alt!.toLowerCase().contains('girl') &&
                  !photosModel.alt!.toLowerCase().contains('bikini') &&
                  !photosModel.alt!.toLowerCase().contains('nude') &&
                  !photosModel.alt!.toLowerCase().contains('person') &&
                  !photosModel.alt!.toLowerCase().contains('men') &&
                  !photosModel.alt!.toLowerCase().contains('guy') &&
                  !photosModel.alt!.toLowerCase().contains('woman') &&
                  !photosModel.alt!.toLowerCase().contains('women') &&
                  !photosModel.alt!.toLowerCase().contains('couple') &&
                  !photosModel.alt!.toLowerCase().contains('people') &&
                  !photosModel.alt!.toLowerCase().contains('boy') &&
                  !photosModel.alt!.toLowerCase().contains('man') &&
                  !photosModel.alt!.toLowerCase().contains('male') &&
                  !photosModel.alt!.toLowerCase().contains('female') &&
                  !photosModel.alt!.toLowerCase().contains('church') &&
                  !photosModel.alt!.toLowerCase().contains('adult') &&
                  !photosModel.alt!.toLowerCase().contains('vintage') &&
                  !photosModel.alt!.toLowerCase().contains('friends') &&
                  !photosModel.alt!.toLowerCase().contains('anonymous') &&
                  !photosModel.alt!.toLowerCase().contains('lady') &&
                  !photosModel.alt!.toLowerCase().contains('lips') &&
                  !photosModel.alt!.toLowerCase().contains('teenagers') &&
                  !photosModel.alt!.toLowerCase().contains('tourist') &&
                  !photosModel.alt!.toLowerCase().contains('cross') &&
                  !photosModel.alt!.toLowerCase().contains('sex') &&
                  !photosModel.alt!.toLowerCase().contains('dancer') &&
                  !photosModel.alt!.toLowerCase().contains('wine') &&
                  photosModel.alt != null &&
                  photosModel.alt != ' ' &&
                  photosModel.alt != '') {
                photos.add(photosModel);
              }
            },
          );
          if (!mounted) return;
          setState(() {});
        },
      );
    } catch (e) {
      print(e);
    }
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    randomizeNumber(widget.randomizeRezOrNo);
    getCategorieWallpaper();
    super.initState();

    _scrollController.addListener(
      () {
        //counter of page number on scroll 36 img
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          numOfPage++;
          getCategorieWallpaper();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categorie),
        leading: IconButton(
          icon: Image.asset(
            'lib/assets/customIcons/arrow-back.png',
            color: Colors.deepPurpleAccent,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: wallPapers(photos, context, _scrollController),
    );
  }
}
