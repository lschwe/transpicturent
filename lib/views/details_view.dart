import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:transpicturent/constants.dart';
import 'package:transpicturent/view_models/details_view_model.dart';

class DetailsView extends StatefulWidget {
  const DetailsView(this.viewModel, {Key? key}) : super(key: key);
  final DetailsViewModel viewModel;

  @override
  _DetailsViewState createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () => print('Save tapped'),
            icon: Icon(
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
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered,
                  imageProvider: NetworkImage(widget.viewModel.imageUrl),
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
                            widget.viewModel.title,
                            style: TextStyle(
                                color: AppColors.brand.shade200,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Source: ${widget.viewModel.source}",
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Colors.white.withOpacity(0.2)),
                      ),
                      onPressed: () => widget.viewModel.onLinkPressed(),
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
