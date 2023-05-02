import 'package:flutter/material.dart';

class RecomendationScreen extends StatefulWidget {
  const RecomendationScreen({Key? key});

  @override
  State<RecomendationScreen> createState() => _RecomendationScreenState();
}

class _RecomendationScreenState extends State<RecomendationScreen> {
  Color littleLight = const Color(0xFFF3FFAB);
  Color purpleBeaty = const Color(0xFF8E05C2);

  String currentPressedFilter = 'All';
  List<String> filterOptions = ['All', 'Trending', 'Videos', 'Posts'];
  // ignore: prefer_final_fields
  List<bool> _isSelected = [true, false, false, false];

  void _onFilterButtonPressed(int index) {
    setState(() {
      // Reset all the buttons to unselected
      for (int buttonIndex = 0;
          buttonIndex < _isSelected.length;
          buttonIndex++) {
        _isSelected[buttonIndex] = false;
      }

      // Select the pressed button
      _isSelected[index] = true;

      // Update the current pressed filter
      currentPressedFilter = filterOptions[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> filterButtons = [];

    for (int i = 0; i < filterOptions.length; i++) {
      filterButtons.add(Padding(
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
      ));
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 22.0, bottom: 0.0, right: 30.0, left: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: filterButtons,
                ),
              ),
              // Expanded(
              //   child: SingleChildScrollView(
              //     child: /* Your content goes here */,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
