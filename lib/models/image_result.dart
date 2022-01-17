class ImageResult {
  final String? source;
  final String title;
  final String linkUrl;
  final String thumbnailUrl;
  final String originalUrl;

  ImageResult({
    required this.source,
    required this.title,
    required this.linkUrl,
    required this.thumbnailUrl,
    required this.originalUrl,
  });

  static ImageResult fromJson(Map<String, dynamic> json) => ImageResult(
        source: json['source'],
        title: json['title'],
        linkUrl: json['link'],
        thumbnailUrl: json['thumbnail'],
        originalUrl: json['original'],
      );

  static List<ImageResult> listFromJson(List<dynamic> json) =>
      json.map((x) => ImageResult.fromJson(x)).toList();
}
