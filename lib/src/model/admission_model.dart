import '../util/api_adapter.dart';
import 'base_model.dart';
import 'account_model.dart';
import 'event_model.dart';
import 'section_model.dart';

class AdmissionModel extends BaseModel {
  String redeemer;
  String device;
  String ticket;
  AccountModel patron;
  SectionModel section;
  String admitted;

  final EventModel _event;

  AdmissionModel(Map<String, dynamic> data, this._event, APIAdapter adapter)
      : redeemer = data['redeemer'] as String? ?? '',
        device = data['device'] as String? ?? '',
        ticket = data['ticket'] as String? ?? '',
        patron = AccountModel(data['patron'] as Map<String, dynamic>, adapter),
        section = SectionModel(data['section'] as Map<String, dynamic>, adapter),
        admitted = data['admitted'] as String? ?? '',
        super(data['self'] as String, adapter);

  @override
  Map<String, dynamic> serialise() {
    return {
      'redeemer': redeemer,
      'device': device,
      'ticket': ticket,
      'patron': patron.uri,
      'section': section.uri,
      'admitted': admitted,
    };
  }
}
