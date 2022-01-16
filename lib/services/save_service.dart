import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

class SaveService {
  static saveImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return FutureBuilder<bool?>(
          builder: (context, snapshot) {
            final title = Text(!snapshot.hasData
                ? 'Saving...'
                : snapshot.data ?? false
                    ? 'Saved Successfully'
                    : 'Failed to Save');
            void onOkPressed() => Navigator.pop(context);

            if (Platform.isIOS) {
              return CupertinoAlertDialog(
                title: title,
                actions: snapshot.hasData
                    ? [
                        CupertinoDialogAction(
                          onPressed: onOkPressed,
                          child: const Text('OK'),
                        )
                      ]
                    : [],
              );
            }

            return AlertDialog(
              title: title,
              actions: snapshot.hasData
                  ? [
                      TextButton(
                        onPressed: onOkPressed,
                        child: const Text('OK'),
                      )
                    ]
                  : [],
            );
          },
          future: GallerySaver.saveImage(imageUrl),
        );
      },
    );
  }
}
