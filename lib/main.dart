import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../pages/pages_export.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await FlutterDownloader.initialize(
    debug: false, // optional: set to false to disable printing logs to console (default: true)
    ignoreSsl: true, // option: set to false to disable working with http links (default: false)
  );
  runApp(
    const FreeWall(),
  );
}

class FreeWall extends StatefulWidget {
  const FreeWall({super.key});

  @override
  State<FreeWall> createState() => _FreeWallState();
}

class _FreeWallState extends State<FreeWall> {
  //this for buttomnavigationbar
  int indexNow = 0;
  void onTap(int index) {
    setState(
      () {
        indexNow = index;
      },
    );
  }

  //bottom navigation bar list of pages
  List<Widget> pages = [
    const HomePage(),
    const CategoryPage(),
    const SearchPage(),
    const MePage(),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // changing theme using provider the button is on me_page
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, child) {
        final provider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: provider.currentTheme,
          title: 'NirvaWalls', // TODO : change it with the name of the app
          // for handling errors
          builder: (context, widget) {
            Widget error = const Text('...rendering error...');
            if (widget is Scaffold || widget is Navigator) {
              error = Scaffold(body: Center(child: error));
            }
            ErrorWidget.builder = (errorDetails) => error;
            if (widget != null) return widget;
            throw ('widget is null');
          },
          home: Scaffold(
            //body
            body: IndexedStack(
              index: indexNow,
              children: pages,
            ),
            //bottomnavigationbar
            bottomNavigationBar: BottomNavigationBar(
              onTap: onTap,
              currentIndex: indexNow,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                  label: 'Home',
                  icon: ImageIcon(AssetImage('lib/assets/customIcons/home.png',)),
                ),
                BottomNavigationBarItem(
                  label: 'Category',
                  icon: ImageIcon(AssetImage('lib/assets/customIcons/category.png')),
                ),
                BottomNavigationBarItem(
                  label: 'Search',
                  icon: ImageIcon(AssetImage('lib/assets/customIcons/search.png')),
                ),
                BottomNavigationBarItem(
                  label: 'Me',
                  icon: ImageIcon(AssetImage('lib/assets/customIcons/user.png')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
