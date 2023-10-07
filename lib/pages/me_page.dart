import 'package:cool_wallpaper/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import '../widget/widget_export.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  bool onORoff = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'ME',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Image(
                image: AssetImage(
                  'lib/assets/images/meimage.png',
                ),
                height: 250,
              ),
            ),
            //change theme switch
            Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.mode_night_outlined,
                  color: Colors.deepPurpleAccent,
                ),
                title: const Text(
                  'Change theme',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                trailing: Switch(
                  trackColor: MaterialStateProperty.all(Theme.of(context).colorScheme.background),
                  trackOutlineColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
                  activeColor: const Color.fromARGB(255, 255, 102, 133),
                  inactiveThumbColor: Colors.deepPurple,
                  value: onORoff,
                  onChanged: (value) {
                    setState(() {
                      onORoff = value;
                    });
                    provider.toggleTheme();
                  },
                ),
              ),
            ),
            //clear cache button
            Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: GestureDetector(
                onTap: () async {
                  const snackBar = SnackBar(
                    content: Text(
                      'App cache has been cleared (◔◡◔).',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.deepPurple,
                  );
                  await DefaultCacheManager().emptyCache();
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.cleaning_services,
                    color: Colors.deepPurpleAccent,
                  ),
                  title: Text(
                    'Clear Cache',
                  ),
                ),
              ),
            ),
            //about button and bottom sheet
            Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: GestureDetector(
                onTap: () => showModalBottomSheet(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  context: context,
                  builder: (context) => ClipRRect(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Application developed by :",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Overpass',
                                ),
                              ),
                              GestureDetector(
                                child: const Text(
                                  " SFADev",
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    fontSize: 12,
                                    fontFamily: 'Overpass',
                                  ),
                                ),
                                onTap: () async {
                                  await launchURL(
                                    "https://github.com/SFADev",
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // 2nd line of text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Photos provided by :",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Overpass',
                                ),
                              ),
                              GestureDetector(
                                child: const Text(
                                  " Pexels",
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    fontSize: 12,
                                    fontFamily: 'Overpass',
                                  ),
                                ),
                                onTap: () {
                                  launchURL(
                                    "https://www.pexels.com",
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Version :',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Overpass',
                                ),
                              ),
                              Text(
                                ' 1.0.0', // TODO : change this with the version of your app
                                style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontSize: 12,
                                  fontFamily: 'Overpass',
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                child: const ListTile(
                  leading: Icon(
                    Icons.help_outline_rounded,
                    color: Colors.deepPurpleAccent,
                  ),
                  title: Text('About'),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              color: Colors.deepPurple,
              indent: 50.0,
              endIndent: 50.0,
            )
          ],
        ),
      ),
    );
  }
}
