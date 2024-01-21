import 'dart:async';
import 'package:flutter/material.dart';
import 'package:merume_mobile/api/channel_api/channel_followers_api.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/models/user_model.dart';
import 'package:merume_mobile/other/colors.dart';
import 'package:merume_mobile/other/exceptions.dart';
import 'package:merume_mobile/screens/components/last_time_online.dart';
import 'package:merume_mobile/screens/main/other_user_screens/other_user_screen.dart';
import 'package:merume_mobile/screens/main/tab_bar_screens/account_tab_bar_screen/account_screen.dart';

class ChannelDetailsScreen extends StatefulWidget {
  final Channel channel;

  const ChannelDetailsScreen({super.key, required this.channel});

  @override
  State<ChannelDetailsScreen> createState() => _ChannelDetailsScreenState();
}

class _ChannelDetailsScreenState extends State<ChannelDetailsScreen> {
  late Future<List<User>> _followersFuture;
  late Timer _timer;

  @override
  void initState() {
    try {
      super.initState();
      _followersFuture =
          getChannelFollowers(widget.channel.id); // Initial fetch
      _startTimer();
    } catch (e) {
      if (e is TokenErrorException) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer t) async {
      await refreshFollowers();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              onPressed: () {
                print('hi');
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(20.0),
            child: SizedBox(
              height: 40.0, // Adjust the height as needed
              child: TabBar(
                indicatorColor: AppColors.lavenderHaze,
                labelStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: AppColors.lavenderHaze,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(text: 'Details'),
                  Tab(text: 'Followers'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            detailsTab(),
            followersTab(),
          ],
        ),
      ),
    );
  }

  Widget detailsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            child: CircleAvatar(
              radius: 80.0,
              backgroundImage: widget.channel.channelProfilePictureUrl != null
                  ? NetworkImage(widget.channel.channelProfilePictureUrl!)
                  : const AssetImage('assets/images/pfp_outline.png')
                      as ImageProvider,
            ),
          ),
          Text(
            widget.channel.name,
            style: const TextStyle(
              fontSize: 24.0,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text(
                    'Current Challenge Day',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Poppins',
                      color: AppColors.mellowLemon,
                    ),
                  ),
                  subtitle: Text(
                    widget.channel.currentChallengeDay.toString(),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'WorkSans',
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Divider(
                  color: AppColors.lavenderHaze.withOpacity(0.5),
                  thickness: 1,
                ),
                ListTile(
                  title: const Text(
                    'Subscribers',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Poppins',
                      color: AppColors.mellowLemon,
                    ),
                  ),
                  subtitle: Text(
                    widget.channel.followers.currentFollowing.toString(),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'WorkSans',
                      color: Colors.white,
                    ),
                  ),
                ),
                Divider(
                  color: AppColors.lavenderHaze.withOpacity(0.5),
                  thickness: 1,
                ),
                ListTile(
                  title: const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Poppins',
                      color: AppColors.mellowLemon,
                    ),
                  ),
                  subtitle: Text(
                    widget.channel.description,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'WorkSans',
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Divider(
                  color: AppColors.lavenderHaze.withOpacity(0.5),
                  thickness: 1,
                ),
                ListTile(
                  title: const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Poppins',
                      color: AppColors.mellowLemon,
                    ),
                  ),
                  subtitle: Text(
                    widget.channel.categories.join(', '),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'WorkSans',
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Divider(
                  color: AppColors.lavenderHaze.withOpacity(0.5),
                  thickness: 1,
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget followersTab() {
    // FutureBuilder for followers list
    return RefreshIndicator(
      onRefresh: () async {
        // Trigger the refresh logic here
        await refreshFollowers();
      },
      child: FutureBuilder<List<User>>(
        future: _followersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Oops! Something went wrong.\nPlease try again later.',
                    style: TextStyle(
                      color: AppColors.lightGrey,
                      fontFamily: 'Poppins',
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final follower = snapshot.data![index];
                      final isAuthor = follower.id == widget.channel.author.id;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ListTile(
                          onTap: () {
                            // Navigate to AuthorScreen for the owner (author),
                            // otherwise navigate to OtherUserScreen
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => isAuthor
                                    ? const AccountScreen()
                                    : OtherUserScreen(user: follower),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: follower.pfpLink != null
                                ? NetworkImage(follower.pfpLink!)
                                : const AssetImage(
                                        'assets/images/pfp_outline.png')
                                    as ImageProvider,
                          ),
                          title: Row(
                            children: [
                              Text(
                                follower.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                '@${follower.nickname}',
                                style: const TextStyle(
                                  color: AppColors.mellowLemon,
                                  fontFamily: 'Poppins',
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isAuthor)
                                const Text(
                                  'Owner',
                                  style: TextStyle(
                                    color: AppColors.royalPurple,
                                    fontFamily: 'Poppins',
                                    fontSize: 14.0,
                                  ),
                                ),
                              Text(
                                follower.isOnline == true
                                    ? 'Online'
                                    : formatLastSeen(follower.lastTimeOnline),
                                style: TextStyle(
                                  color: follower.isOnline == true
                                      ? Colors.green
                                      : AppColors.lightGrey,
                                  fontFamily: 'Poppins',
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  // Add this method to handle refreshing the followers
  Future<void> refreshFollowers() async {
    try {
      // Fetch the updated followers list
      final updatedFollowers = await getChannelFollowers(widget.channel.id);

      // Update the state with the new followers list
      setState(() {
        _followersFuture = Future.value(updatedFollowers);
      });
    } catch (e) {
      // Handle errors if necessary
      print('Error refreshing followers: $e');
      // You may want to show a snackbar or some UI indication of the error
    }
  }
}
