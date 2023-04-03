import 'package:flutter/material.dart';
import '../../../api/user_channels_api.dart';

class CreatedChannelsScreen extends StatefulWidget {
  const CreatedChannelsScreen({super.key});

  @override
  State<CreatedChannelsScreen> createState() => _CreatedChannelsScreenState();
}

class _CreatedChannelsScreenState extends State<CreatedChannelsScreen> {
  Color littleLight = const Color(0xFFF3FFAB);
  Color purpleBeaty = const Color(0xFF8E05C2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 22.0, bottom: 0.0, right: 30.0, left: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: filterButtons,
              //   ),
              // ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<List<Channel>>(
                  stream: fetchOwnChannels(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final channels = snapshot.data!;
                      return ListView.builder(
                        itemCount: channels.length,
                        itemBuilder: (_, index) => Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: const Color(0xff97FFFF),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                channels[index].name,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(channels[index].description),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
