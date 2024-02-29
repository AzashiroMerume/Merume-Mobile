import 'dart:async';
import 'package:flutter/material.dart';
import 'package:merume_mobile/utils/colors.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/api/user_api/user_channels_api/created_channels_api.dart/created_channels_api.dart';
import 'package:merume_mobile/utils/exceptions.dart';
import 'package:merume_mobile/screens/main/channel_screens/channels_list_widget.dart';

class CreatedChannelsScreen extends StatefulWidget {
  const CreatedChannelsScreen({super.key});

  @override
  State<CreatedChannelsScreen> createState() => _CreatedChannelsScreenState();
}

class _CreatedChannelsScreenState extends State<CreatedChannelsScreen> {
  final itemsController = StreamController<List<Channel>>();

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  @override
  void dispose() {
    itemsController.sink.close();
    itemsController.close();
    super.dispose();
  }

  void _initializeStream() {
    final Stream<List<Channel>> dataStream =
        fetchOwnChannels().handleError((error) {
      print('Error in created channels: $error');

      if (error is TokenErrorException) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (Route<dynamic> route) => false,
          );
        });
      }

      // Retry the initialization after 10 seconds
      Future.delayed(const Duration(seconds: 10), () {
        _initializeStream();
      });

      // Check if the stream controller's sink is not closed before adding an error
      if (!itemsController.isClosed) {
        itemsController.addError(error);
      }

      // Returning an empty list here to ensure the stream continues to emit, albeit with empty data
      return [];
    });

    // Add the data stream to the controller if the controller's sink is not closed
    if (!itemsController.isClosed) {
      itemsController.addStream(dataStream);
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
                  stream: itemsController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        // If there are no channels, display the "No channels yet" message
                        return const Center(
                          child: Text(
                            'You do not have any challenges yet..',
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
                        itemBuilder: (_, index) => ChannelsInListWidget(
                          channel: channels[index],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Oops! Something went wrong.\nPlease try again later.',
                          style: TextStyle(
                            color: AppColors.lightGrey,
                            fontFamily: 'Poppins',
                            fontSize: 18,
                          ),
                        ),
                      );
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
