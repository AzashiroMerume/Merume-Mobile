import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merume_mobile/api/channel_api/channel_posts_api.dart';
import 'package:merume_mobile/api/posts_api/create_post_api.dart';
import 'package:merume_mobile/other/colors.dart';
import 'package:merume_mobile/models/author_model.dart';
import 'package:merume_mobile/other/error_custom_snackbar.dart';
import 'package:merume_mobile/screens/main/channel_screens/channel_details_screen.dart';
import 'package:merume_mobile/screens/main/channel_screens/models/post_sent_model.dart';
import 'package:merume_mobile/screens/main/components/enums.dart';
import 'package:merume_mobile/other/exceptions.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/models/post_model.dart';
import 'package:merume_mobile/screens/main/channel_screens/posts_screens/posts_in_list_widget.dart';
import 'package:merume_mobile/user_provider.dart';
import 'package:objectid/objectid.dart';
import 'package:provider/provider.dart';

class ChannelScreen extends StatefulWidget {
  final Channel channel;

  const ChannelScreen({super.key, required this.channel});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  bool isAuthor = false;

  TextEditingController textEditingController = TextEditingController();

  Map<String, List<List<PostSent>>> posts = {};

  final itemsController = StreamController<Map<String, List<List<PostSent>>>>();

  String postBody = '';
  List<String> postImages = [];

  bool isLoading = true;

  String errorMessage = '';

  bool newDate = false;
  DateTime? previousDate;

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
    final Stream<Map<String, List<List<PostSent>>>> webSocketStream =
        fetchChannelPosts(widget.channel.id);
    webSocketStream.listen(
      (Map<String, List<List<PostSent>>> data) {
        data.forEach((date, arrayOfPostArrays) {
          // Update or add new posts
          if (posts.containsKey(date)) {
            // Update existing posts
            for (var existingPostList in posts[date]!) {
              existingPostList.removeWhere((existingPost) =>
                  !arrayOfPostArrays.any((newPostList) => newPostList.any(
                      (newPost) => newPost.post.id == existingPost.post.id)));
            }
            for (var newPostList in arrayOfPostArrays) {
              final existingPostListIndex = posts[date]!.indexWhere(
                  (existingPostList) => existingPostList.any((existingPost) =>
                      newPostList.any((newPost) =>
                          newPost.post.id == existingPost.post.id)));
              if (existingPostListIndex != -1) {
                // Update existing post
                final existingPostList = posts[date]![existingPostListIndex];
                for (var newPost in newPostList) {
                  final existingPostIndex = existingPostList.indexWhere(
                      (existingPost) =>
                          existingPost.post.id == newPost.post.id);
                  if (existingPostIndex != -1) {
                    existingPostList[existingPostIndex] = newPost;
                  } else {
                    existingPostList.add(newPost);
                  }
                }
              } else {
                // Add new post list
                posts[date]!.add(newPostList);
              }
            }
          } else {
            // Add new date entry
            posts[date] = arrayOfPostArrays;
          }
        });

        // Remove deleted posts
        posts.forEach((date, arrayOfPostArrays) {
          arrayOfPostArrays.forEach((postList) {
            postList.removeWhere((postSent) =>
                !data.containsKey(date) ||
                !data[date]!.any((newPostList) => newPostList
                    .any((newPost) => newPost.post.id == postSent.post.id)));
          });
        });

        // Add data to the stream
        if (!itemsController.isClosed) {
          itemsController.add(posts);
        }
      },
      onError: (e) {
        // Handle error states
        if (kDebugMode) {
          print('Error in channel_screen: $e');
        }

        if (e is TokenErrorException) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (Route<dynamic> route) => false,
          );
        } else {
          showCustomSnackBar(
            context,
            message: 'Oops! Something went wrong. Please try again later.',
          );
        }
      },
    );
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
          padding: const EdgeInsets.only(top: 20.0, right: 15.0, left: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: StreamBuilder<Map<String, List<List<PostSent>>>>(
                  stream: itemsController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // Check if posts contains any data
                      if (posts.isNotEmpty) {
                        isLoading = false;
                        return ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (_, index) {
                            final date = posts.keys.elementAt(index);
                            final arrayOfPostLists = posts[date]!;
                            DateTime sentDay = DateTime.parse(date);

                            return Column(
                              children:
                                  arrayOfPostLists.asMap().entries.map((entry) {
                                final int postListIndex = entry.key;
                                final List<PostSent> postList = entry.value;

                                // Determine if this is the first element of the postList
                                final bool shouldShowDate = postListIndex == 0;

                                return PostsInListWidget(
                                  postList: postList,
                                  sentDay: sentDay,
                                  byMe: postList.isNotEmpty &&
                                      userInfo!.id ==
                                          postList.first.post.author.id,
                                  shouldShowDate: shouldShowDate,
                                );
                              }).toList(),
                            );
                          },
                        );
                      } else {
                        // If posts is empty, display the "No posts yet" message
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
                    } else {
                      isLoading = true;
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
                          DateTime now = DateTime.now();
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(now);

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
                            createdAt: now,
                            updatedAt: now,
                          );

                          // Set the status to waiting when a message is sent
                          setState(() {
                            // Check if today's date already exists in posts, if not, create it
                            if (!posts.containsKey(formattedDate)) {
                              posts[formattedDate] = [];
                            }

                            // Add the postSent to today's date entry
                            posts[formattedDate]!.add([
                              PostSent(
                                  post: post, status: MessageStatus.waiting)
                            ]);
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
                              if (posts.containsKey(formattedDate)) {
                                // Iterate over the list of post lists for the date
                                for (final postList in posts[formattedDate]!) {
                                  // Iterate over each `PostSent` object in the post list
                                  for (final postSent in postList) {
                                    // Check if the conditions match for the `PostSent` object
                                    if (postSent.status ==
                                            MessageStatus.waiting &&
                                        postSent.post.id == post.id) {
                                      // Update the status to error
                                      postSent.status = MessageStatus.error;
                                      return; // Exit the function since we found the matching post
                                    }
                                  }
                                }

                                // If the waiting post is not found, add a new error post
                                setState(() {
                                  posts[formattedDate]!.add([
                                    PostSent(
                                        post: post, status: MessageStatus.error)
                                  ]);
                                });
                              } else {
                                // If the date entry doesn't exist, create it and add the error post
                                setState(() {
                                  posts[formattedDate] = [
                                    [
                                      PostSent(
                                          post: post,
                                          status: MessageStatus.error)
                                    ]
                                  ];
                                });
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

                              showCustomSnackBar(
                                context,
                                message:
                                    'Oops! Something went wrong. Please try again later.',
                              );
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
