import 'package:flutter/material.dart';
import 'package:merume_mobile/models/channel_model.dart';

class ChannelWidget extends StatefulWidget {
  final Channel channel;

  const ChannelWidget({Key? key, required this.channel}) : super(key: key);

  @override
  State<ChannelWidget> createState() => _ChannelWidgetState();
}

class _ChannelWidgetState extends State<ChannelWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56), // Set the height of the AppBar
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.blueGrey.withOpacity(0.5),
                width: 1.0,
              ),
            ),
          ),
          child: AppBar(
            title: Container(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(widget.channel.name),
            ),
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0, right: 30.0, left: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [],
          ),
        ),
      ),
    );
  }
}
