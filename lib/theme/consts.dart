import 'package:intl/intl.dart';
import 'package:coinkeeper/settings/sharedpreferences.dart';

String globalCurrencyName = "INR"; // Default currency
NumberFormat formatCurrency =
    NumberFormat.simpleCurrency(name: globalCurrencyName);
double globalFontSize = 18.0;

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
