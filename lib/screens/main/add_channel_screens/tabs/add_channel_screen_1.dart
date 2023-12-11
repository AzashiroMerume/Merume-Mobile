import 'package:flutter/material.dart';
import 'package:merume_mobile/other/colors.dart';
import 'package:merume_mobile/screens/main/components/enums.dart';

class AddChannelScreenFirst extends StatefulWidget {
  final VoidCallback onComplete;
  final Function(ChannelType?) onItemSelected;
  final ChannelType? initialSelectedItem;

  const AddChannelScreenFirst({
    super.key,
    required this.onComplete,
    required this.onItemSelected,
    required this.initialSelectedItem,
  });

  @override
  State<AddChannelScreenFirst> createState() => _AddChannelScreenFirstState();
}

class _AddChannelScreenFirstState extends State<AddChannelScreenFirst> {
  ChannelType? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.initialSelectedItem;
  }

  void selectItem(ChannelType item) {
    setState(() {
      selectedItem = item;
    });
    widget.onItemSelected(selectedItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select a channel type",
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  color: AppColors.mellowLemon,
                ),
              ),
              const SizedBox(height: 32.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      selectItem(ChannelType.fixed);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: selectedItem == ChannelType.fixed
                            ? AppColors.royalPurple
                            : Colors.transparent,
                        border: Border.all(
                          color: selectedItem == ChannelType.fixed
                              ? AppColors.royalPurple
                              : Colors.transparent,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Fixed day challenge",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Poppins",
                              color: selectedItem == ChannelType.fixed
                                  ? Colors.white
                                  : AppColors.royalPurple,
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          const Text(
                            "Create a dedicated space for continuous improvement in your chosen field. Set your channel duration for an extended period, allowing members to commit to ongoing growth and progress over 1000 days or more. Share, learn, and evolve together in this focused and dedicated environment.",
                            style: TextStyle(
                              fontFamily: "WorkSans",
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: AppColors.royalPurple,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      selectItem(ChannelType.unfixed);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: selectedItem == ChannelType.unfixed
                            ? AppColors.royalPurple
                            : Colors.transparent,
                        border: Border.all(
                          color: selectedItem == ChannelType.unfixed
                              ? AppColors.royalPurple
                              : Colors.transparent,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Unfixed day challenge",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Poppins",
                              color: selectedItem == ChannelType.unfixed
                                  ? Colors.white
                                  : AppColors.royalPurple,
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          const Text(
                            "Create a dedicated space for continuous improvement in your chosen field. Set your channel duration for an extended period, allowing members to commit to ongoing growth and progress over 1000 days or more. Share, learn, and evolve together in this focused and dedicated environment.",
                            style: TextStyle(
                              fontFamily: "WorkSans",
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (selectedItem != null) {
                            widget.onComplete();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(178, 38),
                          backgroundColor: AppColors.royalPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
