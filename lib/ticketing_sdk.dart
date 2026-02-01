/// TickeTing Dart SDK
///
/// A Dart package for seamless interaction with the TickeTing API.
/// Perfect for building Flutter applications with TickeTing integration.
///
/// ## Installation
///
/// Add this to your package's `pubspec.yaml` file:
///
/// ```yaml
/// dependencies:
///   ticketing_sdk:
///     git:
///       url: https://github.com/mitrakalloo/ticketing-nodejs-sdk.git
/// ```
///
/// ## Quick Start
///
/// ```dart
/// import 'package:ticketing_sdk/ticketing_sdk.dart';
///
/// final ticketing = TickeTing(
///   apiKey: 'YOUR_API_KEY',
/// );
///
/// // Retrieve a collection of published events
/// final events = await ticketing.events.published.list().call();
/// for (final event in events) {
///   print('${event.title}: ${event.description}');
/// }
/// ```
///
/// ## Sandbox Mode
///
/// To test your application in sandbox mode:
///
/// ```dart
/// final ticketing = TickeTing(
///   apiKey: 'YOUR_SANDBOX_API_KEY',
///   sandbox: true,
/// );
/// ```
library ticketing_sdk;

export 'src/ticketing.dart';
export 'src/errors/errors.dart';
export 'src/util/collection.dart';

// Export models
export 'src/model/base_model.dart';
export 'src/model/account_model.dart';
export 'src/model/category_model.dart';
export 'src/model/event_model.dart';
export 'src/model/host_model.dart';
export 'src/model/region_model.dart';
export 'src/model/section_model.dart';
export 'src/model/venue_model.dart';
export 'src/model/token_model.dart';
export 'src/model/ticket_model.dart';
export 'src/model/admission_model.dart';
