typedef CollectionExecutor<T> = Future<List<T>> Function();

class Collection<T> {
  final CollectionExecutor<T> _executor;
  final bool _root;
  int _cursor;

  int Function() _onPages = () => 0;
  void Function(Map<String, dynamic>) _onFilter = (criteria) {};
  void Function(String, String) _onSort = (field, order) {};
  int Function() _onCurrent = () => 0;
  void Function(int) _onPageChange = (page) {};
  void Function() _onReset = () {};

  Future<List<T>>? _deferredPromise;

  Collection(this._executor, {bool root = true, int cursor = 1})
      : _root = root,
        _cursor = cursor;

  Future<List<T>> call() {
    _deferredPromise ??= _executor();
    return _deferredPromise!;
  }

  Future<int> get current async => _cursor;

  Future<int> get pages async {
    await call();
    return _onPages();
  }

  Collection<T> filter(Map<String, dynamic> criteria) {
    return _copy(() async {
      _onFilter(criteria);
      return await _executor();
    }, _cursor);
  }

  Collection<T> sort(String field, {bool ascending = true}) {
    return _copy(() async {
      _onSort(field, ascending ? "asc" : "desc");
      return await _executor();
    }, _cursor);
  }

  Collection<T> next() {
    return _copy(() async {
      final current = await this.current;
      _goto(current + 1);
      return await _executor();
    }, _cursor + 1);
  }

  Collection<T> previous() {
    return _copy(() async {
      final current = await this.current;
      _goto(current - 1);
      return await _executor();
    }, _cursor - 1);
  }

  Collection<T> first() {
    return _copy(() async {
      _goto(1);
      return await _executor();
    }, 1);
  }

  Collection<T> goto(int page) {
    return _copy(() async {
      _goto(page);
      return await _executor();
    }, page);
  }

  Future<bool> get hasNext async => await current < await pages;

  Future<bool> get hasPrevious async => await current > 1;

  void onCurrent(int Function() callback) {
    _onCurrent = callback;
  }

  void onPages(int Function() callback) {
    _onPages = callback;
  }

  void onFilter(void Function(Map<String, dynamic>) callback) {
    _onFilter = callback;
  }

  void onSort(void Function(String, String) callback) {
    _onSort = callback;
  }

  void onPageChange(void Function(int) callback) {
    _onPageChange = callback;
  }

  void onReset(void Function() callback) {
    _onReset = callback;
  }

  Collection<T> _copy(CollectionExecutor<T> executor, [int cursor = 1]) {
    if (_root) {
      _onReset();
    }

    final collection = Collection<T>(executor, root: false, cursor: cursor);
    collection.onCurrent(_onCurrent);
    collection.onPages(_onPages);
    collection.onFilter(_onFilter);
    collection.onSort(_onSort);
    collection.onPageChange(_onPageChange);
    collection.onReset(_onReset);
    return collection;
  }

  void _goto(int page) {
    _onPageChange(page);
  }
}
