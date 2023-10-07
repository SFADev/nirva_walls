import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_wallpaper/widget/shimmer_loading_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/photos_model.dart';
import '../pages/full_img_page.dart';
import 'package:url_launcher/url_launcher.dart';

wallPapers(
  List<PhotosModel> listPhotos,
  BuildContext context,
  ScrollController controller,
) {
  var random = Random();

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: GridView.count(
        controller: controller,
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        children: listPhotos.map(
          (PhotosModel photoModel) {
            return GridTile(
              child: GestureDetector(
                child: Hero(
                  tag: "${photoModel.src!.portrait}$random",
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: kIsWeb
                        ? Image.network(
                            photoModel.src!.portrait,
                            height: 50,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.amber,
                                child: const Icon(Icons.error),
                              );
                            },
                          )
                        : CachedNetworkImage(
                            imageUrl: photoModel.src!.portrait,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (context, url, progress) {
                              return const ShimmerLoading();
                            },
                            errorWidget: (context, url, error) {
                              return const Center(
                                child: Icon(
                                  Icons.error,
                                ),
                              );
                            },
                          ),
                  ),
                ),
                onTap: () {
                  photoModel.alt ?? (photoModel.alt = '...');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullImgPage(
                        imgPath: photoModel.src!.original,
                        imgPathview: photoModel.src!.portrait,
                        photographer: photoModel.photographer!,
                        alt: photoModel.alt!,
                        width: photoModel.width!,
                        height: photoModel.height!,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ).toList()),
  );
}

launchURL(String url) async {
  Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $uri');
  }
}
