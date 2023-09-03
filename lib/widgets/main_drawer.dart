// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zera3ati_app/screens/help_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  //final websiteUrl = Uri.parse('http://www.ncare.gov.jo/DefaultEN.aspx');

  @override
  Widget build(BuildContext context) {
    void showInfoMessage() {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text(
              "LMAOOOO THIS MF NEEDS HELP",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.onSecondary,
                  Theme.of(context).colorScheme.background.withOpacity(0.85),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.grass_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(
                  width: 18,
                ),
                Text(
                  'Farming \nIntelligently...',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.grey,
                      ),
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.help,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Help',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              Get.to(const HelpScreen());
            },
          ),
          ListTile(
            leading: Icon(
              Icons.menu_book_sharp,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Resources',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () async {
              const url = 'http://www.ncare.gov.jo/DefaultEN.aspx';
              await launch(
                url,
                forceSafariVC: false,
                forceWebView: true,
                enableJavaScript: true,
              );
            },
          ),
        ],
      ),
    );
  }
}
