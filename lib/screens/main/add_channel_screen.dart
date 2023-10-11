import 'package:flutter/material.dart';
import 'package:merume_mobile/colors.dart';

class AddChallengeScreen extends StatefulWidget {
  const AddChallengeScreen({super.key});

  @override
  State<AddChallengeScreen> createState() => _AddChallengeScreenState();
}

class _AddChallengeScreenState extends State<AddChallengeScreen> {
  final TextEditingController _challengeNameController =
      TextEditingController();
  final TextEditingController _challengeDescriptionController =
      TextEditingController();

  String challengeName = '';
  String challengeDescription = '';

  Map<String, String> errors = {};
  String challengeType = 'Public'; // Default value

  @override
  void dispose() {
    _challengeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Challenge',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 32,
                  color: AppColors.mellowLemon,
                ),
              ),
              const SizedBox(height: 50.0),
              TextField(
                controller: _challengeNameController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Challenge name',
                  fillColor: Colors.white,
                  filled: true,
                  errorText: errors.containsKey('challengeName')
                      ? errors['challengeName']
                      : null,
                ),
                onChanged: (value) {
                  challengeName = value;
                },
              ),
              const SizedBox(height: 32.0),
              TextField(
                controller: _challengeDescriptionController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Challenge description',
                  fillColor: Colors.white,
                  filled: true,
                  errorText: errors.containsKey('challengeDescription')
                      ? errors['challengeDescription']
                      : null,
                ),
                onChanged: (value) {
                  challengeDescription = value;
                },
              ),
              const SizedBox(height: 32.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: challengeType,
                    style: const TextStyle(color: Colors.black),
                    items: <String>['Public', 'Private'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        challengeType = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}
