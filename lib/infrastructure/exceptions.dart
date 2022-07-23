class RentXException implements Exception {
  late int httpError;
  late String errorType;
  late String errorCode;
  late String errorMessage;
}

class AccessDeniedException implements Exception {}

class ApiException extends RentXException {
  ApiException.authenticationError() {
    httpError = 401;
    errorCode = 'authentication-error';
    errorMessage = 'Unauthenticated';
  }

  ApiException(String errorCode, String errorMessage) {
    this.errorCode = errorCode;
    this.errorMessage = errorMessage;
  }

  ApiException.fromJson(int statusCode, Map<String, dynamic> json) {
    httpError = statusCode;
    dynamic errors = json['errors'] as List?;
    if (errors != null && errors!.isNotEmpty) {
      dynamic error = errors[0];
      errorCode = error['code'];
      errorMessage = error['message'];
    } else {
      errorCode = '';
      errorMessage = '';
    }
  }

  @override
  String toString() {
    return 'ApiException{errorCode: $errorCode, errorMessage:$errorMessage}';
  }
}

class BusinessException extends RentXException {
  BusinessException(String errorCode, String errorMessage) {
    this.errorCode = errorCode;
    this.errorMessage = errorMessage;
  }
}
