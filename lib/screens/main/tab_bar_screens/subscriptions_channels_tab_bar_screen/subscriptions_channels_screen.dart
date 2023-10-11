import 'package:flutter/material.dart';
import 'package:merume_mobile/api/user_channels_api/subscried_channels_api.dart/subscried_channels_api.dart';
import 'package:merume_mobile/colors.dart';

import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/screens/main/components/channel_in_list_widget.dart';

class SubscriptionChannelsScreen extends StatefulWidget {
  const SubscriptionChannelsScreen({super.key});

  @override
  State<SubscriptionChannelsScreen> createState() =>
      _SubscriptionChannelsScreenState();
}

class _SubscriptionChannelsScreenState
    extends State<SubscriptionChannelsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 22.0, bottom: 0.0, right: 30.0, left: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<List<Channel>>(
                  stream: fetchSubscriptions(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        // If there are no channels, display the "No channels yet" message
                        return const Center(
                          child: Text(
                            'No channels yet..',
                            style: TextStyle(
                              color: AppColors.mellowLemon,
                              fontFamily: 'WorkSans',
                              fontSize: 15,
                            ),
                          ),
                        );
                      }

                      final channels = snapshot.data!;
                      return ListView.builder(
                        itemCount: channels.length,
                        itemBuilder: (_, index) => ChannelInListWidget(
                          channel: channels[index],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      //Handle err for user
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
