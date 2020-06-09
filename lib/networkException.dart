class NetworkException implements Exception {
  final String _errorMsg;
  final int _errorCode;

  NetworkException(this._errorCode, this._errorMsg);

  String get errorMsg => _errorMsg;
  int get errorCode => _errorCode;
}
