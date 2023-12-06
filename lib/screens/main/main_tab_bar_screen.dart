import 'package:flutter/material.dart';
import 'package:merume_mobile/other/colors.dart';
import 'package:merume_mobile/screens/main/add_channel_screens/add_channel_screen_2.dart';
import 'package:merume_mobile/screens/main/tab_bar_screens/account_tab_bar_screen/account_screen.dart';
import 'package:merume_mobile/screens/main/tab_bar_screens/created_channels_tab_bar_screen/created_channels_screen.dart';
import 'package:merume_mobile/screens/main/tab_bar_screens/followings_channels_tab_bar_screen/following_tab_screen.dart';

class MainTabBarScreen extends StatefulWidget {
  const MainTabBarScreen({super.key});

  @override
  State<MainTabBarScreen> createState() => _MainTabBarScreenState();
}

class _MainTabBarScreenState extends State<MainTabBarScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CreatedChannelsScreen(),
    const FollowingTabScreen(),
    const AccountScreen(),
  ];

  Icon customIcon = const Icon(Icons.search);
  Icon addIcon = const Icon(Icons.add);
  Widget customSearchBar = const Text(
    'Merume',
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _currentIndex == 1
            ? null
            : AppBar(
                foregroundColor: Colors.white,
                title: Container(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: customSearchBar),
                automaticallyImplyLeading: false,
                actions: [
                  Container(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (customIcon.icon == Icons.search) {
                            customIcon = const Icon(Icons.cancel);
                            customSearchBar = const ListTile(
                              leading: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 28,
                              ),
                              title: TextField(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'search',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            );
                          } else {
                            customIcon = const Icon(Icons.search);
                            customSearchBar = const Text(
                              'Merume',
                            );
                          }
                        });
                      },
                      icon: customIcon,
                    ),
                  ),
                  if (customIcon.icon ==
                      Icons
                          .search) // Only show the "Add" icon when search is not active
                    Container(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AddChannelScreenSecond(),
                            ),
                          );
                        },
                        icon: addIcon,
                      ),
                    ),
                ],
              ),
        body: _screens[_currentIndex],
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.lavenderHaze.withOpacity(0.5),
                width: 1.0,
              ),
            ),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12.0,
            selectedIconTheme:
                const IconThemeData(color: AppColors.lavenderHaze),
            selectedItemColor: AppColors.lavenderHaze,
            unselectedIconTheme: const IconThemeData(color: Colors.white),
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.black,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.subscriptions),
                label: 'Followings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              // other bottom tab bar items here
            ],
          ),
        ),
      ),
    );
  }
}
