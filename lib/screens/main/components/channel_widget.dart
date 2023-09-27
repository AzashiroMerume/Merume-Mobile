import 'package:flutter/material.dart';
import 'package:merume_mobile/api/channel_api/channel_posts_api.dart';
import 'package:merume_mobile/api/posts_api/create_post_api.dart';
import 'package:merume_mobile/colors.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/models/post_model.dart';
import 'package:merume_mobile/screens/main/components/post_in_list_widget.dart';

class PostSent {
  final Post post;
  bool isError = false;

  PostSent({
    required this.post,
    required this.isError,
  });
}

class ChannelWidget extends StatefulWidget {
  final Channel channel;

  const ChannelWidget({Key? key, required this.channel}) : super(key: key);

  @override
  State<ChannelWidget> createState() => _ChannelWidgetState();
}

class _ChannelWidgetState extends State<ChannelWidget> {
  TextEditingController textEditingController = TextEditingController();

  List<PostSent> posts = [];
  List<PostSent> errorPosts = [];

  String postBody = '';
  List<String> postImages = [];

  void _handleAppBarPress() {
    print("Hello, world!");
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
                child: StreamBuilder<List<Post>>(
                  stream: fetchChannelPosts(widget.channel.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // Combine regular posts and error posts into a single list
                      List<PostSent> allPosts = [
                        ...snapshot.data!.map(
                            (post) => PostSent(post: post, isError: false)),
                        ...errorPosts,
                      ];

                      // Sort allPosts by createdAt in ascending order (oldest to newest)
                      allPosts.sort((a, b) =>
                          a.post.createdAt.compareTo(b.post.createdAt));

                      return ListView.builder(
                        itemCount: allPosts.length,
                        itemBuilder: (_, index) {
                          // Display posts (both regular and error posts) sorted by createdAt
                          return PostInListWidget(
                            post: allPosts[index].post,
                            isError: allPosts[index].isError,
                          );
                        },
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
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
    return Container(
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
              try {
                await createPost(widget.channel.id, postBody, postImages);
                textEditingController.clear();
              } catch (e) {
                print("Error occurred: $e");

                // Create a new post to add to the errorPosts list
                Post errorPost = Post(
                  id: '0',
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

                // Add the error post to the errorPosts list
                setState(() {
                  print("Error happened");
                  errorPosts.add(PostSent(post: errorPost, isError: true));
                });

                textEditingController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
