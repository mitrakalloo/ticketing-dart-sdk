<div align="center">
  <h1>
    <br/>
    <a href="https://www.ticketingevents.com"><img src="https://bucket.mlcdn.com/a/1192/1192308/images/2519b476a349247dcde9ad6978e7af81812878a0.png" alt="TickeTing logo" width="200px"/></a>
    <br />
  </h1>
  <sup>
    <br />
    TickeTing Dart SDK for Flutter
    <br />
    <br />

[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE.md)

  </sup>
  <br />
</div>

# TickeTing Dart SDK

A Dart package for seamless interaction with the TickeTing API. Perfect for building Flutter applications with TickeTing integration.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  ticketing_sdk:
    git:
      url: https://github.com/mitrakalloo/ticketing-dart-sdk.git
```

Then run:

```bash
dart pub get
```

Or for Flutter:

```bash
flutter pub get
```

## Quick Start

TickeTing SDK functionality is made available through the `TickeTing` class. To begin using the SDK, instantiate the class with your provided `API_KEY`. If you have not yet been assigned an `API_KEY`, you can [request one](mailto:dev@ticketingevents.com?subject=RE:%20API%20Key%20Request) now.

```dart
import 'package:ticketing_sdk/ticketing_sdk.dart';

Future<void> main() async {
  final ticketing = TickeTing(
    apiKey: 'YOUR_API_KEY',
  );

  // Retrieve a collection of published events
  try {
    final eventsCollection = ticketing.events.published.list();
    final events = await eventsCollection();
    
    for (final event in events) {
      print('${event.title}: ${event.description}');
    }
  } catch (e) {
    if (e is TickeTingError) {
      print('Error: ${e.message}');
    }
  }
}
```

## Sandbox Mode

If you need to test your application before releasing to production, the TickeTing SDK supports a sandbox mode. When in sandbox mode, the SDK will interface with the QA API, and any changes you make won't affect the live TickeTing Platform.

Note that you will need to [request a separate sandbox API key](mailto:dev@ticketingevents.com?subject=RE:%20API%20Key%20Request) to work in sandbox mode. To enter sandbox mode, instantiate the TickeTing class with the `sandbox` argument set to `true`.

```dart
final ticketing = TickeTing(
  apiKey: 'YOUR_SANDBOX_API_KEY',
  sandbox: true,
);
```

## Flutter Integration

The TickeTing SDK works seamlessly with Flutter. Here's an example of integrating it into a Flutter app:

```dart
import 'package:flutter/material.dart';
import 'package:ticketing_sdk/ticketing_sdk.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late TickeTing ticketing;
  List<EventModel> events = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    ticketing = TickeTing(apiKey: 'YOUR_API_KEY');
    loadEvents();
  }

  Future<void> loadEvents() async {
    try {
      final eventsCollection = ticketing.events.published.list(pageLength: 20);
      final fetchedEvents = await eventsCollection();
      
      setState(() {
        events = fetchedEvents;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      // Handle error
      print('Error loading events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ListTile(
          title: Text(event.title),
          subtitle: Text(event.venue.name),
          trailing: Text(event.start),
          onTap: () {
            // Navigate to event details
          },
        );
      },
    );
  }
}
```

## Usage Examples

### Listing Events

```dart
// Get published events with pagination
final eventsCollection = ticketing.events.published.list(pageLength: 10);
final events = await eventsCollection();

// Navigate through pages
final nextPageCollection = eventsCollection.next();
final nextPageEvents = await nextPageCollection();

// Go to a specific page
final page3Collection = eventsCollection.goto(3);
final page3Events = await page3Collection();
```

### Filtering Events

```dart
// Filter events by various criteria
final filteredCollection = ticketing.events.published
    .list()
    .filter({
      'region': 'region-id',
      'category': 'category-id',
      'tag': 'music',
    });
final filteredEvents = await filteredCollection();
```

### Sorting Events

```dart
// Sort events by different fields
final sortedCollection = ticketing.events.published
    .list()
    .sort('start', ascending: true);
