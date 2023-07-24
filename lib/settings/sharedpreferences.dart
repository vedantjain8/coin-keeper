import 'package:shared_preferences/shared_preferences.dart';

Future<void> initOption() async {
  // TODO use this function to init the shared preference
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('currency', "INR");
  prefs.setString('userName', "Guest User");
}

Future<void> saveOption(String stringKey, String stringValue) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(stringKey, stringValue);
}

Future<String?> getOption(String stringKey) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? action = prefs.getString(stringKey);
  return action;
}
