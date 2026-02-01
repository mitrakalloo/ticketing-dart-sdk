import '../util/api_adapter.dart';
import 'base_model.dart';
import 'account_model.dart';
import 'event_model.dart';
import 'section_model.dart';

class TicketModel extends BaseModel {
  String serial;
  String status;
  SectionModel section;
  AccountModel owner;
  String issued;
  String redeemed;

  final EventModel _event;

  TicketModel(Map<String, dynamic> data, this._event, APIAdapter adapter)
      : serial = data['serial'] as String? ?? '',
        status = data['status'] as String? ?? '',
        section = SectionModel(data['section'] as Map<String, dynamic>, adapter),
        owner = AccountModel(data['owner'] as Map<String, dynamic>, adapter),
        issued = data['issued'] as String? ?? '',
        redeemed = data['redeemed'] as String? ?? '',
        super(data['self'] as String, adapter);

  @override
  Map<String, dynamic> serialise() {
    return {
      'serial': serial,
      'status': status,
      'owner': owner.uri,
      'section': section.uri,
      'issued': issued,
      'redeemed': redeemed,
    };
  }
}
