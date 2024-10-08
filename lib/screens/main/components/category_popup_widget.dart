import 'package:flutter/material.dart';
import 'package:merume_mobile/constants/colors.dart';
import 'package:merume_mobile/screens/shared/basic/basic_elevated_button_widget.dart';

class CategoryPopup extends StatefulWidget {
  final List<String> categories;
  final List<String> selectedCategories;

  const CategoryPopup({
    super.key,
    required this.categories,
    required this.selectedCategories,
  });

  @override
  CategoryPopupState createState() => CategoryPopupState();
}

class CategoryPopupState extends State<CategoryPopup> {
  late List<String> _updatedCategories;

  @override
  void initState() {
    widget.categories.sort();
    _updatedCategories = List.from(widget.selectedCategories);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: widget.categories.map((category) {
                    bool isSelected = _updatedCategories.contains(category);
                    return ListTile(
                      title: Text(
                        category,
                        style: TextStyle(
                          fontFamily: 'WorkSans',
                          fontSize: 15,
                          color:
                              isSelected ? AppColors.mellowLemon : Colors.white,
                        ),
                      ),
                      leading: isSelected
                          ? const Icon(
                              Icons.check_box,
                              color: AppColors.mellowLemon,
                            )
                          : const Icon(
                              Icons.check_box_outline_blank,
                              color: AppColors.mellowLemon,
                            ),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _updatedCategories.remove(category);
                          } else {
                            _updatedCategories.add(category);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: BasicElevatedButtonWidget(
              onPressed: () {
                Navigator.of(context).pop(_updatedCategories);
              },
              buttonText: "Confirm",
            ),
          ),
        ],
      ),
    );
  }
}
