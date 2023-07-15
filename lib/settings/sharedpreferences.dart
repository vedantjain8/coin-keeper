import 'package:shared_preferences/shared_preferences.dart';

Future<void> initOption() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('currency', "INR");
  prefs.setString('userName', "Guest User");
}

Future<void> saveOptionCurrency(String currency) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('currency', currency);
}

Future<String?> getOptionCurrency() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? action = prefs.getString('currency');
  return action;
}

Future<void> saveOptionName(String userName) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userName', userName);
}

Future<String?> getOptionName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? action = prefs.getString('userName');
  return action;
}