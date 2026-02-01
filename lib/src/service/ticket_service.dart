import '../util/api_adapter.dart';
import '../model/ticket_model.dart';
import '../model/event_model.dart';
import 'base_service.dart';

class TicketService extends BaseService<Map<String, dynamic>, TicketModel> {
  final APIAdapter _apiAdapter;
  final EventModel _event;

  TicketService(this._apiAdapter, this._event)
      : super(
          _apiAdapter,
          '${_event.uri}/tickets',
          (data, adapter) => TicketModel(data, _event, adapter),
          supportedFilters: ['modified_since'],
        );

  @override
  TicketModel _instantiateModel(Map<String, dynamic> data) {
    return TicketModel(data, _event, _apiAdapter);
  }
}
