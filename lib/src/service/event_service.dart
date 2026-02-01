import '../util/api_adapter.dart';
import '../model/event_model.dart';
import 'base_service.dart';

class EventService extends BaseService<Map<String, dynamic>, EventModel> {
  late final PublishedEventService published;

  EventService(APIAdapter apiAdapter)
      : super(
          apiAdapter,
          "/events",
          (data, adapter) => EventModel(data, adapter),
          supportedFilters: [
            "region",
            "host",
            "title",
            "status",
            "active",
            "public",
            "section"
          ],
          supportedSortFields: [
            "alphabetical",
            "published",
            "popularity",
            "start"
          ],
        ) {
    published = PublishedEventService(apiAdapter);
  }
}

class PublishedEventService extends BaseService<Map<String, dynamic>, EventModel> {
  PublishedEventService(APIAdapter apiAdapter)
      : super(
          apiAdapter,
          "/published-events",
          (data, adapter) => EventModel(data, adapter),
          supportedFilters: [
            "region",
            "title"
          ],
          supportedSortFields: [
            "alphabetical",
            "published",
            "popularity",
            "start"
          ],
        );
}
