import 'dart:async';
import 'package:flutter/material.dart';
import 'package:merume_mobile/api/user_api/get_all_last_updates.dart';
import 'package:merume_mobile/api/user_api/heartbeat_manager.dart';
import 'package:merume_mobile/api/user_api/user_channels_api/channel_read_tracker_api/get_read_trackers_api.dart';
import 'package:merume_mobile/local_db/repositories/channel_read_tracker_repository.dart';
import 'package:merume_mobile/models/last_update_model.dart';
import 'package:merume_mobile/providers/error_provider.dart';
import 'package:merume_mobile/utils/data_fetching_utils/basic_stream_data_handler.dart';
import 'package:provider/provider.dart';

class AuthenticatedUserWrapper extends StatefulWidget {
  final Widget child;

  const AuthenticatedUserWrapper({super.key, required this.child});

  @override
  State<AuthenticatedUserWrapper> createState() =>
      _AuthenticatedUserWrapperState();
}

class _AuthenticatedUserWrapperState extends State<AuthenticatedUserWrapper> {
  late HeartbeatManager _heartbeatManager;
  late BasicStreamDataHandler<LastUpdate> _streamDataHandler;
  late ErrorProvider _errorProvider;
  final _itemsController = StreamController<LastUpdate>();

  @override
  void initState() {
    super.initState();
    _errorProvider = Provider.of<ErrorProvider>(context, listen: false);
    _heartbeatManager = HeartbeatManager();
    userLastUpdates();

    setFetchedReadTrackers();
  }

  void setFetchedReadTrackers() async {
    final readTrackers = await getReadTrackers();

    ChannelReadTrackerRepository.writeReadTrackers(readTrackers);
  }

  void userLastUpdates() {
    _streamDataHandler = BasicStreamDataHandler<LastUpdate>(
        context: context,
        fetchFunction: fetchAllLastUpdates,
        controller: _itemsController,
        errorProvider: _errorProvider,
        retryDelaySeconds: 10);

    _streamDataHandler.fetchStreamData();
  }

  @override
  void dispose() {
    _heartbeatManager.close();
    _itemsController.sink.close();
    _itemsController.close();
    _streamDataHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
