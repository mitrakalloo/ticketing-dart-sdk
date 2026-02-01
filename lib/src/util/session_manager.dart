import 'dart:convert';
import '../util/api_adapter.dart';
import '../errors/errors.dart';
import '../model/base_model.dart';

class SessionModel extends BaseModel {
  String key;
  String account;
  String started;
  String expires;

  SessionModel(Map<String, dynamic> data, APIAdapter adapter)
      : key = data['key'] as String? ?? '',
        account = data['account'] as String? ?? '',
        started = data['started'] as String? ?? '',
        expires = data['expires'] as String? ?? '',
        super(data['self'] as String, adapter);

  @override
  Map<String, dynamic> serialise() {
    return {
      'key': key,
      'account': account,
      'started': started,
      'expires': expires,
    };
  }
}

class SessionManager {
  final APIAdapter _apiAdapter;
  SessionModel? _session;

  SessionManager(this._apiAdapter);

  Future<String> start(Map<String, dynamic> credentials) async {
    if (active) {
      throw UnsupportedOperationError(
          0, "There is already an active session");
    }

    try {
      final response = await _apiAdapter.post("/sessions", credentials);
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      _session = SessionModel(data, _apiAdapter);
      _apiAdapter.key = _session!.key;

      return data['key'] as String;
    } catch (e) {
      if (e is TickeTingError) {
        if (e.code == 401) {
          throw UnauthorisedError(e.code, e.message);
        } else if (e.code == 404) {
          throw ResourceNotFoundError(e.code, e.message);
        }
      }
      rethrow;
    }
  }

  Future<bool> resume(String key) async {
    if (active) {
      throw UnsupportedOperationError(
          0, "There is already an active session.");
    }

    try {
      _apiAdapter.key = key;
      final response = await _apiAdapter.get("/sessions/active");
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      _session = SessionModel(data, _apiAdapter);
      return true;
    } catch (e) {
      _apiAdapter.reset();
      if (e is TickeTingError && e.code == 401) {
        throw InvalidStateError(
            e.code, "The session has ended or does not exist.");
      }
      rethrow;
    }
  }

  Future<bool> end({bool persist = true}) async {
    if (!active) {
      throw UnsupportedOperationError(
          0, "There is currently no active session.");
    }

    if (persist) {
      try {
        await _apiAdapter.delete("/sessions/active");
        _session = null;
        _apiAdapter.reset();
        return true;
      } catch (e) {
        if (e is TickeTingError) {
          if (e.code == 401) {
            throw ResourceNotFoundError(e.code,
                "There is no session associated with the provided key.");
          } else if (e.code == 403) {
            throw InvalidStateError(
                e.code, "The session has already been ended.");
          }
        }
        rethrow;
      }
    } else {
      _session = null;
      _apiAdapter.reset();
      return true;
    }
  }

  Future<SessionModel> info() async {
    if (!active) {
      throw UnsupportedOperationError(
          0, "There is currently no active session.");
    }
    return _session!;
  }

  bool get active => _session != null;
}
