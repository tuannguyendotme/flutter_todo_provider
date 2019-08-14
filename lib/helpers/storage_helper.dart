import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  Future clear() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.clear();
  }
}
