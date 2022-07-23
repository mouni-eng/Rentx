class FeaturedImage {
  String? url;
  bool? isFeatured;

  FeaturedImage({this.url, this.isFeatured});

  FeaturedImage.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    isFeatured = json['isFeatured'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['isFeatured'] = isFeatured;
    return data;
  }
}

class UploadFeaturedImage {
  String? id;
  bool? isFeatured;

  UploadFeaturedImage({this.id, this.isFeatured});

  UploadFeaturedImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isFeatured = json['isFeatured'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['isFeatured'] = isFeatured;
    return data;
  }
}
