import 'package:flutter/material.dart';
import 'package:merume_mobile/constants/colors.dart';
import 'package:merume_mobile/constants/text_styles.dart';
import 'package:merume_mobile/models/channel_model.dart';

class ChannelInfoPopup extends StatefulWidget {
  final Channel channel;
  final VoidCallback? onCancel;

  const ChannelInfoPopup({super.key, required this.channel, this.onCancel});

  @override
  State<ChannelInfoPopup> createState() => _ChannelInfoPopupState();
}

class _ChannelInfoPopupState extends State<ChannelInfoPopup> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onCancel != null
                ? () {
                    widget.onCancel!();
                  }
                : null,
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        AlertDialog(
          alignment: Alignment.center,
          elevation: 50,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              width: 0.5,
            ),
          ),
          backgroundColor: AppColors.royalPurple,
          title: Text(
            widget.channel.name,
            style: TextStyles.hintedText,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Current Day: ${widget.channel.challenge.currentDay}",
                style: TextStyles.body,
              ),
              Text("Current Points: ${widget.channel.challenge.points}")
            ],
          ),
        ),
      ],
    );
  }
}
