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

## Urgent TODO:
- [ ] home.dart me keyboard show nahi ho raha hai, therefor resulting in return of 0 in media query bottom insets

## TODO
- [ ] add validation for invalid wallet data entry
- [ ] show distinct category for new expense or income in showform with menu item
- [ ] infinite scroll pagination

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