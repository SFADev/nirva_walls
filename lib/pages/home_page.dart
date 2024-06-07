import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../data/data_export.dart';
import '../models/models_export.dart';
import '../widget/widget_export.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numOfPage = 1;
  List<PhotosModel> photos = [];
  int numberOfScrolls = 0;

  //every time open app get a random number of number of the page
  randomizeNumber() {
    final rnd = Random.secure();
    numOfPage = rnd.nextInt(200) + 1;
  }

  //get photos as "search for photos" from api for home page
  getCurratedPhotos() async {
    randomizeNumber();
    try {
      await http.get(
          Uri.parse(
              "https://api.pexels.com/v1/search?query=nature+sahara+desert+switzerland+cars+travel+forest+landscape+mountains+sunset+animals+building+mosque+sky+car+pet+abstract&per_page=25&page=$numOfPage"),
          headers: {"Authorization": apiKey}).then(
        (value) {
          Map<String, dynamic> jsonData = jsonDecode(value.body);
          jsonData["photos"].forEach(
            (element) {
              PhotosModel photosModel = PhotosModel();
              photosModel = PhotosModel.fromMap(element);
              // filter for specify your app images
              if (!photosModel.alt!.toLowerCase().contains('person') &&
                  !photosModel.alt!.toLowerCase().contains('gay') &&
                  !photosModel.alt!.toLowerCase().contains('guy') &&
                  !photosModel.alt!.toLowerCase().contains('lgbt') &&
                  !photosModel.alt!.toLowerCase().contains('nude') &&
                  !photosModel.alt!.toLowerCase().contains('bikini') &&
                  !photosModel.alt!.toLowerCase().contains('man') &&
                  !photosModel.alt!.toLowerCase().contains('men') &&
                  !photosModel.alt!.toLowerCase().contains('male') &&
                  !photosModel.alt!.toLowerCase().contains('boy') &&
                  !photosModel.alt!.toLowerCase().contains('woman') &&
                  !photosModel.alt!.toLowerCase().contains('women') &&
                  !photosModel.alt!.toLowerCase().contains('girl') &&
                  !photosModel.alt!.toLowerCase().contains('female') &&
                  !photosModel.alt!.toLowerCase().contains('lady') &&
                  !photosModel.alt!.toLowerCase().contains('couple') &&
                  !photosModel.alt!.toLowerCase().contains('people') &&
                  !photosModel.alt!.toLowerCase().contains('friends') &&
                  !photosModel.alt!.toLowerCase().contains('church') &&
                  !photosModel.alt!.toLowerCase().contains('adult') &&
                  !photosModel.alt!.toLowerCase().contains('teenagers') &&
                  !photosModel.alt!.toLowerCase().contains('vintage') &&
                  !photosModel.alt!.toLowerCase().contains('anonymous') &&
                  !photosModel.alt!.toLowerCase().contains('stock') &&
                  !photosModel.alt!.toLowerCase().contains('tourist') &&
                  !photosModel.alt!.toLowerCase().contains('cross') &&
                  !photosModel.alt!.toLowerCase().contains('buddha') &&
                  !photosModel.alt!.toLowerCase().contains('dancer') &&
                  !photosModel.alt!.toLowerCase().contains('wine') &&
                  !photosModel.alt!.toLowerCase().contains('lgpt') &&
                  !photosModel.alt!.toLowerCase().contains('mother') &&
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

  //referesh wallpapers on using refreshindicator
  bool isConnected = false; // to check internet connetion
  Future<void> _refreshWallpapers() async {
    if (isConnected) {
      await Future.delayed(
        const Duration(
          seconds: 2,
        ),
      );
      setState(
        () {
          photos.clear();
          getCurratedPhotos();
        },
      );
    } else {
      const Center(
        child: Image(
          image: AssetImage('lib/assets/images/loading.png'),
          width: 125,
        ),
      );
    }
  }

  //bannerHome
  late BannerAd myBannerAdHome; //, myBannerAdSearch;
  bool isAdLoadedBannHome = false; //, isAdLoadedBannSearch = false;
  iniBannerAdHome() {
    myBannerAdHome = BannerAd(
      size: AdSize.banner,
      adUnitId: AdsManager.bannerAdUnitIdHome,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(
            () {
              isAdLoadedBannHome = true;
            },
          );
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          // print(error);
        },
      ),
      request: const AdRequest(),
    );
    myBannerAdHome.load();
  }

  //InterstitialAd home page and fullpage
  late InterstitialAd myinterstitialAdHome;
  bool isAdLoadedinterstitialFullImg = false;
  interstitialAdFullImg() {
    InterstitialAd.load(
      adUnitId: AdsManager.interstitialAdUnitIdHome,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          myinterstitialAdHome = ad;
          setState(
            () {
              isAdLoadedinterstitialFullImg = true;
            },
          );
          myinterstitialAdHome.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
            },
          );
        },
        onAdFailedToLoad: (error) {
          myinterstitialAdHome.dispose();
        },
      ),
    );
  }

  final ScrollController _scrollController = ScrollController();
  bool _isVisible = false; // Variable to track floating action button visibility
  late StreamSubscription subscription;

  @override
  void initState() {
    iniBannerAdHome();
    interstitialAdFullImg();
    getCurratedPhotos();

    super.initState();
    // listen to connectivity changes ;
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        if (result == ConnectivityResult.none) {
          setState(
            () {
              isConnected = false;
            },
          );
        } else {
          setState(
            () {
              isConnected = true;
            },
          );
        }
      },
    );
    _scrollController.addListener(
      () {
        //counter of page number on scroll 25 img
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          numOfPage++;
          numberOfScrolls++;
          if (numberOfScrolls == 2) {
            if (isAdLoadedinterstitialFullImg) {
              myinterstitialAdHome.show();
              interstitialAdFullImg();
              iniBannerAdHome();
              numberOfScrolls = 0;
            }
          }
          getCurratedPhotos();
        }
        // Check if the user is scrolling down
        if (_scrollController.position.pixels > 2000) {
          // Show the floating action button
          setState(() {
            _isVisible = true;
          });
        } else {
          // Hide the floating action button
          setState(() {
            _isVisible = false;
          });
        }
      },
    );
  }

  @override
  dispose() {
    subscription.cancel();
    // Dispose of the ScrollController when the widget is disposed
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          //logo
          title: const SizedBox(
            height: 30,
            width: 30,
            child: Image(
              image: AssetImage(
                'lib/assets/customIcons/Nlogo.png', //TODO : change it with the logo of your app
              ),
              color: Color.fromARGB(255, 255, 102, 133),
            ),
          ),
          // show ad here
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(
              isAdLoadedBannHome ? myBannerAdHome.size.height.toDouble() : 0.0,
            ),
            child: isAdLoadedBannHome
                ? SizedBox(
                    height: myBannerAdHome.size.height.toDouble(),
                    width: myBannerAdHome.size.width.toDouble(),
                    child: AdWidget(ad: myBannerAdHome),
                  )
                : const SizedBox(
                    height: 0,
                  ),
          ),
        ),
        //wallpapers in the home page
        body: LiquidPullToRefresh(
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: isConnected
              ? wallPapers(
                  photos,
                  context,
                  _scrollController,
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image(
                        image: AssetImage('lib/assets/images/loading.png'),
                        width: 125,
                      ),
                    ],
                  ),
                ),
          onRefresh: _refreshWallpapers,
        ),
        // floating action button to scroll to the top
        floatingActionButton: _isVisible
            ? FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.surface,
                onPressed: () {
                  if (_scrollController.hasClients) {
                    // Scroll to the top
                    _scrollController.animateTo(
                      0.0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: const Icon(
                  Icons.keyboard_double_arrow_up_rounded,
                  color: Color.fromARGB(255, 255, 102, 133),
                ),
              )
            : null,
      ),
    );
  }
}
