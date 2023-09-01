import 'package:intl/intl.dart';
import 'package:coinkeeper/settings/sharedpreferences.dart';

DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss aa");
String globalCurrencyName = "INR"; // Default currency

NumberFormat formatCurrency =
    NumberFormat.simpleCurrency(name: globalCurrencyName);

void updateGlobalCurrencyName(String currencyName) {
  globalCurrencyName = currencyName;
  formatCurrency = NumberFormat.simpleCurrency(name: globalCurrencyName);
}

Future<void> initCurrencyOption() async {
  final String? savedCurrency = await getOption("currency");
  if (savedCurrency != null) {
    updateGlobalCurrencyName(savedCurrency);
  }
}
