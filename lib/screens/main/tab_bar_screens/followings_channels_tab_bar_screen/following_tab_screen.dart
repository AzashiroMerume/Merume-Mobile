import 'package:flutter/material.dart';
import 'package:merume_mobile/colors.dart';
import 'package:merume_mobile/screens/main/tab_bar_screens/followings_channels_tab_bar_screen/tabs/following_channels_screen.dart';
import 'package:merume_mobile/screens/main/tab_bar_screens/followings_channels_tab_bar_screen/tabs/recommendation_screen.dart';
import 'package:merume_mobile/user_info.dart';
import 'package:provider/provider.dart';

class FollowingTabScreen extends StatefulWidget {
  const FollowingTabScreen({Key? key}) : super(key: key);

  @override
  State<FollowingTabScreen> createState() => _FollowingTabScreenState();
}

class _FollowingTabScreenState extends State<FollowingTabScreen> {
  @override
  Widget build(BuildContext context) {
    final userInfo =
        Provider.of<UserInfoProvider>(context, listen: false).userInfo;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: const TabBar(
                  indicatorColor: AppColors.lavenderHaze,
                  tabs: [
                    Tab(text: 'Followings'),
                    Tab(text: 'Recommendations'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Tab 1: Followings
                    buildFollowingsTab(),
                    // Tab 2: Recommendations
                    buildRecommendationsTab(userInfo!.preferences),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFollowingsTab() {
    return const FollowingChannelsScreen();
  }

  Widget buildRecommendationsTab(List<String>? preferences) {
    return RecommendationScreen(preferences: preferences);
  }
}
