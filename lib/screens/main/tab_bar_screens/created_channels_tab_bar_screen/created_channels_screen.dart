import 'dart:async';
import 'package:flutter/material.dart';
import 'package:merume_mobile/providers/error_provider.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/api/user_api/user_channels_api/created_channels_api.dart/created_channels_api.dart';
import 'package:merume_mobile/screens/shared/error_consumer_display_widget.dart';
import 'package:merume_mobile/screens/main/channel_screens/channels_list_widget.dart';
import 'package:merume_mobile/constants/text_styles.dart';
import 'package:merume_mobile/utils/data_fetching_utils/basic_stream_data_handler.dart';
import 'package:provider/provider.dart';

class CreatedChannelsScreen extends StatefulWidget {
  const CreatedChannelsScreen({super.key});

  @override
  State<CreatedChannelsScreen> createState() => _CreatedChannelsScreenState();
}

class _CreatedChannelsScreenState extends State<CreatedChannelsScreen> {
  final itemsController = StreamController<List<Channel>>();
  late BasicStreamDataHandler<List<Channel>> streamDataHandler;
  late ErrorProvider errorProvider;

  ErrorConsumerDisplay errorDisplayWidget = const ErrorConsumerDisplay();

  @override
  void initState() {
    super.initState();
    errorProvider = Provider.of<ErrorProvider>(context, listen: false);
    const timerDuration = Duration(seconds: 10);

    streamDataHandler = BasicStreamDataHandler<List<Channel>>(
      context: context,
      fetchFunction: fetchOwnChannels,
      controller: itemsController,
      errorProvider: errorProvider,
      retryTimerDuration: timerDuration,
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
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, right: 30.0, left: 30.0),
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
                            itemBuilder: (_, index) => ChannelsListWidget(
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
            ),
          ],
        ),
      ),
    );
  }
}
