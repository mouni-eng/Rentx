import 'package:rentx/infrastructure/http_service.dart';
import 'package:rentx/models/file_upload.dart';

class FileService {
  final HttpService _httpService = HttpService();

  Future<FileUploadResponse> upload(
      String url, FileUploadRequest uploadRequest) async {
    final response = await _httpService.uploadFile(url, uploadRequest);
    return FileUploadResponse.fromJson(response);
  }
}
