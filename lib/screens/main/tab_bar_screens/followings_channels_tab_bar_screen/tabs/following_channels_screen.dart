import 'package:flutter/material.dart';
import 'package:merume_mobile/utils/colors.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/screens/main/channel_screens/channels_list_widget.dart';
import 'package:merume_mobile/screens/main/tab_bar_screens/followings_channels_tab_bar_screen/followings_channels_controller.dart';
import 'package:merume_mobile/screens/shared/basic/basic_elevated_button_widget.dart';

class FollowingChannelsScreen extends StatefulWidget {
  final FollowingChannelsController controller;

  const FollowingChannelsScreen({super.key, required this.controller});

  @override
  State<FollowingChannelsScreen> createState() =>
      _FollowingChannelsScreenState();
}

class _FollowingChannelsScreenState extends State<FollowingChannelsScreen>
    with AutomaticKeepAliveClientMixin {
  late FollowingChannelsController _controller;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.initController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  stream: widget.controller.channelStream,
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
                        itemBuilder: (_, index) => ChannelsInListWidget(
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
                                color: AppColors.lightGrey,
                                fontFamily: 'Poppins',
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 15),
                            BasicElevatedButtonWidget(
                              onPressed: () {
                                setState(() {
                                  _isButtonPressed = true;
                                });
                                _controller.initController();
                              },
                              buttonText: 'Try Again',
                              isPressed: _isButtonPressed,
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

  @override
  bool get wantKeepAlive => true;
}
