import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merume_mobile/api/channel_api/channel_posts_api.dart';
import 'package:merume_mobile/api/posts_api/create_post_api.dart';
import 'package:merume_mobile/local_db/repositories/channel_last_scroll_position_repository.dart';
import 'package:merume_mobile/models/user_model.dart';
import 'package:merume_mobile/providers/error_provider.dart';
import 'package:merume_mobile/providers/select_mode_provider.dart';
import 'package:merume_mobile/screens/main/channel_screens/components/channel_info_popup.dart';
import 'package:merume_mobile/screens/shared/error_consumer_display_widget.dart';
import 'package:merume_mobile/constants/colors.dart';
import 'package:merume_mobile/models/author_model.dart';
import 'package:merume_mobile/utils/error_custom_snackbar.dart';
import 'package:merume_mobile/screens/main/channel_screens/channel_details_screen.dart';
import 'package:merume_mobile/screens/main/channel_screens/components/post_day_formation_widget.dart';
import 'package:merume_mobile/screens/main/channel_screens/models/post_sent_model.dart';
import 'package:merume_mobile/constants/enums.dart';
import 'package:merume_mobile/constants/exceptions.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/models/post_model.dart';
import 'package:merume_mobile/screens/main/channel_screens/posts_screens/posts_list_widget.dart';
import 'package:merume_mobile/providers/user_provider.dart';
import 'package:merume_mobile/utils/navigate_to_login.dart';
import 'package:merume_mobile/utils/observer_utils.dart';
import 'package:objectid/objectid.dart';
import 'package:provider/provider.dart';

class ChannelScreen extends StatefulWidget {
  final Channel channel;

  const ChannelScreen({super.key, required this.channel});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> with RouteAware {
  late ScrollController _scrollController;
  late TextEditingController _textEditingController;
  late SelectModeProvider _selectModeProvider;

  bool _showPostInteractionAppBar = false;
  Set<String> selectedPosts = {};

  late User? userInfo;
  bool isAuthor = false;

  Map<String, List<List<PostSent>>> posts = {};
  final itemsController = StreamController<Map<String, List<List<PostSent>>>>();

  String postBody = '';
  List<String>? postImages;

  bool isLoading = true;

  bool displayChallengeInfo = false;

  late ErrorProvider errorProvider;
  String errorMessage = '';
  Timer? _retryTimer;
  static const int _retryDelaySeconds = 10;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();

    userInfo = Provider.of<UserProvider>(context, listen: false).userInfo;
    errorProvider = Provider.of<ErrorProvider>(context, listen: false);
    _selectModeProvider = SelectModeProvider();

    isAuthor = userInfo != null && userInfo?.id == widget.channel.author.id;

    _initializeStream();
  }

