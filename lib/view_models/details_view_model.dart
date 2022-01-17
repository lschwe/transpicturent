import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transpicturent/models/image_result.dart';
import 'package:transpicturent/services/save_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsViewModel {
  final ImageResult imageResult;
  BuildContext? context;
  DetailsViewModel(this.imageResult);

  String get imageUrl => imageResult.originalUrl;
  String get title => imageResult.title;
  String? get source => imageResult.source;
  bool get hasSource => source != null;
  String get linkUrl => imageResult.linkUrl;

  void onLinkPressed() async {
    await launch(linkUrl);
  }

  onSavePressed() async {
    if (context == null) return;
    SaveService.saveImage(context!, imageUrl);
  }
}
