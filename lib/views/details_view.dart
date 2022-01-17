import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:transpicturent/constants.dart';
import 'package:transpicturent/view_models/details_view_model.dart';

class DetailsView extends StatelessWidget {
  const DetailsView(this.viewModel, {Key? key}) : super(key: key);
  final DetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel.context = context;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () => viewModel.onSavePressed(),
            icon: const Icon(
              Icons.save_alt_rounded,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRect(
                child: PhotoView(
                  initialScale: PhotoViewComputedScale.contained,
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered,
                  imageProvider: NetworkImage(viewModel.imageUrl),
                  loadingBuilder: (context, event) {
                    if (event == null) return Container();
                    return Center(
                      child: CircularProgressIndicator(
                        value: event.expectedTotalBytes != null
                            ? event.cumulativeBytesLoaded /
                                event.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            viewModel.title,
                            style: TextStyle(
                                color: AppColors.primary.shade200,
                                fontWeight: FontWeight.bold),
                          ),
                          ...(viewModel.hasSource
                              ? [
                                  const SizedBox(height: 2),
                                  Text(
                                    "Source: ${viewModel.source}",
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                ]
                              : []),
                        ],
                      ),
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Colors.white.withOpacity(0.2)),
                      ),
                      onPressed: () => viewModel.onLinkPressed(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
