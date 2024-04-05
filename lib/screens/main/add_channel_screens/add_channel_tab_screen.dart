import 'package:flutter/material.dart';
import 'package:merume_mobile/constants/enums.dart';
import 'package:merume_mobile/screens/shared/step_indicator_widget.dart';
import 'package:merume_mobile/screens/main/add_channel_screens/tabs/add_channel_screen_1.dart';
import 'package:merume_mobile/screens/main/add_channel_screens/tabs/add_channel_screen_2.dart';

class AddChannelTabScreen extends StatefulWidget {
  const AddChannelTabScreen({super.key});

  @override
  State<AddChannelTabScreen> createState() => _AddChannelTabScreenState();
}

class _AddChannelTabScreenState extends State<AddChannelTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int colorStep = 0;
  ChallengeTypes? _selectedItem;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateStep(int step) {
    setState(() {
      colorStep = step;
      if (colorStep == 1) {
        _tabController.animateTo(1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 24.0,
            ),
            StepIndicator(
              coloredStep: colorStep,
              totalSteps: 2,
            ),
            const SizedBox(
              height: 24.0,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: _tabController.index > 0
                    ? null
                    : const NeverScrollableScrollPhysics(),
                children: [
                  AddChannelScreenFirst(
                    onComplete: () {
                      _updateStep(1);
                    },
                    onItemSelected: (selectedItem) {
                      setState(() {
                        _selectedItem = selectedItem;
                      });
                    },
                    initialSelectedItem: _selectedItem,
                  ),
                  AddChannelScreenSecond(
                    selectedChallengeType: _selectedItem,
                    onComplete: (step) {
                      _updateStep(step);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
