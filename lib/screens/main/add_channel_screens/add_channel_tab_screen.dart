import 'package:flutter/material.dart';
import 'package:merume_mobile/screens/components/step_indicator_widget.dart';
import 'package:merume_mobile/screens/main/add_channel_screens/tabs/add_channel_screen_1.dart';
import 'package:merume_mobile/screens/main/add_channel_screens/tabs/add_channel_screen_2.dart';
import 'package:merume_mobile/screens/main/components/enums.dart';

class AddChannelTabScreen extends StatefulWidget {
  const AddChannelTabScreen({super.key});

  @override
  State<AddChannelTabScreen> createState() => _AddChannelTabScreenState();
}

class _AddChannelTabScreenState extends State<AddChannelTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentStep = 0; // Track the current step
  ChannelType? _selectedItem;

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
      currentStep = step;
      if (currentStep == 1) {
        _tabController.animateTo(1); // Switch to the second tab
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
              coloredStep: currentStep,
              totalSteps: 2,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: currentStep > 1
                    ? null
                    : const NeverScrollableScrollPhysics(),
                children: [
                  AddChannelScreenFirst(
                    onComplete: () {
                      _updateStep(1); // Move to the next step
                    },
                    onItemSelected: (selectedItem) {
                      // Update the selected item in AddChannelTabScreen when it changes
                      setState(() {
                        // Store the selected item in AddChannelTabScreen
                        _selectedItem = selectedItem;
                      });
                    },
                    initialSelectedItem: _selectedItem,
                  ),
                  AddChannelScreenSecond(
                    onComplete: (step) {
                      _updateStep(step); // Move to the next step
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
