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

### Working on it
- [ ] settings page [show github profile, change currency, delete all data, account holder name]

### TODOs
- [ ] wallet page auto refresh
- [ ] [export data to csv or other format and import](https://docs.flutter.dev/cookbook/persistence/reading-writing-files)
- [ ] TODOs inline code ko complete karna hai
- [ ] show distinct category for as menu item text box in add_transaction screen
- [ ] infinite scroll pagination, lazy loading
- [ ] fix dbExportToDownloadFolder in sql_helper.dart
- [ ] caching data
- [ ] design
- [ ] code cleanup [add global text size to all text widget]

### maybe TODOs
- [ ] add multi user
- [ ] multiple language support