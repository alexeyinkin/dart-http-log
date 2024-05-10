import 'package:http/http.dart';

class LoggingClient extends BaseClient {
  LoggingClient(this._inner, {
    this.storeLastRequest = false,
  });

  Client _inner;
  bool storeLastRequest;

  BaseRequest? _lastRequest;
  BaseRequest? get lastRequest => _lastRequest;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    _lastRequest = storeLastRequest ? request : null;
    return await _inner.send(request);
  }
}
