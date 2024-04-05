import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:merume_mobile/api/users_api/get_user_channels_api.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/models/user_model.dart';
import 'package:merume_mobile/constants/colors.dart';
import 'package:merume_mobile/constants/exceptions.dart';
import 'package:merume_mobile/utils/image_loading.dart';
import 'package:merume_mobile/utils/last_time_online.dart';
import 'package:merume_mobile/screens/main/components/channel_card_widget.dart';
import 'package:merume_mobile/utils/navigate_to_login.dart';

class OtherUserScreen extends StatefulWidget {
  final User user;

  const OtherUserScreen({super.key, required this.user});

  @override
  State<OtherUserScreen> createState() => _OtherUserScreenState();
}

class _OtherUserScreenState extends State<OtherUserScreen> {
  List<Channel>? userChannels;
  late Timer _timer;

  @override
  void initState() {
    try {
      super.initState();
      fetchUserChannels();
      _startTimer();
    } catch (e) {
      if (e is TokenErrorException) {
        navigateToLogin(context);
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) async {
      await fetchUserChannels();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchUserChannels() async {
    try {
      List<Channel>? channels =
          await getUserChannels(widget.user.id.toString());
      if (mounted) {
        setState(() {
          userChannels = channels;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in other_user_screen: $e');
      }

      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user.nickname,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            CircleAvatar(
              radius: 80.0,
              child: ClipOval(
                child: buildImage(
                    widget.user.pfpLink, 'assets/images/pfp_outline.png',
                    height: 160.0, width: 160.0),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              widget.user.username,
              style: const TextStyle(
                fontSize: 24.0,
                color: AppColors.mellowLemon,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              '@${widget.user.nickname}',
              style: const TextStyle(
                fontSize: 18.0,
                color: AppColors.lightGrey,
              ),
            ),
            const SizedBox(height: 5.0),
            if (widget.user.isOnline)
              const Text(
                'Online',
                style: TextStyle(fontSize: 16.0, color: Colors.green),
              )
            else
              Text(
                formatLastSeen(widget.user.lastTimeOnline),
                style: const TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            const SizedBox(height: 20.0),
            if (userChannels != null)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userChannels!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ChannelCard(channel: userChannels![index]);
                    },
                  ),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
