import 'package:transpicturent/models/image_result.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsViewModel {
  final ImageResult imageResult;
  DetailsViewModel(this.imageResult);

  String get imageUrl => imageResult.originalUrl;
  String get title => imageResult.title;
  String get source => imageResult.source;
  String get linkUrl => imageResult.linkUrl;

  void onLinkPressed() async {
    await launch(linkUrl);
  }
}
