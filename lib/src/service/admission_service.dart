import '../util/api_adapter.dart';
import '../model/admission_model.dart';
import '../model/event_model.dart';
import 'base_service.dart';

class AdmissionService extends BaseService<Map<String, dynamic>, AdmissionModel> {
  final APIAdapter _apiAdapter;
  final EventModel _event;

  AdmissionService(this._apiAdapter, this._event)
      : super(
          _apiAdapter,
          '${_event.uri}/admissions',
          (data, adapter) => AdmissionModel(data, _event, adapter),
          supportedFilters: ['redeemer', 'device', 'ticket', 'patron', 'section'],
        );

  @override
  AdmissionModel _instantiateModel(Map<String, dynamic> data) {
    return AdmissionModel(data, _event, _apiAdapter);
  }
}
