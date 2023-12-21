import 'dart:async';
import 'package:flutter/material.dart';
import 'package:merume_mobile/other/colors.dart';
import 'package:merume_mobile/other/exceptions.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/api/user_api/recommendations_api/recommendations_api.dart';
import 'package:merume_mobile/screens/main/channel_screens/channel_in_list_widget.dart';
import 'package:merume_mobile/screens/settings/preferences_screen.dart';

class RecommendationScreen extends StatefulWidget {
  final List<String>? preferences;

  const RecommendationScreen({super.key, required this.preferences});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  String currentPressedFilter = 'All';
  List<String> filterOptions = ['All', 'Trending'];
  final List<bool> _isSelected = [true, false];

  final ScrollController _scrollController = ScrollController();
  List<Channel>? recommendations;
  int pageNumber = 0;

  String errorMessage = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.preferences != null && widget.preferences!.isNotEmpty) {
      _scrollController.addListener(_scrollListener);
      initRecommendations();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onFilterButtonPressed(int index) {
    setState(() {
      for (int buttonIndex = 0;
          buttonIndex < _isSelected.length;
          buttonIndex++) {
        _isSelected[buttonIndex] = false;
      }
      _isSelected[index] = true;
      currentPressedFilter = filterOptions[index];
    });
  }

  Future<void> initRecommendations() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });

      _scrollController.removeListener(_scrollListener);
      try {
        final response = await fetchRecommendations(pageNumber);

        if (mounted) {
          setState(() {
            recommendations = response;
            isLoading = false;
          });
          _scrollController.addListener(_scrollListener);
        }
      } catch (e) {
        setState(() {
          isLoading = false;
          if (e is AuthenticationException) {
            errorMessage = 'Token authentication error. Please try to relogin.';
          } else if (e is NetworkException) {
            errorMessage = 'Network error occurred.';
          } else if (e is TimeoutException) {
            errorMessage = 'Slow internet connection.';
          } else if (e is HttpException) {
            errorMessage =
                'There was an error on the server side. Please try again later.';
          }
        });
      }
    }
  }

  Future<void> loadMoreRecommendations() async {
    pageNumber++; // Increment the page number for fetching new content

    final response = await fetchRecommendations(pageNumber);
    setState(() {
      recommendations?.addAll(response);
    });
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      loadMoreRecommendations();
    }
  }

  Future<void> refreshRecommendations() async {
    pageNumber = 0; // Reset the page number when refreshing
    final response = await fetchRecommendations(pageNumber);
    setState(() {
      recommendations = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> filterButtons = [];

    for (int i = 0; i < filterOptions.length; i++) {
      filterButtons.add(
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: ElevatedButton(
            onPressed: () => _onFilterButtonPressed(i),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(110, 35),
              backgroundColor:
                  _isSelected[i] ? AppColors.mellowLemon : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: _isSelected[i]
                      ? AppColors.mellowLemon
                      : AppColors.royalPurple,
                  width: 1,
                ),
              ),
            ),
            child: Text(
              filterOptions[i],
              style: TextStyle(
                fontFamily: 'WorkSans',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: _isSelected[i] ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 20.0, bottom: 0.0, right: 20.0, left: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.preferences == null || widget.preferences!.isEmpty)
                Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Please choose the preferences first",
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: AppColors.mellowLemon,
                          ),
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PreferencesScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.royalPurple,
                          ),
                          child: const Text(
                            'Select',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'WorkSans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                  ],
                ),
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: filterButtons,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: refreshRecommendations,
                  displacement: 1,
                  color: Colors.white,
                  backgroundColor: AppColors.royalPurple,
                  child: recommendations == null || recommendations!.isEmpty
                      ? Center(
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  errorMessage.isNotEmpty
                                      ? errorMessage
                                      : "No content yet",
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: errorMessage.isNotEmpty
                                        ? Colors
                                            .red // Show error message in red
                                        : AppColors.mellowLemon,
                                  ),
                                ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: recommendations!.length,
                          itemBuilder: (context, index) {
                            final channel = recommendations![index];
                            return ChannelInListWidget(channel: channel);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
