import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:merume_mobile/api/user_api/user_channels_api/followed_channels_api.dart/followed_channels_api.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/providers/error_provider.dart';
import 'package:merume_mobile/screens/main/channel_screens/channels_list_widget.dart';
import 'package:merume_mobile/screens/shared/error_consumer_display_widget.dart';
import 'package:merume_mobile/constants/exceptions.dart';
import 'package:merume_mobile/utils/navigate_to_login.dart';
import 'package:merume_mobile/constants/text_styles.dart';
import 'package:provider/provider.dart';

class FollowingChannelsScreen extends StatefulWidget {
  final ErrorConsumerDisplay? errorDisplayWidget;

  const FollowingChannelsScreen({super.key, this.errorDisplayWidget});

  @override
  State<FollowingChannelsScreen> createState() =>
      _FollowingChannelsScreenState();
}

class _FollowingChannelsScreenState extends State<FollowingChannelsScreen>
    with AutomaticKeepAliveClientMixin {
  final itemsController = StreamController<List<Channel>>();
  late ErrorProvider errorProvider;
  Timer? _retryTimer;

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
    _retryTimer?.cancel();
    super.dispose();
  }

  void _initializeStream() {
    _fetchChannels();
  }

  void _fetchChannels() {
    fetchFollowings().listen(
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
        if (kDebugMode) {
          print('Error in following channels: $error');
        }

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
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 22.0, bottom: 0.0, right: 30.0, left: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Expanded(
                    child: StreamBuilder<List<Channel>>(
                      stream: itemsController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text(
                                'No channels yet..',
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
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (widget.errorDisplayWidget != null)
              Align(
                alignment: Alignment.topCenter,
                child: widget.errorDisplayWidget,
              )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
