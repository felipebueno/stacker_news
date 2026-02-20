import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Manages active lightning bolt strikes across the app.
///
/// Call [strike] to spawn a bolt,
/// and [unstrike] to remove it once its animation completes.
class LightningProvider extends ChangeNotifier {
  int _nextId = 0;
  final Map<int, bool> _bolts = {};

  /// All currently active bolt IDs.
  List<int> get activeBoltIds => _bolts.keys.toList();

  /// Strike lightning on the screen, if the user has the setting enabled.
  /// Returns the id of the spawned bolt.
  int strike() {
    final id = _nextId++;
    _bolts[id] = true;
    notifyListeners();
    return id;
  }

  /// Remove a completed bolt by [id].
  void unstrike(int id) {
    _bolts.remove(id);
    notifyListeners();
  }

  static LightningProvider of(BuildContext context, {bool listen = false}) {
    return Provider.of<LightningProvider>(context, listen: listen);
  }
}
