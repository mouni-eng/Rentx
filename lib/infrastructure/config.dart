import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rentx/services/map/map_service.dart';

class ConfigurationService {
  Future<ConfigModel> getConfigs() async {
    String jsonConfig =
        await rootBundle.loadString("assets/config/config.json");
    Map<String, dynamic> map = jsonDecode(jsonConfig);
    String profile = map['activeProfile'];

    jsonConfig = await rootBundle
        .loadString('assets/config/config-' + profile + '.json');

    map = jsonDecode(jsonConfig);
    return ConfigModel.fromJson(map);
  }
}

class ConfigModel {
  final String apiBaseUrl;
  final String publicFilesUrl;
  final bool debugEnabled;
  final bool reportErrors;
  final MapProvider mapProvider;
  final bool logErrors;

  ConfigModel(
      {required this.apiBaseUrl,
      required this.logErrors,
      required this.debugEnabled,
      required this.mapProvider,
      required this.publicFilesUrl,
      required this.reportErrors});

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
        logErrors: json['logErrors'] as bool,
        apiBaseUrl: json['apiBaseUrl'] as String,
        debugEnabled: json['debugEnabled'],
        publicFilesUrl: json['publicFilesUrl'],
        reportErrors: json['reportErrors'],
        mapProvider: MapProvider.values.firstWhere(
            (element) => element.name == json['activeMapProvider']));
  }
}
