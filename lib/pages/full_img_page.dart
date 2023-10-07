import 'dart:isolate';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import '../data/ads_manager.dart';
import '../widget/widget_export.dart';

class FullImgPage extends StatefulWidget {
  const FullImgPage({
    super.key,
    required this.imgPath,
    required this.imgPathview,
    required this.photographer,
    required this.alt,
    required this.width,
    required this.height,
  });
  final String imgPath, imgPathview, photographer, alt;
  final int width, height;
  @override
  FullImgPageState createState() => FullImgPageState();
}

class FullImgPageState extends State<FullImgPage> {
  Color myColor = Colors.transparent;

//flutter downloader
  _downloadImage(String url) async {
    // final imgPath = await getExternalStorageDirectory();
    await FlutterDownloader.enqueue(
      url: url,
      savedDir: "/storage/emulated/0/Pictures/",
      showNotification: true,
      openFileFromNotification: true,
      saveInPublicStorage: true,
      fileName:
          'FreeWall-${widget.photographer}(${widget.width}x${widget.height})', // TODO:change it with the name of the app
    );
  }

  final ReceivePort _port = ReceivePort();

  //InterstitialAd home page and full page
  late InterstitialAd myinterstitialAdFullImg;
  bool isAdLoadedinterstitialFullImg = false;
  interstitialAdFullImg() {
    InterstitialAd.load(
      adUnitId: AdsManager.interstitialAdUnitIdFullImg,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          myinterstitialAdFullImg = ad;

          setState(
            () {
              isAdLoadedinterstitialFullImg = true;
            },
          );

          myinterstitialAdFullImg.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
            },
          );
        },
        onAdFailedToLoad: (error) {
          myinterstitialAdFullImg.dispose();
        },
      ),
    );
  }

  @override
  void initState() {
    interstitialAdFullImg();
    super.initState();
    //flutter downloader
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen(
      (dynamic data) {
        setState(() {});
      },
    );

    FlutterDownloader.registerCallback(downloadCallback);
  }

//flutter downloader start
  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

//flutter downloader end
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.imgPathview,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: kIsWeb
                  ? Image.network(widget.imgPathview, fit: BoxFit.cover)
                  : CachedNetworkImage(
                      imageUrl: widget.imgPathview,
                      placeholder: (context, url) => Container(
                        color: Theme.of(context).colorScheme.background,
                      ),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                    ),
                    //back button
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width / 7,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                  child:const Icon(Icons.arrow_back),
                                  //  const ImageIcon(
                                  //   AssetImage(
                                  //     'lib/assets/customIcons/arrow-back.png',
                                  //   ),
                                  // ),
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Back",
                            style: TextStyle(
                              color: Color(0xffffffff),
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    //download button
                    InkWell(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 7,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: myColor,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10.0,
                                  sigmaY: 10.0,
                                ),
                                child:const Icon(Icons.download),
                                // const ImageIcon(
                                //   AssetImage(
                                //     'lib/assets/customIcons/download.png',
                                //   ),
                                // ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Save',
                            style: TextStyle(
                              color: Color(0xffffffff),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      onTap: () async {
                        setState(() {
                          myColor = Colors.white12;
                        });

                        await Future.delayed(const Duration(milliseconds: 500));

                        setState(() {
                          myColor = Colors.transparent;
                        });

                        await Future.delayed(const Duration(seconds: 1));

                        if (isAdLoadedinterstitialFullImg) {
                          myinterstitialAdFullImg.show();
                        } else {
                          interstitialAdFullImg();
                        }
                        interstitialAdFullImg();
                        //downloadImg
                        if (kIsWeb) {
                          launchURL(widget.imgPath);
                        } else {
                          _askPermission();
                        }
                      },
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    //info button
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(14.0)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(8.0),
                                    width: double.infinity,
                                    child: Text(
                                      //alt
                                      widget.alt,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                  Divider(
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 14.0,
                                      top: 20,
                                    ),
                                    // width: double.infinity,
                                    child: Text(
                                      'Photographer : ${widget.photographer}',
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 14.0, top: 20, bottom: 18),
                                    width: double.infinity,
                                    child: Text(
                                      'Dimensions : ${widget.width} x ${widget.height} ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 7,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                child: const Icon(Icons.info),
                                // ImageIcon(
                                //   AssetImage(
                                //     'lib/assets/customIcons/info.png',
                                //   ),
                                // ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Info',
                            style: TextStyle(
                              color: Color(0xffffffff),
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _save() async {
    _downloadImage(widget.imgPath);
  }

  _askPermission() async {
    var status = await Permission.storage.status;
    if (status.isPermanentlyDenied || status.isRestricted || status.isLimited) {
      openAppSettings();
    }
    if (status.isGranted) {
      _save();
    } else if (status.isDenied) {
      if (await Permission.storage.request().isGranted) {
        _save();
      }
    }
  }
}