  @override
  void dispose() {
    itemsController.sink.close();
    itemsController.close();
    _retryTimer?.cancel();
    _scrollController.dispose();
    ObserverUtils.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    ObserverUtils.routeObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void didPop() {
    if (_scrollController.hasClients) {
      _saveLastScrollPosition(_scrollController.position.pixels);
    }
    errorProvider.clearError();
    super.didPop();
  }

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

  void _saveLastScrollPosition(double currentPosition) async {
    ChannelLastScrollPositionRepository.writePosition(
        widget.channel.id, currentPosition);
  }

  void _moveToLastScrollPosition() async {
    final savedPosition =
        ChannelLastScrollPositionRepository.readPosition(widget.channel.id);
    if (_scrollController.hasClients) {
      if (savedPosition != null && !savedPosition.isNegative) {
        _scrollController.jumpTo(savedPosition);
      } else {
        // check, can throw error
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    }
  }

  void _scrollToNewPost() {
    if (_scrollController.hasClients) {
      final double position = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _initializeStream() {
    final Stream<Map<String, List<List<PostSent>>>> webSocketStream =
        fetchChannelPosts(widget.channel.id);
    webSocketStream.listen(
      (Map<String, List<List<PostSent>>> data) {
        if (errorProvider.showError) {
          errorProvider.clearError();
        }

        _transformReceivedData(data);

        if (!itemsController.isClosed) {
          itemsController.add(posts);
        }
      },
      onError: (e) {
        if (e is TokenErrorException) {
          navigateToLogin(context);
        }

        errorProvider.setError(_retryDelaySeconds);

        _retryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (errorProvider.retrySeconds > 0) {
            errorProvider.decreaseRetrySeconds();
          } else {
            _retryTimer?.cancel();
            if (!itemsController.isClosed) {
              _initializeStream();
            }
          }
        });
      },
    );
  }

  void _transformReceivedData(Map<String, List<List<PostSent>>> data) {
    data.forEach((date, arrayOfPostArrays) {
      if (posts.containsKey(date)) {
        // Update existing posts or add new ones
        for (var newPostList in arrayOfPostArrays) {
          final existingPostList = posts[date]!;
          for (var newPost in newPostList) {
            // Find if the new post exists in the existing list
            final existingPostIndex = existingPostList.indexWhere(
                (existingPostSentList) => existingPostSentList.any(
                    (existingPost) => existingPost.post.id == newPost.post.id));
            if (existingPostIndex != -1) {
              // Update existing post
              final existingPostListToUpdate =
                  existingPostList[existingPostIndex];
              final existingPostToUpdateIndex =
                  existingPostListToUpdate.indexWhere((existingPost) =>
                      existingPost.post.id == newPost.post.id);
              if (existingPostToUpdateIndex != -1) {
                existingPostListToUpdate[existingPostToUpdateIndex] = newPost;
              } else {
                existingPostListToUpdate.add(newPost);
              }
            } else {
              // Add new post
              existingPostList.add([newPost]);
            }
          }
        }
      } else {
        posts[date] = arrayOfPostArrays;
      }
    });

    posts.forEach((date, arrayOfPostArrays) {
      for (var postList in arrayOfPostArrays) {
        postList.removeWhere((postSent) =>
            !data.containsKey(date) ||
            !data[date]!.any((newPostList) => newPostList
                .any((newPost) => newPost.post.id == postSent.post.id)));
      }
    });
  }

  AppBar _buildDefaultAppBar() {
    return AppBar(
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
    );
  }

  AppBar _buildPostInteractionAppBar() {
    return AppBar(
      title: Container(
        padding: const EdgeInsets.only(left: 20.0),
        child: const Text(
          "Action",
          style: TextStyle(color: Colors.white),
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _showPostInteractionAppBar = false;
            });
            _selectModeProvider.setSelectMode(false);
            selectedPosts.clear();
          },
          child: const Text(
            "CANCEL",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _longPressAction() {
    setState(() {
      _showPostInteractionAppBar = true;
    });
  }

  void _selectPostAction(String postId) {
    if (!_selectModeProvider.selectModeEnabled) {
      _selectModeProvider.setSelectMode(true);
    }
    selectedPosts.add(postId);
  }

  void _deselectPostAction(String postId) {
    selectedPosts.remove(postId);
    if (selectedPosts.isEmpty) {
      setState(() {
        _showPostInteractionAppBar = false;
      });
      _selectModeProvider.setSelectMode(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _selectModeProvider,
      child: Scaffold(
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
              child: _showPostInteractionAppBar
                  ? _buildPostInteractionAppBar()
                  : _buildDefaultAppBar(),
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, right: 15.0, left: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: StreamBuilder<Map<String, List<List<PostSent>>>>(
                        stream: itemsController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _moveToLastScrollPosition();
                            });

                            isLoading = false;
                            if (posts.isNotEmpty) {
                              return GestureDetector(
                                onHorizontalDragEnd: (DragEndDetails details) {
                                  if (details.primaryVelocity != null &&
                                      details.primaryVelocity! > 0) {
                                    setState(() {
                                      displayChallengeInfo = true;
                                    });
                                  }
                                },
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: posts.length,
                                  itemBuilder: (_, index) {
                                    final date = posts.keys.elementAt(index);
                                    final arrayOfPostLists = posts[date]!;
                                    DateTime sentDay = DateTime.parse(date);

                                    // Check if there are any remaining posts for this date
                                    final bool hasPostsForDate =
                                        arrayOfPostLists.any(
                                            (postList) => postList.isNotEmpty);

                                    // Only show the date if there are remaining posts for this date
                                    if (hasPostsForDate) {
                                      return Column(
                                        children: [
                                          Column(
                                            children: [
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 5.0),
                                                decoration: BoxDecoration(
                                                  color: AppColors.postMain,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Text(
                                                  formatPostDate(sentDay),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                            ],
                                          ),
                                          ...arrayOfPostLists
                                              .asMap()
                                              .entries
                                              .map(
                                                (entry) => PostsListWidget(
                                                  postList: entry.value,
                                                  sentDay: sentDay,
                                                  byMe:
                                                      entry.value.isNotEmpty &&
                                                          userInfo!.id ==
                                                              entry
                                                                  .value
                                                                  .first
                                                                  .post
                                                                  .author
                                                                  .id,
                                                  longPressAction:
                                                      _longPressAction,
                                                  selectPostAction:
                                                      _selectPostAction,
                                                  deselectPostAction:
                                                      _deselectPostAction,
                                                ),
                                              ),
                                        ],
                                      );
                                    } else {
                                      // If there are no remaining posts for this date, don't display the date
                                      return Column(
                                        children: [
                                          ...arrayOfPostLists
                                              .asMap()
                                              .entries
                                              .map(
                                                (entry) => PostsListWidget(
                                                  postList: entry.value,
                                                  sentDay: sentDay,
                                                  byMe:
                                                      entry.value.isNotEmpty &&
                                                          userInfo!.id ==
                                                              entry
                                                                  .value
                                                                  .first
                                                                  .post
                                                                  .author
                                                                  .id,
                                                  longPressAction:
                                                      _longPressAction,
                                                  selectPostAction:
                                                      _selectPostAction,
                                                  deselectPostAction:
                                                      _deselectPostAction,
                                                ),
                                              ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              );
                            } else {
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
              const ErrorConsumerDisplay(),
              if (displayChallengeInfo)
                ChannelInfoPopup(
                  channel: widget.channel,
                  onCancel: () => {
                    setState(() {
                      displayChallengeInfo = false;
                    })
                  },
                )

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 10.0, vertical: 5.0),
              //       decoration: BoxDecoration(
              //         color: AppColors.postMain,
              //         borderRadius: BorderRadius.circular(8.0),
              //       ),
              //       child: const Text(
              //         /*  formatPostDate(sentDay) */ 'dude',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 12,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
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
                    controller: _textEditingController,
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
                  onPressed: (!isLoading &&
                          (postBody.isNotEmpty || postImages != null))
                      ? () async {
                          // Check if the message body is not empty
                          if (postBody.isNotEmpty) {
                            final String postId = ObjectId().hexString;
                            DateTime now = DateTime.now();
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(now);

                            _textEditingController.clear();

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
                                  widget.channel.challenge.currentDay,
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

                              // Check if there are existing posts for today
                              if (posts[formattedDate]!.isNotEmpty) {
                                final lastPostList = posts[formattedDate]!.last;
                                final lastPost = lastPostList.last;
                                final timeDifference =
                                    now.difference(lastPost.post.createdAt);
                                if (timeDifference.inMinutes <= 5) {
                                  // Add the new post to the last list if within 5 minutes
                                  lastPostList.add(
                                    PostSent(
                                        post: post,
                                        status: MessageStatus.waiting),
                                  );
                                  return; // Exit the function since post is added
                                }
                              }

                              // Create a new list and add the new post if not within 5 minutes
                              posts[formattedDate]!.add([
                                PostSent(
                                    post: post, status: MessageStatus.waiting),
                              ]);
                            });

                            _scrollToNewPost();

                            final tempPostBody = postBody;
                            final tempPostImages = postImages;

                            // Clear postBody and postImages after sending the message
                            setState(() {
                              postBody = '';
                              postImages = null;
                            });

                            try {
                              await createPost(widget.channel.id, postId,
                                  tempPostBody, tempPostImages);
                            } catch (e) {
                              setState(() {
                                if (posts.containsKey(formattedDate)) {
                                  // Iterate over the list of post lists for the date
                                  for (final postList
                                      in posts[formattedDate]!) {
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
                                          post: post,
                                          status: MessageStatus.error)
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
                        }
                      : null, // Disable the button when conditions are not met
                ),
              ],
            ),
          )
        : Container();
  }
}
