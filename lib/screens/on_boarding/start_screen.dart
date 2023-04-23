import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Color littleLight = const Color(0xFFF3FFAB);
  Color purpleBeaty = const Color(0xFF8E05C2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Image.asset(
                      'assets/images/background.png',
                      width: 300,
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 50.0),
                      child: Text(
                        '1000 Days To Perfection',
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        maxLines: null,
                        style: TextStyle(
                            color: littleLight,
                            fontSize: 40,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.5),
                      ),
                    ),
                    Container(
                      width: 300,
                      margin: const EdgeInsets.only(top: 17.0),
                      child: const Text(
                        'Become the best at what you love to do. Sharpen your skills with Merume!',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.normal,
                            height: 1.3),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ])),
            ),
            const Positioned(
              top: 50,
              left: 35,
              child: Text(
                'Merume',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontFamily: 'Franklin-Gothic-Medium',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(178, 38),
                      backgroundColor: purpleBeaty,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: (() => Navigator.of(context).pushNamed('/login')),
                  child: const Text(
                    'Get started',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
