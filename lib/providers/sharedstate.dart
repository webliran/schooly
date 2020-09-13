import 'package:shared_preferences/shared_preferences.dart';

class SharedState {
  read(key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key) ?? 0;
    print('got $key');
    return value;
  }

  save(key, value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    print('saved $value');
  }

  remove(key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    print('removed $key');
  }

  check(key) async {
    final prefs = await SharedPreferences.getInstance();
    bool isExsist = prefs.containsKey(key);

    return isExsist;
  }
}
