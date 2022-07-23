import 'dart:convert';

import 'package:http/http.dart';
import 'package:rentx/infrastructure/config.dart';
import 'package:rentx/infrastructure/exceptions.dart';
import 'package:rentx/infrastructure/request.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/file_upload.dart';

import 'local_storage.dart';

class HttpService {
  final ConfigurationService _configuration = ConfigurationService();
  static ConfigModel? _configModel;
  final LocalStorage _localStorage = LocalStorage();

  Future<Map<String, dynamic>> doPost(
      {required String url,
      RentXSerialized? rentXRequest,
      Map<String, String>? headers}) async {
    if (await _isDebugEnabled()) {
      printLn('Performing HttpRequest POST at: $url');
      if (rentXRequest != null) {
        printLn('RequestBody: ${rentXRequest.toJson()}');
      }
    }
    headers = await _getHeaders(headers);
    Response response = await post(await _getFullUrl(url),
        headers: headers,
        body: jsonEncode(rentXRequest != null ? rentXRequest.toJson() : {},
            toEncodable: _encode));
    return (await _decode(response));
  }

  Future<dynamic> doPatch(
      {required String url,
      RentXSerialized? rentXRequest,
      Map<String, String>? headers}) async {
    var body = rentXRequest?.toJson();
    if (await _isDebugEnabled()) {
      printLn('Performing HttpRequest PATCH at: $url');
      printLn('RequestBody: $body}');
    }
    headers = await _getHeaders(headers);
    Response response = await patch(await _getFullUrl(url),
        headers: headers, body: jsonEncode(body, toEncodable: _encode));
    return _decode(response);
  }

  Future<dynamic> doDelete(String url, {Map<String, String>? headers}) async {
    if (await _isDebugEnabled()) {
      printLn('Performing HttpRequest DELETE at: $url');
    }
    headers = await _getHeaders(headers);
    Response response = await delete(await _getFullUrl(url), headers: headers);
    return _decode(response);
  }

  Future<Map<String, dynamic>> doGet(String url,
      {Map<String, String>? headers}) async {
    if (await _isDebugEnabled()) {
      printLn('Performing HttpRequest GET at: $url');
    }
    headers = await _getHeaders(headers);
    Response response = await get(await _getFullUrl(url), headers: headers);
    return _decode(response);
  }

  Future<dynamic> doGetRaw(String url, {Map<String, String>? headers}) async {
    Response response = await get(await _getFullUrl(url), headers: headers);
    await checkForErrors(response.statusCode, _safeDecodeBody(response),
        url: response.request!.url.toString());
    return response.body;
  }

  Future<dynamic> uploadFile(
      String url, FileUploadRequest fileUploadRequest) async {
    var request = MultipartRequest("POST", await _getFullUrl(url));
    request.headers.addAll(await _getHeaders({}));
    for (var element in fileUploadRequest.files) {
      request.files.add(await MultipartFile.fromPath(
          fileUploadRequest.fileParam, element.path));
    }
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    if (response.statusCode == 200) {
      return jsonDecode(responseString)['result'];
    }
    if (await _isDebugEnabled() || await _logErrors()) {
      printLn(responseString);
    }
    throw ApiException('file-upload-error', 'Error uploading file');
  }

  Future<Map<String, String>> _getHeaders(Map<String, String>? headers) async {
    headers ??= {};
    headers.putIfAbsent('Accept', () => 'application/json');
    headers.putIfAbsent('Content-Type', () => 'application/json');
    headers.putIfAbsent('X-API-KEY', () => '12345');
    String? authKey = await _localStorage.getString(LocalStorageKeys.authKey);
    if (authKey != null && authKey.isNotEmpty) {
      headers.putIfAbsent('Authorization', () => 'Bearer $authKey');
    }
    return headers;
  }

  bool _isErrorResponse(int statusCode) {
    return statusCode != 200 && statusCode != 201;
  }

  Future<Uri> _getFullUrl(String url) async {
    ConfigModel configModel = await _getConfig();
    if (configModel.apiBaseUrl.endsWith('/') && url.startsWith('/')) {
      return Uri.parse(configModel.apiBaseUrl.substring(1) + url);
    }
    if (!configModel.apiBaseUrl.endsWith('/') && !url.startsWith('/')) {
      return Uri.parse(configModel.apiBaseUrl + '/' + url);
    }
    return Uri.parse(configModel.apiBaseUrl + url);
  }

  Future<ConfigModel> _getConfig() async {
    _configModel ??= await _configuration.getConfigs();
    return _configModel!;
  }

  Future<bool> _isDebugEnabled() async {
    ConfigModel configModel = await _getConfig();
    return configModel.debugEnabled;
  }

  Future<bool> _logErrors() async {
    ConfigModel configModel = await _getConfig();
    return configModel.logErrors;
  }

  Future<void> checkForErrors(int statusCode, Map<String, dynamic> body,
      {String? url, dynamic reqBody}) async {
    if (_isErrorResponse(statusCode)) {
      if (await _isDebugEnabled() || await _logErrors()) {
        if (!(await _isDebugEnabled())) {
          if (url != null) {
            printLn('URL: ' + url);
          }
          if (reqBody != null) {
            printLn('RequestBody: ' + reqBody.toString());
          }
        }
        printLn('HttpErrorStatus: ' + statusCode.toString());
        printLn('HttpErrorResponse: ' + body.toString());
      }
      if (statusCode == 401) {
        throw ApiException.authenticationError();
      }
      throw ApiException.fromJson(statusCode, body);
    }
    if (body['success'] != null && !body['success']) {
      throw ApiException.fromJson(statusCode, body);
    } else if (await _isDebugEnabled()) {
      printLn('HttpResponse: ' + body.toString());
    }
  }

  dynamic _encode(dynamic nonEncodable) {
    if (nonEncodable is DateTime) {
      return nonEncodable.toIso8601String();
    }
    return nonEncodable;
  }

  Future<Map<String, dynamic>> _decode(Response response) async {
    var body = _safeDecodeBody(response);
    await checkForErrors(response.statusCode, body,
        url: response.request!.url.toString());
    return body;
  }

  Map<String, dynamic> _safeDecodeBody(Response response) {
    if (response.body.isEmpty) {
      return {};
    }
    return jsonDecode(response.body);
  }
}
