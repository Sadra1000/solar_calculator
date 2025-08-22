class DataState<T> {
  final T? data;
  final String? message;
  const DataState(this.data, this.message);
}

class DataSuccess<T> extends DataState<T> {
  // final T _newData;
  const DataSuccess(T newData) : super(newData, null);
}

class DataFailed<T> extends DataState<T> {
  // ignore: unused_field
  final String _message;
  const DataFailed(this._message) : super(null, _message);
}
