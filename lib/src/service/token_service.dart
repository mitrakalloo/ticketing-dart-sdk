import '../util/api_adapter.dart';
import '../model/token_model.dart';
import '../model/event_model.dart';
import 'base_service.dart';

class TokenService extends BaseService<Map<String, dynamic>, TokenModel> {
  final APIAdapter _apiAdapter;
  final EventModel _event;

  TokenService(this._apiAdapter, this._event)
      : super(
          _apiAdapter,
          '${_event.uri}/tokens',
          (data, adapter) => TokenModel(data, _event, adapter),
          supportedFilters: ['global'],
        );

  @override
  TokenModel _instantiateModel(Map<String, dynamic> data) {
    return TokenModel(data, _event, _apiAdapter);
  }
}
