import 'dart:async';
import 'package:flutter/material.dart';
import 'package:merume_mobile/other/colors.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/api/user_api/user_channels_api/created_channels_api.dart/created_channels_api.dart';
import 'package:merume_mobile/other/exceptions.dart';
import 'package:merume_mobile/screens/main/channel_screens/channel_in_list_widget.dart';

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
    try {
      final Stream<List<Channel>> dataStream = fetchOwnChannels();
      itemsController.addStream(dataStream);
    } catch (e) {
      if (e is TokenExpiredException) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (Route<dynamic> route) => false,
        );
      }
      itemsController.addError(e);
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
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Oops! Something went wrong.\nPlease try again later.',
                              style: TextStyle(
                                color:
                                    AppColors.lightGrey, // Change color to grey
                                fontFamily: 'Poppins',
                                fontSize: 18, // Increase font size
                              ),
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: () {
                                // Retry action when button is pressed
                                _initializeStream();
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(150, 35),
                                backgroundColor: AppColors.royalPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: const BorderSide(
                                      color:
                                          AppColors.royalPurple // When pressed
                                      ),
                                ),
                              ),
                              child: const Text(
                                'Try Again',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
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
