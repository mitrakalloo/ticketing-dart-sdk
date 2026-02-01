# Migration Guide: Node.js to Dart

This guide helps you migrate from the Node.js/TypeScript version of the TickeTing SDK to the Dart version for Flutter applications.

## Package Installation

### Before (Node.js)
```bash
npm install @ticketingevents/ticketing-sdk
```

### After (Dart/Flutter)
```yaml
# pubspec.yaml
dependencies:
  ticketing_sdk:
    git:
      url: https://github.com/mitrakalloo/ticketing-nodejs-sdk.git
```

Then run:
```bash
flutter pub get
```

## Import Statements

### Before (Node.js)
```javascript
import TickeTing from '@ticketingevents/ticketing-sdk';
```

### After (Dart)
```dart
import 'package:ticketing_sdk/ticketing_sdk.dart';
```

## Initialization

### Before (Node.js)
```javascript
const ticketing = new TickeTing({
  apiKey: "API_KEY",
  sandbox: true
});
```

### After (Dart)
```dart
final ticketing = TickeTing(
  apiKey: 'API_KEY',
  sandbox: true,
);
```

## Async Operations

### Before (Node.js - Promises)
```javascript
ticketing.events.published.list()
  .then(events => {
    console.log(events);
  })
  .catch(error => {
    console.log(error.message);
  });
```

### After (Dart - async/await)
```dart
try {
  final eventsCollection = ticketing.events.published.list();
  final events = await eventsCollection();
  print(events);
} catch (e) {
  if (e is TickeTingError) {
    print(e.message);
  }
}
```

## Listing Resources

### Before (Node.js)
```javascript
// Promises resolve directly to array
const events = await ticketing.events.published.list();
for (const event of events) {
  console.log(event.title);
}
```

### After (Dart)
```dart
// Collection must be called to fetch data
final eventsCollection = ticketing.events.published.list();
final events = await eventsCollection();
for (final event in events) {
  print(event.title);
}
```

## Filtering

### Before (Node.js)
```javascript
const events = await ticketing.events.published
  .list()
  .filter({
    region: "region-id",
    category: "category-id"
  });
```

### After (Dart)
```dart
final events = await ticketing.events.published
  .list()
  .filter({
    'region': 'region-id',
    'category': 'category-id',
  })();  // Note: call() at the end
```

## Sorting

### Before (Node.js)
```javascript
const events = await ticketing.events.published
  .list()
  .sort("start", true);  // true = ascending
```

### After (Dart)
```dart
final events = await ticketing.events.published
  .list()
  .sort('start', ascending: true)();  // named parameter
```

## Pagination

### Before (Node.js)
```javascript
const collection = ticketing.events.published.list();
const page1 = await collection;
const page2 = await collection.next();
const page3 = await collection.goto(3);
```

### After (Dart)
```dart
final collection = ticketing.events.published.list();
final page1 = await collection();
final page2 = await collection.next()();
final page3 = await collection.goto(3)();
```

## Error Handling

### Before (Node.js)
```javascript
try {
  const event = await ticketing.events.find("id");
} catch (error) {
  if (error.code === 404) {
    console.log("Not found");
  }
}
```

### After (Dart)
```dart
try {
  final event = await ticketing.events.find('id');
} on ResourceNotFoundError catch (e) {
  print('Not found: ${e.message}');
} on TickeTingError catch (e) {
  print('Error ${e.code}: ${e.message}');
}
```

## Session Management

### Before (Node.js)
```javascript
// Start session
const key = await ticketing.session.start({
  username: "user",
  password: "pass"
});

// Check if active
if (ticketing.session.active) {
  console.log("Active");
}

// End session
await ticketing.session.end(true);
```

### After (Dart)
```dart
// Start session
final key = await ticketing.session.start({
  'username': 'user',
  'password': 'pass',
});

// Check if active
if (ticketing.session.active) {
  print('Active');
}

// End session
await ticketing.session.end(persist: true);
```

## Creating Resources

### Before (Node.js)
```javascript
const category = await ticketing.categories.create({
  name: "Music",
  subcategories: ["Rock", "Pop"]
});
```

### After (Dart)
```dart
final category = await ticketing.categories.create({
  'name': 'Music',
  'subcategories': ['Rock', 'Pop'],
});
```

## Updating Resources

### Before (Node.js)
```javascript
const event = await ticketing.events.find("event-id");
event.title = "New Title";
await event.save();
```

### After (Dart)
```dart
final event = await ticketing.events.find('event-id');
event.title = 'New Title';
await event.save();
```

## Type Differences

| Node.js/TypeScript | Dart |
|-------------------|------|
| `string` | `String` |
| `number` | `int` or `double` |
| `boolean` | `bool` |
| `Array<T>` | `List<T>` |
| `{[key: string]: T}` | `Map<String, T>` |
| `Promise<T>` | `Future<T>` |
| `null \| undefined` | `null` (with `?` for nullable types) |

## Key Differences Summary

1. **Async Syntax**: Use `async`/`await` everywhere instead of `.then()` chains
2. **Collection Calling**: Collections must be explicitly called with `()` to fetch data
3. **Named Parameters**: Dart uses named parameters (e.g., `ascending: true`)
4. **String Quotes**: Use single quotes `'` by convention in Dart
5. **Type Safety**: Dart has stricter null safety - handle nullable types properly
6. **Error Types**: Catch specific error types like `ResourceNotFoundError`
7. **No Undefined**: Dart only has `null`, not `undefined`
8. **Constructors**: Use named constructors style - no `new` keyword needed

## Flutter Integration Example

In a Flutter widget:

```dart
class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final ticketing = TickeTing(apiKey: 'YOUR_API_KEY');
  List<EventModel> events = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    try {
      final collection = ticketing.events.published.list(pageLength: 20);
      final fetchedEvents = await collection();
      setState(() {
        events = fetchedEvents;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      // Show error dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return CircularProgressIndicator();
    
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(events[index].title),
        subtitle: Text(events[index].venue.name),
      ),
    );
  }
}
```

## Additional Resources

- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Documentation](https://flutter.dev/docs)
- [README_DART.md](./README_DART.md) - Complete Dart SDK documentation
- [example/example.dart](./example/example.dart) - Working examples

## Need Help?

If you encounter issues during migration:
1. Check the Dart-specific README: [README_DART.md](./README_DART.md)
2. Review the example file: [example/example.dart](./example/example.dart)
3. Contact support: dev@ticketingevents.com
