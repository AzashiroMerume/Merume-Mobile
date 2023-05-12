import 'package:flutter/material.dart';

import '../../../api/recommendations_api.dart';
import '../../../models/channel_model.dart';
import '../../../models/post_model.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  Color littleLight = const Color(0xFFF3FFAB);
  Color purpleBeaty = const Color(0xFF8E05C2);

  String currentPressedFilter = 'All';
  List<String> filterOptions = ['All', 'Trending'];
  // ignore: prefer_final_fields
  List<bool> _isSelected = [true, false, false, false];

  void _onFilterButtonPressed(int index) {
    setState(() {
      // Reset all the buttons to unselected
      for (int buttonIndex = 0;
          buttonIndex < _isSelected.length;
          buttonIndex++) {
        _isSelected[buttonIndex] = false;
      }

      // Select the pressed button
      _isSelected[index] = true;

      // Update the current pressed filter
      currentPressedFilter = filterOptions[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> filterButtons = [];

    for (int i = 0; i < filterOptions.length; i++) {
      filterButtons.add(Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: ElevatedButton(
          onPressed: () => _onFilterButtonPressed(i),
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(100, 35),
            backgroundColor: _isSelected[i] ? littleLight : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: _isSelected[i] ? littleLight : purpleBeaty,
                width: 1,
              ),
            ),
          ),
          child: Text(
            filterOptions[i],
            style: TextStyle(
              fontFamily: 'WorkSans',
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: _isSelected[i] ? Colors.black : Colors.white,
            ),
          ),
        ),
      ));
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 22.0, bottom: 0.0, right: 30.0, left: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: filterButtons,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 10), // Adjust the top margin value as needed
                  child: FutureBuilder<Map<Channel, Post>>(
                    future: fetchRecommendations(0),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final channelPostMap = snapshot.data!;
                        final channels = channelPostMap.keys.toList();
                        return ListView.builder(
                          itemCount: channels.length,
                          itemBuilder: (_, index) {
                            final channel = channels[index];
                            final post = channelPostMap[channel]!;
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: const Color(0xff97FFFF),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Channel information
                                  Text(
                                    'Channel Name: ${channel.name}',
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                      'Subscriptions: ${channel.subscriptions.currentSubscriptions}'),
                                  Text('Author: ${post.ownerId}'),
                                  const SizedBox(height: 10),

                                  // Post content
                                  Text(post.body),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
