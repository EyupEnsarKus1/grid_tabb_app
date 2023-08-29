class DataModel {
  final String? id;
  final String? url;
  final int? width;
  final int? height;

  DataModel({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
  });
  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json["id"],
      url: json["url"],
      width: json["width"],
      height: json["height"],
    );
  }
}
