import 'package:flutter/material.dart';
import 'package:merume_mobile/constants/colors.dart';
import 'package:merume_mobile/screens/main/tab_bar_screens/followed_channels_tab_bar_screen/tabs/followed_channels_screen.dart';
import 'package:merume_mobile/screens/main/tab_bar_screens/followed_channels_tab_bar_screen/tabs/recommendation_screen.dart';
import 'package:merume_mobile/providers/user_provider.dart';
import 'package:provider/provider.dart';

class FollowingTabScreen extends StatefulWidget {
  const FollowingTabScreen({super.key});

  @override
  State<FollowingTabScreen> createState() => _FollowingTabScreenState();
}

class _FollowingTabScreenState extends State<FollowingTabScreen> {
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserProvider>(context, listen: true).userInfo;

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
                  labelStyle: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: AppColors.lavenderHaze),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(text: 'Followed'),
                    Tab(text: 'For you'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    buildFollowedChannelsTab(),
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

  Widget buildFollowedChannelsTab() {
    return const FollowingChannelsScreen();
  }

  Widget buildRecommendationsTab(List<String>? preferences) {
    return RecommendationScreen(preferences: preferences);
  }
}
