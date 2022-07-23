import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rentx/extensions/string_extension.dart';
import 'package:rentx/infrastructure/request.dart';

enum FileUploadType { profileImage, carType, company, makes, rental }

extension FileUploadTypeExtension on FileUploadType {
  String get name => describeEnum(this);

  String getParamValue() {
    return name.capitalize();
  }
}

class FileUploadRequest {
  List<File> files;
  final String fileParam = 'files';
  FileUploadType uploadType;

  FileUploadRequest({required this.files, required this.uploadType});
}

class FileUploadResponse extends RentXSerialized {
  late List<String>? fileIds;

  FileUploadResponse(this.fileIds);

  FileUploadResponse.fromJson(final Map<String, dynamic> map) {
    fileIds = convertList(map['fileIds'], (e) => e.toString());
  }

  @override
  Map<String, dynamic> toJson() => {'fileIds': fileIds?.toString()};
}
