import 'dart:async';
import 'package:flutter/material.dart';
import 'package:merume_mobile/api/channel_api/channel_followers_api.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/models/user_model.dart';
import 'package:merume_mobile/other/colors.dart';

class ChannelDetailsScreen extends StatefulWidget {
  final Channel channel;

  const ChannelDetailsScreen({super.key, required this.channel});

  @override
  State<ChannelDetailsScreen> createState() => _ChannelDetailsScreenState();
}

class _ChannelDetailsScreenState extends State<ChannelDetailsScreen> {
  late Future<List<User>> _followersFuture;

  @override
  void initState() {
    super.initState();
    _followersFuture = getChannelFollowers(widget.channel.id); // Initial fetch
    Timer.periodic(const Duration(seconds: 10), (Timer t) {
      _followersFuture =
          getChannelFollowers(widget.channel.id); // Fetch every 5 seconds
    });
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
                  : const AssetImage('assets/images/isagi.jpg')
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
    return FutureBuilder<List<User>>(
      future: _followersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: AppColors.lightGrey),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No followers available',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          // Display the list of followers here
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final follower = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: follower.pfpLink != null
                              ? NetworkImage(follower.pfpLink!)
                              : const AssetImage('assets/images/isagi.jpg')
                                  as ImageProvider,
                        ),
                        title: Text(
                          follower.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(
                          '@${follower.nickname}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 12,
                          ),
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
    );
  }
}
