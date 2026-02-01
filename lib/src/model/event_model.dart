import 'dart:convert';
import '../util/api_adapter.dart';
import '../util/collection.dart';
import '../errors/errors.dart';
import 'base_model.dart';
import 'category_model.dart';
import 'venue_model.dart';
import 'section_model.dart';
import 'token_model.dart';
import '../service/token_service.dart';

class EventModel extends BaseModel {
  String published;
  String title;
  String description;
  String status;
  String type;
  bool public;
  CategoryModel category;
  String subcategory;
  String start;
  String end;
  VenueModel venue;
  String disclaimer;
  List<String> tags;
  int popularity;
  List<SectionModel> sections;

  String _bannerUrl;
  String _thumbnailUrl;
  late final TokenService _tokenService;

  EventModel(Map<String, dynamic> data, APIAdapter adapter)
      : published = data['published'] as String? ?? '',
        title = data['title'] as String? ?? '',
        description = data['description'] as String? ?? '',
        status = data['status'] as String? ?? '',
        type = data['type'] as String? ?? '',
        public = data['public'] as bool? ?? false,
        category = CategoryModel(data['category'] as Map<String, dynamic>, adapter),
        subcategory = data['subcategory'] as String? ?? '',
        start = data['start'] as String? ?? '',
        end = data['end'] as String? ?? '',
        venue = VenueModel(data['venue'] as Map<String, dynamic>, adapter),
        disclaimer = data['disclaimer'] as String? ?? '',
        tags = (data['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
        popularity = data['popularity'] as int? ?? 0,
        sections = [],
        _bannerUrl = data['banner'] as String? ?? '',
        _thumbnailUrl = data['thumbnail'] as String? ?? '',
        super(data['self'] as String, adapter) {
    // Process sections
    for (final section in data['sections'] as List? ?? []) {
      final sectionData = section as Map<String, dynamic>;
      sectionData['self'] = '${uri}${sectionData['self']}';
      sections.add(SectionModel(sectionData, adapter));
    }
    
    // Initialize token service
    _tokenService = TokenService(adapter, this);
  }

  String get banner => _bannerUrl;
  String get thumbnail => _thumbnailUrl;
  
  Collection<TokenModel> get tokens => _tokenService.list();

  Future<bool> submit() async {
    try {
      await apiAdapter.post('$uri/submissions', {});
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> cancel() async {
    try {
      await apiAdapter.post('$uri/cancellations', {});
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<TokenModel> issueToken(List<SectionModel> sections) async {
    try {
      final sectionData = sections.map((section) => section.uri).toList();
      
      final response = await apiAdapter.post(
        '$uri/tokens',
        {'sections': sectionData},
      );
      
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return TokenModel(responseData, this, apiAdapter);
    } catch (e) {
      if (e is TickeTingError) {
        if (e.code == 400) {
          throw BadDataError(e.code, e.message);
        } else if (e.code == 403) {
          throw PermissionError(e.code, e.message);
        }
      }
      rethrow;
    }
  }

  @override
  Map<String, dynamic> serialise() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'public': public,
      'category': category.id,
      'subcategory': subcategory,
      'start': start,
      'end': end,
      'venue': venue.id,
      'disclaimer': disclaimer,
      'tags': tags,
    };
  }
}