final sortedEvents = await sortedCollection();
```

### Getting Event Details

```dart
// Fetch a specific event by ID
final event = await ticketing.events.find('event-id');
print('Event: ${event.title}');
print('Description: ${event.description}');
print('Venue: ${event.venue.name}');
```

### Session Management

```dart
// Start a session
final sessionKey = await ticketing.session.start({
  'username': 'your-username',
  'password': 'your-password',
});

// Check if session is active
if (ticketing.session.active) {
  print('Session is active');
}

// Resume an existing session
await ticketing.session.resume('session-key');

// Get session info
final sessionInfo = await ticketing.session.info();

// End the session
await ticketing.session.end();
```

### Working with Categories

```dart
// List all categories
final categoriesCollection = ticketing.categories.list();
final categories = await categoriesCollection();

for (final category in categories) {
  print('Category: ${category.name}');
  print('Subcategories: ${category.subcategories.join(", ")}');
}

// Get a specific category
final category = await ticketing.categories.find('category-id');
```

### Working with Venues

```dart
// List venues
final venuesCollection = ticketing.venues.list();
final venues = await venuesCollection();

for (final venue in venues) {
  print('Venue: ${venue.name}');
  print('Address: ${venue.address}');
  print('Region: ${venue.region.name}');
  print('Coordinates: ${venue.latitude}, ${venue.longitude}');
}
```

### Error Handling

```dart
try {
  final events = await ticketing.events.published.list()();
} on UnauthorisedError catch (e) {
  print('Authentication error: ${e.message}');
} on ResourceNotFoundError catch (e) {
  print('Resource not found: ${e.message}');
} on BadDataError catch (e) {
  print('Invalid data: ${e.message}');
} on TickeTingError catch (e) {
  print('API error: ${e.message}');
} catch (e) {
  print('Unexpected error: $e');
}
```

## API Reference

### Main Classes

- **`TickeTing`** - Main SDK class with access to all services
- **`EventService`** - Manage events
- **`CategoryService`** - Manage categories
- **`VenueService`** - Manage venues
- **`HostService`** - Manage event hosts
- **`RegionService`** - Manage geographical regions
- **`AccountService`** - Manage user accounts
- **`SessionManager`** - Manage authentication sessions
- **`PresetService`** - Access preset data like countries

### Models

- **`EventModel`** - Event resource
- **`CategoryModel`** - Category resource
- **`VenueModel`** - Venue resource
- **`HostModel`** - Host resource
- **`RegionModel`** - Region resource
- **`AccountModel`** - Account resource
- **`SectionModel`** - Event section/ticket type

### Error Types

- **`TickeTingError`** - Base error class
- **`UnauthorisedError`** - Authentication/authorization errors
- **`ResourceNotFoundError`** - Resource not found (404)
- **`BadDataError`** - Invalid data in request (400)
- **`ResourceExistsError`** - Resource already exists (409)
- **`PageAccessError`** - Invalid page requested
- **`UnsupportedCriteriaError`** - Invalid filter criteria
- **`UnsupportedSortError`** - Invalid sort field

## Advanced Features

### Collection Pagination

Collections support various pagination methods:

```dart
final collection = ticketing.events.published.list(pageLength: 10);

// Check pagination info
final currentPage = await collection.current;
final totalPages = await collection.pages;
final hasNext = await collection.hasNext;
final hasPrevious = await collection.hasPrevious;

// Navigate
final firstPage = collection.first();
final nextPage = collection.next();
final prevPage = collection.previous();
final specificPage = collection.goto(5);
```

### Chaining Operations

You can chain filter, sort, and pagination operations:

```dart
final events = await ticketing.events.published
    .list(pageLength: 20)
    .filter({'region': 'region-id'})
    .sort('popularity', ascending: false)
    .goto(2)
    ();
```

## Support

For API support, please contact [dev@ticketingevents.com](mailto:dev@ticketingevents.com).

## License

This SDK is MIT licensed. See the [LICENSE.md](LICENSE.md) file for details.
