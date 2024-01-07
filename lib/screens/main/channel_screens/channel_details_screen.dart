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
    _followersFuture = getChannelFollowers(widget.channel.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''), // Remove the title from here
        actions: [
          IconButton(
            onPressed: () {
              print('hi');
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ), // Three dots icon
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white), // Back arrow color
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircleAvatar(
                  radius: 80.0,
                  backgroundImage: widget.channel.channelProfilePictureUrl !=
                          null
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
                    FutureBuilder<List<User>>(
                      future: _followersFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Show a loading indicator while fetching data
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text('No followers available');
                        } else {
                          // Display the list of followers here
                          return Column(
                            children: [
                              const Text('Followers:',
                                  style: TextStyle(fontSize: 18.0)),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final follower = snapshot.data![index];
                                  return ListTile(
                                    title: Text(follower.nickname),
                                    subtitle: Text(follower.email),
                                  );
                                },
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
