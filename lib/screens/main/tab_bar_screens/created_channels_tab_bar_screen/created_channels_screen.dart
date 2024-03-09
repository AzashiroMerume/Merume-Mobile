import 'dart:async';
import 'package:flutter/material.dart';
import 'package:merume_mobile/providers/error_provider.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/api/user_api/user_channels_api/created_channels_api.dart/created_channels_api.dart';
import 'package:merume_mobile/utils/exceptions.dart';
import 'package:merume_mobile/screens/main/channel_screens/channels_list_widget.dart';
import 'package:merume_mobile/utils/navigate_to_login.dart';
import 'package:merume_mobile/utils/text_styles.dart';
import 'package:provider/provider.dart';

class CreatedChannelsScreen extends StatefulWidget {
  const CreatedChannelsScreen({super.key});

  @override
  State<CreatedChannelsScreen> createState() => _CreatedChannelsScreenState();
}

class _CreatedChannelsScreenState extends State<CreatedChannelsScreen> {
  final itemsController = StreamController<List<Channel>>();
  late ErrorProvider errorProvider;
  late Timer _retryTimer;

  @override
  void initState() {
    super.initState();
    errorProvider = Provider.of<ErrorProvider>(context, listen: false);
    _initializeStream();
  }

  @override
  void dispose() {
    itemsController.sink.close();
    itemsController.close();
    _retryTimer.cancel();
    super.dispose();
  }

  void _initializeStream() {
    _fetchChannels();
  }

  void _fetchChannels() {
    fetchOwnChannels().listen(
      (List<Channel> channels) {
        // Data received successfully
        if (errorProvider.showError) {
          errorProvider.clearError();
        }

        if (!itemsController.isClosed) {
          itemsController.add(channels);
        }
      },
      onError: (error) {
        print('Error in created channels: $error');

        if (error is TokenErrorException) {
          navigateToLogin(context);
        }

        errorProvider.setError(10);

        // Retry fetching channels with a timer
        _retryTimer = Timer(const Duration(seconds: 10), () {
          if (!itemsController.isClosed) {
            _fetchChannels();
          }
        });

        if (!itemsController.isClosed) {
          itemsController.addError(error);
        }
      },
    );
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
                        return const Center(
                          child: Text(
                            'You do not have any challenges yet..',
                            style: TextStyles.errorSmall,
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
                          'Oops! Something went wrong...',
                          style: TextStyles.errorBig,
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
