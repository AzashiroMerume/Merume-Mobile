import 'package:flutter/material.dart';
import 'components/categories.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  Color littleLight = const Color(0xFFF3FFAB);
  Color purpleBeaty = const Color(0xFF8E05C2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 75.0, bottom: 75.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                child: Text(
                  'Please select preferences',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: littleLight),
                ),
              ),
              const SizedBox(height: 24.0),
              Column(
                children:
                    List.generate((categories.length / 3).ceil(), (index) {
                  int startIndex = index * 3;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (rowIndex) {
                      int categoryIndex = startIndex + rowIndex;
                      if (categoryIndex >= categories.length) {
                        return const SizedBox();
                      }
                      return GestureDetector(
                        onTap: () {
                          print("tapped");
                        },
                        child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12, width: 1),
                            image: DecorationImage(
                              image: AssetImage(
                                  categories.values.toList()[categoryIndex]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child:
                                Text(categories.keys.toList()[categoryIndex]),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
