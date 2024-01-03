import 'dart:async';
import 'package:flutter/material.dart';
import 'package:merume_mobile/other/colors.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/api/user_api/user_channels_api/created_channels_api.dart/created_channels_api.dart';
import 'package:merume_mobile/screens/main/channel_screens/channel_in_list_widget.dart';

class CreatedChannelsScreen extends StatefulWidget {
  const CreatedChannelsScreen({super.key});

  @override
  State<CreatedChannelsScreen> createState() => _CreatedChannelsScreenState();
}

class _CreatedChannelsScreenState extends State<CreatedChannelsScreen> {
  late StreamController<List<Channel>> _streamController;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<List<Channel>>();
    _initializeStream();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _initializeStream() {
    try {
      final Stream<List<Channel>> dataStream = fetchOwnChannels();
      _streamController.addStream(dataStream);
    } catch (e) {
      _streamController.addError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 30.0, left: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: StreamBuilder<List<Channel>>(
                  stream: _streamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        // If there are no channels, display the "No channels yet" message
                        return const Center(
                          child: Text(
                            'No challenges yet..',
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
                      // Handle error for the user
                      return Text('Error occurred: ${snapshot.error}');
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
