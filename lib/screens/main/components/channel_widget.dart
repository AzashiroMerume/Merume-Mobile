import 'package:flutter/material.dart';
import 'package:merume_mobile/api/channel_api/channel_posts_api.dart';
import 'package:merume_mobile/api/posts_api/create_post_api.dart';
import 'package:merume_mobile/colors.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/models/post_model.dart';
import 'package:merume_mobile/screens/main/components/post_in_list_widget.dart';
import 'package:merume_mobile/user_info.dart';
import 'package:provider/provider.dart';

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
                      if (snapshot.data!.isEmpty) {
                        // If there are no posts, display the "No posts yet" message
                        return const Center(
                          child: Text(
                            'No posts yet..',
                            style: TextStyle(
                              color: AppColors.mellowLemon,
                              fontFamily: 'WorkSans',
                              fontSize: 15,
                            ),
                          ),
                        );
                      }

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
                    } else if (snapshot.hasError) {
                      // Handle the error state
                      return const Center(
                        child: Text('There is an error.. Try again later'),
                      );
                    } else {
                      // Display the CircularProgressIndicator centered
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
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
                    try {
                      await createPost(widget.channel.id, postBody, postImages);
                      textEditingController.clear();
                    } catch (e) {
                      print("Error occurred: $e");
                      // Handle the error appropriately
                    }
                  },
                ),
              ],
            ),
          )
        : Container();
  }
}
