import '../util/api_adapter.dart';
import '../errors/errors.dart';
import 'base_model.dart';
import 'event_model.dart';
import 'section_model.dart';

class TokenModel extends BaseModel {
  String code;
  bool global;
  List<SectionModel> sections;

  final EventModel _event;
  List<SectionModel> _originalSections;

  TokenModel(Map<String, dynamic> data, this._event, APIAdapter adapter)
      : code = data['code'] as String? ?? '',
        global = data['global'] as bool? ?? false,
        sections = [],
        _originalSections = [],
        super(data['self'] as String, adapter) {
    // Index event sections
    final sectionMap = <String, SectionModel>{};
    for (final section in _event.sections) {
      sectionMap[section.uri] = section;
    }

    for (final section in data['sections'] as List? ?? []) {
      final sectionUri = section.toString();
      if (sectionMap.containsKey(sectionUri)) {
        sections.add(sectionMap[sectionUri]!);
        _originalSections.add(sectionMap[sectionUri]!);
      }
    }
  }

  void allow(SectionModel section) {
    if (!sections.contains(section)) {
      sections.add(section);
    }
  }

  void deny(SectionModel section) {
    sections.remove(section);
  }

  @override
  Future<bool> save() async {
    try {
      final saved = await super.save();
      _originalSections = List.from(sections);
      return saved;
    } catch (e) {
      if (e is TickeTingError && e.code == 409) {
        sections = List.from(_originalSections);
        throw ResourceImmutableError(e.code, e.message);
      }
      sections = List.from(_originalSections);
      rethrow;
    }
  }

  @override
  Map<String, dynamic> serialise() {
    final sectionUris = sections.map((section) => section.uri).toList();
    return {
      'sections': sectionUris,
    };
  }
}
