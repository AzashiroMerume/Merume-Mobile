import 'package:flutter/material.dart';
import '../../../api/recommendations_api.dart';
import '../../../models/channel_model.dart';
import '../../../models/post_model.dart';
import '../components/post_widget.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({Key? key}) : super(key: key);

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  Color littleLight = const Color(0xFFF3FFAB);
  Color purpleBeaty = const Color(0xFF8E05C2);

  String currentPressedFilter = 'All';
  List<String> filterOptions = ['All', 'Trending'];
  final List<bool> _isSelected = [true, false];

  final ScrollController _scrollController = ScrollController();
  Map<Channel, Post>? recommendations;
  int pageNumber = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    initRecommendations();
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
    final response = await fetchRecommendations(pageNumber);
    setState(() {
      recommendations = response;
    });
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
              fixedSize: const Size(100, 35),
              backgroundColor: _isSelected[i] ? littleLight : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: _isSelected[i] ? littleLight : purpleBeaty,
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
              top: 20.0, bottom: 0.0, right: 30.0, left: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                  backgroundColor: purpleBeaty,
                  child: recommendations == null || recommendations!.isEmpty
                      ? Center(
                          child: Text(
                            "No content yet",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: littleLight,
                            ),
                          ),
                        )
                      : ListView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            for (var entry in recommendations!.entries)
                              PostWidget(channel: entry.key, post: entry.value),
                          ],
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
