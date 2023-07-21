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

### Working on it

### TODOs
- [ ] wallet page auto refresh
- [ ] [export data to csv or other format and import](https://docs.flutter.dev/cookbook/persistence/reading-writing-files)
- [ ] TODOs inline code ko complete karna hai
- [ ] show distinct category for as menu item text box in add_transaction screen
- [ ] infinite scroll pagination, lazy loading
- [ ] fix dbExportToDownloadFolder in sql_helper.dart
- [ ] fix settings initial value from getting from shared preferences
- [ ] fix when editing transaction changing wallet causes imbalance of wallet amount
- [ ] fix sql_helper new wallet add amount [total wallet amount calculation]
- [ ] fix edit_transaction updateItem() values are not updating
- [ ] add mobile platform validation for screen
- [ ] caching data
- [ ] design
- [ ] code cleanup [add global text size to all text widget]
- [ ] [build apk automatically](https://www.geeksforgeeks.org/flutter-building-and-releasing-apk-using-github-actions/)

### maybe TODOs
- [ ] add multi user
- [ ] multiple language support