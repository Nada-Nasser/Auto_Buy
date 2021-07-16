import 'package:auto_buy/screens/home_page/SearchBar/searhBar.dart';
import 'package:auto_buy/screens/no_connection_screen.dart';
import 'package:auto_buy/services/conntections_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page_screen.dart';

class HomePageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConnectionChangeNotifier>(
      create: (context) => ConnectionChangeNotifier(),
      child: Consumer<ConnectionChangeNotifier>(
        builder: (_, notifier, __) => Scaffold(
          body: _buildContent(context, notifier),
        ),
      ),
    );
  }

  _buildContent(BuildContext context, ConnectionChangeNotifier notifier) {
    if (notifier._model) {
      print("YES connection");
      return HomePage();
    } else {
      print("NO connection");
      return NoInternetConnectionScreen();
    }
  }
}

class ConnectionChangeNotifier with ChangeNotifier {
  bool _model = true;
  bool hasNetworkConnection = false;
  bool fallbackViewOn = false;

  ConnectionChangeNotifier() {
    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    connectionStatus.connectionChange.listen(_updateConnectivity);
  }

  updateModel(bool flag) {
    if (flag != _model) {
      _model = flag;
      notifyListeners();
    }
  }

  void _updateConnectivity(dynamic hasConnection) => updateModel(hasConnection);
}
