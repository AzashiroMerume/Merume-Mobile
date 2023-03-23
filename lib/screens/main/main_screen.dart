import 'package:flutter/material.dart';
import 'package:merume_mobile/api/user_channels_api.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // late Stream<List<Channel>> streamChannels;

  // @override
  // void initState() {
  //   super.initState();
  //   streamChannels = fetchChannels();
  // }

  Color littleLight = const Color(0xFFF3FFAB);
  Color purpleBeaty = const Color(0xFF8E05C2);

  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Merume');

  String currentPressedFilter = 'All';
  List<String> filterOptions = ['All', 'Trending', 'Videos', 'Posts'];
  List<bool> _isSelected = [true, false, false, false];

  void _onFilterButtonPressed(int index) {
    setState(() {
      // Reset all the buttons to unselected
      for (int buttonIndex = 0;
          buttonIndex < _isSelected.length;
          buttonIndex++) {
        _isSelected[buttonIndex] = false;
      }

      // Select the pressed button
      _isSelected[index] = true;

      // Update the current pressed filter
      currentPressedFilter = filterOptions[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> filterButtons = [];

    for (int i = 0; i < filterOptions.length; i++) {
      filterButtons.add(Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: ElevatedButton(
          onPressed: () => _onFilterButtonPressed(i),
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(100, 35),
            backgroundColor: _isSelected[i] ? littleLight : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: _isSelected[i] ? littleLight : purpleBeaty,
                width: 1,
              ),
            ),
          ),
          child: Text(
            filterOptions[i],
            style: TextStyle(
              fontFamily: 'WorkSans',
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: _isSelected[i] ? Colors.black : Colors.white,
            ),
          ),
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Container(
            padding: const EdgeInsets.only(left: 20.0), child: customSearchBar),
        automaticallyImplyLeading: false,
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  if (customIcon.icon == Icons.search) {
                    customIcon = const Icon(Icons.cancel);
                    customSearchBar = const ListTile(
                      leading: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28,
                      ),
                      title: TextField(
                        decoration: InputDecoration(
                          hintText: 'search',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ); // Perform set of instructions.
                  } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text('Merume');
                  }
                });
              },
              icon: customIcon,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 22.0, bottom: 0.0, right: 30.0, left: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: filterButtons,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<List<Channel>>(
                  stream: fetchChannels(),
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
