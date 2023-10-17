import 'dart:async';
import 'package:flutter/material.dart';
import 'package:merume_mobile/api/channel_api/channel_posts_api.dart';
import 'package:merume_mobile/api/posts_api/create_post_api.dart';
import 'package:merume_mobile/colors.dart';
import 'package:merume_mobile/enums.dart';
import 'package:merume_mobile/exceptions.dart';
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
  bool isAuthor = false;

  final itemsController = StreamController<List<PostSent>>();

  TextEditingController textEditingController = TextEditingController();

  List<PostSent> posts = [];
  // Key keyToRebuild = UniqueKey();

  String postBody = '';
  List<String> postImages = [];

  String errorMessage = '';

  void showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorMessage,
          style: const TextStyle(
            fontFamily: 'WorkSans',
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        duration: const Duration(seconds: 10),
        backgroundColor: Colors.red,
      ),
    );
  }

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
        final List<PostSent> newPosts = data
            .map((post) => PostSent(post: post, status: MessageStatus.done))
            .toList();

        // Update the existing posts list with the new posts
        for (var newPost in newPosts) {
          final existingPostIndex =
              posts.indexWhere((post) => post.post.id == newPost.post.id);
          if (existingPostIndex != -1) {
            // If a post with the same ID already exists, replace it with the new one
            posts[existingPostIndex] = newPost;
          } else {
            posts.insert(0, newPost);
          }
        }

        if (!itemsController.isClosed) {
          itemsController.add(posts);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfo =
        Provider.of<UserInfoProvider>(context, listen: false).userInfo;

    // Check if the user is the author of the channel
    isAuthor = userInfo != null && userInfo.id == widget.channel.ownerId;

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

                      // Sort allPosts by createdAt in ascending order (oldest to newest)
                      posts.sort((a, b) =>
                          a.post.createdAt.compareTo(b.post.createdAt));

                      return ListView.builder(
                        // key: keyToRebuild,
                        itemCount: posts.length,
                        itemBuilder: (_, index) {
                          return PostInListWidget(
                            post: posts[index].post,
                            status: posts[index].status,
                            isAuthor: isAuthor,
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
                      setState(() {
                        postBody = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: AppColors.mellowLemon,
                  ),
                  onPressed: postBody.isNotEmpty || postImages.isNotEmpty
                      ? () async {
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
                          setState(() {
                            posts.add(PostSent(
                                post: post, status: MessageStatus.waiting));
                          });

                          final tempPostBody = postBody;
                          final tempPostImages = postImages;

                          // Clear postBody and postImages after sending the message
                          setState(() {
                            postBody = '';
                            postImages.clear();
                          });

                          try {
                            await createPost(widget.channel.id, postId,
                                tempPostBody, tempPostImages);
                          } catch (e) {
                            setState(() {
                              // Find the waiting post and update its status to "error"
                              final waitingPostIndex = posts.indexWhere(
                                (element) =>
                                    element.status == MessageStatus.waiting &&
                                    element.post.id == post.id,
                              );
                              if (waitingPostIndex != -1) {
                                posts[waitingPostIndex].status =
                                    MessageStatus.error;
                              } else {
                                // If waiting post not found, add a new error post
                                posts.add(PostSent(
                                    post: post, status: MessageStatus.error));
                              }

                              if (e is TokenAuthException) {
                                errorMessage =
                                    'Token authentication error. Please try to relogin.';
                              } else if (e is NotFoundException) {
                                errorMessage =
                                    'Channel not found. Please try again later.';
                              } else if (e is PostAuthorConflictException) {
                                errorMessage =
                                    'You have no rights to post here.';
                              } else if (e is UnprocessableEntityException) {
                                errorMessage =
                                    'Invalid input data. Please follow the requirements.';
                              } else if (e is ServerException ||
                                  e is HttpException) {
                                errorMessage =
                                    'There was an error on the server side. Please try again later.';
                              } else if (e is NetworkException) {
                                errorMessage =
                                    'A network error has occurred. Please check your internet connection.';
                              } else if (e is TimeoutException) {
                                errorMessage =
                                    'Network connection is poor. Please try again later.';
                              }

                              showErrorSnackBar(errorMessage);
                            });
                          }
                        }
                      : null, // Disable the button when conditions are not met
                ),
              ],
            ),
          )
        : Container();
  }
}
