import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merume_mobile/constants/colors.dart';
import 'package:merume_mobile/providers/select_mode_provider.dart';
import 'package:merume_mobile/screens/main/channel_screens/models/post_sent_model.dart';
import 'package:merume_mobile/constants/enums.dart';
import 'package:merume_mobile/screens/main/channel_screens/posts_screens/components/minimized_pfp_widget.dart';
import 'package:merume_mobile/screens/main/channel_screens/posts_screens/components/message_bubble_widget.dart';
import 'package:provider/provider.dart';

class PostItemWidget extends StatefulWidget {
  final PostSent postSent;
  final bool byMe;
  final bool isFirstMessage;
  final bool isLastMessage;
  final bool listIsNotSingleElement;
  final Function() longPressAction;
  final Function(String) selectPostAction;
  final Function(String) deselectPostAction;

  const PostItemWidget({
    super.key,
    required this.postSent,
    required this.byMe,
    required this.isFirstMessage,
    required this.isLastMessage,
    required this.listIsNotSingleElement,
    required this.longPressAction,
    required this.selectPostAction,
    required this.deselectPostAction,
  });

  @override
  PostItemWidgetState createState() => PostItemWidgetState();
}

class PostItemWidgetState extends State<PostItemWidget> {
  bool isSelected = false;
  late SelectModeProvider selectModeProvider;

  @override
  void initState() {
    super.initState();
    selectModeProvider =
        Provider.of<SelectModeProvider>(context, listen: false);
    selectModeProvider.addListener(handleSelectModeChange);
  }

  @override
  void dispose() {
    selectModeProvider.removeListener(handleSelectModeChange);
    super.dispose();
  }

  void handleSelectModeChange() {
    if (!selectModeProvider.selectModeEnabled && isSelected) {
      setState(() {
        isSelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectModeProvider = Provider.of<SelectModeProvider>(context);

    final timeDateFormat = DateFormat("HH:mm");
    final timeDate =
        timeDateFormat.format(widget.postSent.post.createdAt).toString();

    return GestureDetector(
      onTap: (() {
        if (!isSelected && selectModeProvider.selectModeEnabled) {
          setState(() {
            isSelected = true;
          });
        } else {
          widget.deselectPostAction(widget.postSent.post.id);
          setState(() {
            isSelected = false;
          });
        }
      }),
      onLongPress: () {
        widget.longPressAction();
        widget.selectPostAction(widget.postSent.post.id);
        setState(() {
          isSelected = true;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7.5),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!widget.byMe)
                  Expanded(
                    flex: 1,
                    child: (!widget.byMe && !widget.listIsNotSingleElement) ||
                            (!widget.byMe &&
                                widget.listIsNotSingleElement &&
                                widget.isLastMessage)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildMinimizedPfp(widget.postSent.post, 30),
                              const SizedBox(
                                width: 10.0,
                              ),
                              CustomPaint(
                                painter: MessageBubble(Colors.grey[900]!,
                                    direction: false),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: widget.byMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.royalPurple
                              : AppColors.postMain,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        width: 300.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.isFirstMessage)
                              Text(
                                widget.postSent.post.author.username,
                                style: const TextStyle(
                                  color: AppColors.mellowLemon,
                                  fontSize: 12,
                                ),
                              ),
                            const SizedBox(height: 8.0),
                            Text(
                              widget.postSent.post.body!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'WorkSans',
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Day ${widget.postSent.post.writtenChallengeDay}",
                                  style: const TextStyle(
                                    color: AppColors.lavenderHaze,
                                    fontSize: 13.0,
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                const Text(
                                  "|",
                                  style: TextStyle(
                                    color: AppColors.lavenderHaze,
                                    fontSize: 13.0,
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  timeDate, // Display the formatted date
                                  style: const TextStyle(
                                    color: AppColors.lavenderHaze,
                                    fontSize: 13.0,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                if (widget.postSent.status ==
                                    MessageStatus.error)
                                  const Icon(
                                    Icons.error_outline_outlined,
                                    color: Colors.red,
                                    size: 20.0,
                                  )
                                else if (widget.postSent.status ==
                                    MessageStatus.waiting)
                                  const SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.lavenderHaze,
                                      ),
                                      strokeWidth: 1.0,
                                    ),
                                  )
                                else
                                  const Icon(
                                    Icons.done,
                                    color: AppColors.lavenderHaze,
                                    size: 20.0,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.byMe)
                  Expanded(
                    flex: 1,
                    child: (widget.byMe && !widget.listIsNotSingleElement) ||
                            (widget.byMe &&
                                widget.listIsNotSingleElement &&
                                widget.isLastMessage)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomPaint(
                                painter: MessageBubble(Colors.grey[900]!,
                                    direction: true),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              buildMinimizedPfp(widget.postSent.post, 30),
                            ],
                          )
                        : const SizedBox(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
