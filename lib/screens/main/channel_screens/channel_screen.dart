import 'dart:async';
import 'package:flutter/material.dart';
import 'package:merume_mobile/api/channel_api/channel_posts_api.dart';
import 'package:merume_mobile/api/posts_api/create_post_api.dart';
import 'package:merume_mobile/other/colors.dart';
import 'package:merume_mobile/models/author_model.dart';
import 'package:merume_mobile/other/error_custom_snackbar.dart';
import 'package:merume_mobile/screens/main/channel_screens/channel_details_screen.dart';
import 'package:merume_mobile/screens/main/components/enums.dart';
import 'package:merume_mobile/other/exceptions.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/models/post_model.dart';
import 'package:merume_mobile/screens/main/channel_screens/posts_screens/post_in_list_widget.dart';
import 'package:merume_mobile/user_provider.dart';
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

class ChannelScreen extends StatefulWidget {
  final Channel channel;

  const ChannelScreen({super.key, required this.channel});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  bool isAuthor = false;

  final itemsController = StreamController<List<PostSent>>();

  TextEditingController textEditingController = TextEditingController();

  List<PostSent> posts = [];

  String postBody = '';
  List<String> postImages = [];

  bool isLoading = true;

  String errorMessage = '';

  void _handleAppBarPress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChannelDetailsScreen(
          channel: widget.channel,
        ),
      ),
    );
  }

  @override
  void dispose() {
    itemsController.sink.close();
    itemsController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  void _initializeStream() {
    final Stream<List<Post>> webSocketStream =
        fetchChannelPosts(widget.channel.id);
    webSocketStream.listen((dynamic data) {
      if (data is List<Post>) {
        final List<PostSent> newPosts = data
            .map((post) => PostSent(post: post, status: MessageStatus.done))
            .toList();

        // Create a list of post IDs from the new posts
        final List<String> newPostIds =
            newPosts.map((post) => post.post.id).toList();

        // Remove posts that no longer exist on the server
        posts.removeWhere((postSent) => !newPostIds.contains(postSent.post.id));

        // Update the existing posts list with the new posts
        for (var newPost in newPosts) {
          final existingPostIndex =
              posts.indexWhere((post) => post.post.id == newPost.post.id);
          if (existingPostIndex != -1 && posts[existingPostIndex] != newPost) {
            // If a post with the same ID already exists and newPost is not equal to it, then replace it with the new one
            posts[existingPostIndex] = newPost;
          } else {
            posts.insert(0, newPost);
          }
        }

        if (!itemsController.isClosed) {
          itemsController.add(posts);
        }
      }
    }, onError: (e) {
      if (e is TokenErrorException) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (Route<dynamic> route) => false,
        );
      }
      itemsController.addError(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserProvider>(context, listen: false).userInfo;

    // Check if the user is the author of the channel
    isAuthor = userInfo != null && userInfo.id == widget.channel.author.id;

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
                child: Text(
                  widget.channel.name,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
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
                      isLoading = false;
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
                          bool isSamePost;
                          if (index != 0 &&
                              posts[index].post.createdAt.year ==
                                  posts[index - 1].post.createdAt.year &&
                              posts[index].post.createdAt.month ==
                                  posts[index - 1].post.createdAt.month &&
                              posts[index].post.createdAt.day ==
                                  posts[index - 1].post.createdAt.day) {
                            isSamePost = true;
                          } else {
                            isSamePost = false;
                          }

                          return PostInListWidget(
                            post: posts[index].post,
                            status: posts[index].status,
                            isAuthor: isAuthor,
                            isSamePost: isSamePost,
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      isLoading = false;
                      // Handle the error state
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Oops! Something went wrong.\nPlease try again later.',
                              style: TextStyle(
                                color:
                                    AppColors.lightGrey, // Change color to grey
                                fontFamily: 'Poppins',
                                fontSize: 18, // Increase font size
                              ),
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: () {
                                // Retry action when button is pressed
                                _initializeStream();
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(150, 35),
                                backgroundColor: AppColors.royalPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: const BorderSide(
                                      color:
                                          AppColors.royalPurple // When pressed
                                      ),
                                ),
                              ),
                              child: const Text(
                                'Try Again',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      isLoading = true;
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
                  onPressed: !isLoading ||
                          postBody.isNotEmpty ||
                          postImages.isNotEmpty
                      ? () async {
                          final String postId = ObjectId().hexString;

                          textEditingController.clear();

                          Author author = Author(
                              id: widget.channel.author.id,
                              nickname: widget.channel.author.nickname,
                              username: widget.channel.author.username,
                              isOnline: true);

                          Post post = Post(
                            id: postId,
                            author: author,
                            channelId: widget.channel.id,
                            body: postBody,
                            images: postImages,
                            writtenChallengeDay:
                                widget.channel.currentChallengeDay,
                            likes: 0,
                            dislikes: 0,
                            alreadyChanged: false,
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

                              if (e is TokenErrorException) {
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

                              showCustomSnackBar(context, errorMessage);
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
