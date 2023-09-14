import 'package:flutter/material.dart';
// import 'package:merume_mobile/colors.dart';

import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/api/user_channels_api.dart';
import 'package:merume_mobile/screens/main/components/channel_widget.dart';

class CreatedChannelsScreen extends StatefulWidget {
  const CreatedChannelsScreen({Key? key}) : super(key: key);

  @override
  State<CreatedChannelsScreen> createState() => _CreatedChannelsScreenState();
}

class _CreatedChannelsScreenState extends State<CreatedChannelsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 20.0, bottom: 0.0, right: 30.0, left: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: StreamBuilder<List<Channel>>(
                  stream: fetchOwnChannels(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final channels = snapshot.data!;
                      return ListView.builder(
                        itemCount: channels.length,
                        itemBuilder: (_, index) => ChannelWidget(
                          channel: channels[index],
                        ),
                      );
                    } else if (snapshot.hasError) {
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
