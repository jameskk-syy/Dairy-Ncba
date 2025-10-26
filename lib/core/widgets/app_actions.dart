import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../feature/auth/presentation/pages/login_page.dart';
import '../../feature/profile/presentation/pages/profile_page.dart';

Widget appBarAction(BuildContext context) {
  return IconButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 2,
                    width: 30,
                    color: Colors.black,
                    child: const Center(child: Text("Menu")),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: ListTile(
                      leading: const Icon(Icons.account_circle_sharp),
                      title: const Text('Profile'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfilePage()));
                      },
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                    child: ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () async {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                            (route) => false);
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                      },
                    ),
                  ),
                ],
              );
            });
      },
      icon: const Icon(
        Icons.account_circle_sharp,
        size: 30,
      ));
}
