import 'package:flutter/material.dart';
import 'package:merume_mobile/colors.dart';

class CategoryPopup extends StatefulWidget {
  final List<String> categories;
  final List<String> selectedCategories;

  const CategoryPopup({
    Key? key,
    required this.categories,
    required this.selectedCategories,
  }) : super(key: key);

  @override
  _CategoryPopupState createState() => _CategoryPopupState();
}

class _CategoryPopupState extends State<CategoryPopup> {
  late List<String> _updatedCategories;

  @override
  void initState() {
    _updatedCategories = List.from(widget.selectedCategories);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.categories.map((category) {
                bool isSelected = _updatedCategories.contains(category);
                return ListTile(
                  title: Text(
                    category,
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 15,
                      color: isSelected ? AppColors.mellowLemon : Colors.white,
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
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(_updatedCategories);
            },
            child: const Text(
              "Confirm",
              style: TextStyle(
                color: AppColors.mellowLemon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
