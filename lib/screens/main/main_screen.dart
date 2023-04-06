import 'package:flutter/material.dart';
import 'package:merume_mobile/screens/main/tab_bar_screens/created_channels_screen.dart';
import 'package:merume_mobile/screens/main/tab_bar_screens/subscriptions_channels_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Color littleLight = const Color(0xFFF3FFAB);
  Color purpleBeaty = const Color(0xFF8E05C2);

  int _currentIndex = 0;

  final List<Widget> _screens = [
    CreatedChannelsScreen(),
    SubscriptionChannelsScreen(),
  ];

  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Merume');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            padding: const EdgeInsets.only(left: 20.0), child: customSearchBar),
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
                    ); // Perform set of instructions.
                  } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text('Merume');
                  }
                });
              },
              icon: customIcon,
            ),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.5),
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.deepPurpleAccent),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.subscriptions, color: Colors.deepPurpleAccent),
              label: 'Owned',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.deepPurpleAccent),
              label: 'Profile',
            ),
            // other bottom tab bar items here
          ],
        ),
      ),
    );
  }
}
