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

## TODO
- [x] new wallet item is not working
- [ ] wallet page auto refresh
- [ ] add validation for invalid wallet data entry, add number keyboard for amount data entry
- [ ] add onclick for each transaction and open edit page [to include: change date and time, title, description, amount, wallet, category, income/expense]
- [ ] TODOs inline code ko complete karna hai
- [ ] show distinct category for as menu item text box in add_transaction screen
- [ ] infinite scroll pagination, lazy loading
- [ ] settings page [show github profile, change currency, delete all data, show app version, account holder name, export data to csv or other, import data,]
- [ ] caching data
- [ ] design

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