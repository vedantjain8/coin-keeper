# coinkeeper

A new Flutter project.

## Getting Started
### Requirements
- minimum Android SDK version required 19

## Dependencies
- flutter pub add sqflite
- flutter pub add url_launcher
- flutter pub add shared_preferences
- flutter pub add package_info_plus
> package_info_plus package not working with something in the app

## Roadmap
### Completed
- [x] new wallet item is not working
- [x] add validation and add number keyboard for decimal data entry
- [x] fix: amount value calculation on updating query
- [x] add onclick for each transaction and open edit page [to include: title, description, amount, wallet, category, income/expense]
- [x] settings page [show github profile, change currency, delete all data, account holder name]
- [x] fix sql_helper new wallet add amount [total wallet amount calculation]
- [x] fix edit_transaction updateItem() values are not updating
- [x] fix settings initial value from getting from shared preferences
- [x] show distinct category for as menu item text box in add_transaction screen
- [x] complete inline TODOs

### Working on it

### TODOs
- [ ] wallet page auto refresh
- [ ] add modal file
- [ ] fix when changing transaction wallet amount does not update to new wallet
- [ ] infinite scroll pagination, lazy loading
- [ ] fix currency change [on restart the currency changes to default INR]
- [ ] add mobile platform validation for screen
- [ ] caching data
- [ ] design
- [ ] code cleanup [add global text size to all text widget]
- [ ] [export data to csv or other format and import](https://docs.flutter.dev/cookbook/persistence/reading-writing-files)
- [ ] [build apk automatically](https://www.geeksforgeeks.org/flutter-building-and-releasing-apk-using-github-actions/)

### maybe TODOs
- [ ] add multi user
- [ ] multiple language support

# GPT3 help
## How to update formateCurrency from the same file wihout passing the value all over the app seperately
If you want to avoid passing the `formatCurrency` instance around multiple files, you can consider using a `ChangeNotifier` with `Provider` from the `provider` package to manage the currency state in your app. This way, you can update the currency value from anywhere in your app and automatically propagate the changes to all the widgets that use the currency formatting.

Here's how you can achieve this:

1. Create a `CurrencyProvider` class that extends `ChangeNotifier`. This class will hold the current currency value and provide methods to update it.

```dart
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:coinkeeper/settings/sharedpreferences.dart';

class CurrencyProvider with ChangeNotifier {
  String _currencyName = "INR";
  NumberFormat _currencyFormat = NumberFormat.simpleCurrency(name: "INR");

  CurrencyProvider() {
    _initCurrency();
  }

  String get currencyName => _currencyName;
  NumberFormat get currencyFormat => _currencyFormat;

  Future<void> _initCurrency() async {
    final currency = await getOption("currency");
    if (currency != null) {
      _currencyName = currency;
      _currencyFormat = NumberFormat.simpleCurrency(name: currency);
    }
    notifyListeners();
  }

  Future<void> setCurrency(String newCurrency) async {
    _currencyName = newCurrency;
    _currencyFormat = NumberFormat.simpleCurrency(name: newCurrency);
    await saveOption("currency", newCurrency);
    notifyListeners();
  }
}
```

2. Wrap your root widget with the `ChangeNotifierProvider` to make the `CurrencyProvider` accessible throughout the app.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CurrencyProvider(),
      child: MyApp(),
    ),
  );
}
```

3. Now, you can access the `CurrencyProvider` and update the currency value from any widget in your app.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    // Access currency name and format from the provider
    final currencyName = currencyProvider.currencyName;
    final currencyFormat = currencyProvider.currencyFormat;

    // You can use the currency format to format values
    final formattedValue = currencyFormat.format(1234.56);

    return Text("Currency: $currencyName, Formatted Value: $formattedValue");
  }
}
```

4. To update the currency value from any widget, use the `setCurrency` method of the `CurrencyProvider`.

```dart
// Somewhere in your widget tree:
final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false);
currencyProvider.setCurrency("USD");
```

By using this approach, you centralize the currency management logic and can easily update the currency value from anywhere in your app. Widgets that depend on the currency formatting will automatically rebuild and display the updated currency information.