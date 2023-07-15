# coinkeeper

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Dependencies
flutter pub add sqflite
flutter pub add url_launcher
flutter pub add shared_preferences

## TODO
- [x] new wallet item is not working
- [x] add validation and add number keyboard for decimal data entry
- [x] fix: amount value calculation on updating query
- [x] add onclick for each transaction and open edit page [to include: title, description, amount, wallet, category, income/expense]
- [ ] add interest calculation from [this](https://github.com/GAUTAMSHETA/Interest-management-application) repo
- [ ] wallet page auto refresh
- [ ] TODOs inline code ko complete karna hai
- [ ] show distinct category for as menu item text box in add_transaction screen
- [ ] infinite scroll pagination, lazy loading
- [ ] settings page [show github profile, change currency, delete all data, show app version, account holder name, [export data to csv or other format and import](https://docs.flutter.dev/cookbook/persistence/reading-writing-files),]
- [ ] caching data
- [ ] design
- [ ] code cleanup [add global text size to all text widget]

### maybe TODOs
- [ ] add multi user
- [ ] multiple language support

## Code snippets
- wallet list view
```dart
ListView.builder(
    itemCount: _walletjournals.length,
    itemBuilder: (context, index) => Card(
        color: Colors.orange[200],
        margin: const EdgeInsets.all(15),
        child: ListTile(
        title: Text(_walletjournals[index]['title'].toString()),
        subtitle: Text(_walletjournals[index]['amount'].toString()),
        ),
    ),
),
```