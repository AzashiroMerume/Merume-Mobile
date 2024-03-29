import 'dart:async';
import 'package:flutter/material.dart';
import 'package:merume_mobile/api/user_api/user_channels_api/followed_channels_api.dart/followed_channels_api.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/providers/error_provider.dart';
import 'package:merume_mobile/screens/main/channel_screens/channels_list_widget.dart';
import 'package:merume_mobile/screens/shared/error_consumer_display_widget.dart';
import 'package:merume_mobile/constants/text_styles.dart';
import 'package:merume_mobile/utils/data_fetching_utils/basic_stream_data_handler.dart';
import 'package:provider/provider.dart';

class FollowingChannelsScreen extends StatefulWidget {
  const FollowingChannelsScreen({super.key});

  @override
  State<FollowingChannelsScreen> createState() =>
      _FollowingChannelsScreenState();
}

class _FollowingChannelsScreenState extends State<FollowingChannelsScreen>
    with AutomaticKeepAliveClientMixin {
  final itemsController = StreamController<List<Channel>>();
  late BasicStreamDataHandler<List<Channel>> streamDataHandler;
  late ErrorProvider errorProvider;

  ErrorConsumerDisplay errorDisplayWidget = const ErrorConsumerDisplay();

  @override
  void initState() {
    super.initState();
    errorProvider = Provider.of<ErrorProvider>(context, listen: false);

    _initializeStream();
  }

  void _initializeStream() {
    streamDataHandler = BasicStreamDataHandler<List<Channel>>(
      context: context,
      fetchFunction: fetchFollowedChannels,
      controller: itemsController,
      errorProvider: errorProvider,
      retryDelaySeconds: 10,
    );
    streamDataHandler.fetchStreamData();
  }

  @override
  void dispose() {
    itemsController.sink.close();
    itemsController.close();
    streamDataHandler.dispose();
    super.dispose();
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
                            itemBuilder: (_, index) => ChannelItem(
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
            Align(
              alignment: Alignment.topCenter,
              child: errorDisplayWidget,
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
