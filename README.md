# coinkeeper

A new Flutter project.

## Getting Started
### Requirements
- minimum Android SDK version required 19

## Dependencies
- flutter pub add intl
- flutter pub add sqflite
- flutter pub add url_launcher
- flutter pub add shared_preferences
- flutter pub add pie_chart

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
- [x] infinite scroll pagination, lazy loading
- [x] fix currency change [on restart the currency changes to default INR]
- [x] fix expense edit negative amount

### Working on it

### TODOs
- [ ] wallet page auto refresh
- [ ] add modal file
- [ ] fix when changing transaction wallet amount does not update to new wallet
- [ ] add mobile platform validation for screen
- [ ] caching data
- [ ] design
- [ ] theme change button in settings
- [ ] code cleanup [add global text size to all text widget]
- [ ] [export data to csv or other format and import](https://docs.flutter.dev/cookbook/persistence/reading-writing-files)
- [ ] [build apk automatically](https://www.geeksforgeeks.org/flutter-building-and-releasing-apk-using-github-actions/)

### maybe TODOs
- [ ] add multi user
- [ ] multiple language support