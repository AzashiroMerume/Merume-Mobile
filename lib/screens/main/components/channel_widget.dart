import 'dart:async';
import 'package:flutter/material.dart';
import 'package:merume_mobile/api/channel_api/channel_posts_api.dart';
import 'package:merume_mobile/api/posts_api/create_post_api.dart';
import 'package:merume_mobile/colors.dart';
import 'package:merume_mobile/enums.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/models/post_model.dart';
import 'package:merume_mobile/screens/main/components/post_in_list_widget.dart';
import 'package:merume_mobile/user_info.dart';
import 'package:objectid/objectid.dart';
import 'package:provider/provider.dart';

class PostSent {
  final Post post;
  MessageStatus status;

  PostSent({
    required this.post,
    required this.status,
  });
}

class ChannelWidget extends StatefulWidget {
  final Channel channel;

  const ChannelWidget({Key? key, required this.channel}) : super(key: key);

  @override
  State<ChannelWidget> createState() => _ChannelWidgetState();
}

class _ChannelWidgetState extends State<ChannelWidget> {
  final itemsController = StreamController<List<PostSent>>();

  TextEditingController textEditingController = TextEditingController();

  List<PostSent> posts = [];
  // Key keyToRebuild = UniqueKey();

  String postBody = '';
  List<String> postImages = [];

  void _handleAppBarPress() {
    print("Hello, world!");
  }

  @override
  void dispose() {
    itemsController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final webSocketStream = fetchChannelPosts(widget.channel.id);
    webSocketStream.listen((dynamic data) {
      if (data is List<Post>) {
        // Handle WebSocket data
        posts = [
          ...data
              .map((post) => PostSent(post: post, status: MessageStatus.done)),
          ...posts,
        ];
      }
      // setState(() {
      //   keyToRebuild = UniqueKey();
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: GestureDetector(
          onTap: _handleAppBarPress,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.lavenderHaze.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
            ),
            child: AppBar(
              title: Container(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(widget.channel.name),
              ),
              automaticallyImplyLeading: false,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 30.0, left: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: StreamBuilder<List<PostSent>>(
                  stream: itemsController.stream,
                  builder: (context, snapshot) {
                    final allPosts = [...posts, ...(snapshot.data ?? [])];
                    return ListView.builder(
                      // key: keyToRebuild,
                      itemCount: allPosts.length,
                      itemBuilder: (_, index) {
                        return PostInListWidget(
                          post: allPosts[index].post,
                          status: allPosts[index].status,
                        );
                      },
                    );
                  },
                ),
              ),
              _buildChatInputBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatInputBox() {
    final userInfo =
        Provider.of<UserInfoProvider>(context, listen: false).userInfo;

    // Check if the user is the author of the channel
    final isAuthor = userInfo != null && userInfo.id == widget.channel.ownerId;

    // Render the input box only if the user is the author
    return isAuthor
        ? Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.lavenderHaze.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Share progress...',
                      hintStyle: TextStyle(color: AppColors.mellowLemon),
                    ),
                    style: const TextStyle(color: AppColors.lavenderHaze),
                    onChanged: (value) {
                      postBody = value;
                      // Add postImages/Files
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: AppColors.mellowLemon,
                  ),
                  onPressed: () async {
                    final String postId = ObjectId().hexString;

                    textEditingController.clear();
                    Post post = Post(
                      id: postId,
                      ownerId: widget.channel.ownerId,
                      ownerNickname: widget.channel.ownerNickname,
                      channelId: widget.channel.id,
                      body: postBody,
                      images: postImages,
                      writtenChallengeDay: 0,
                      likes: 0,
                      dislikes: 0,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );

                    // Set the status to waiting when a message is sent
                    itemsController.add(
                        [PostSent(post: post, status: MessageStatus.waiting)]);

                    try {
                      await createPost(
                          widget.channel.id, postId, postBody, postImages);

                      itemsController.add(
                          [PostSent(post: post, status: MessageStatus.done)]);
                    } catch (e) {
                      itemsController.add(
                          [PostSent(post: post, status: MessageStatus.error)]);
                    }
                  },
                ),
              ],
            ),
          )
        : Container();
  }
}
