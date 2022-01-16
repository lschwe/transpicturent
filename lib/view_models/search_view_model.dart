import 'package:flutter/material.dart';
import 'package:transpicturent/models/image_result.dart';
import 'package:transpicturent/services/search_service.dart';
import 'package:transpicturent/view_models/details_view_model.dart';
import 'package:transpicturent/views/details_view.dart';

class SearchViewModel extends ChangeNotifier {
  final BuildContext context;
  SearchViewModel(this.context) {
    SearchService.instance.searchResults.listen(
      onLoadResults,
      onError: onLoadError,
    );
  }

  String? errorMessage;
  bool get showError => errorMessage != null;

  void onQueryChanged(String query) {
    _isLoading = true;
    notifyListeners();
    SearchService.instance.loadSearchResults(query);
  }

  List<ImageResult> _results = [];
  int get resultsCount => _results.length;
  bool get hasResults => resultsCount > 0;
  ImageResult? resultAtIndex(int index) =>
      resultsCount > index ? _results[index] : null;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _didSearch = false;
  bool get didSearch => _didSearch;

  String? thumbnailUrlAtIndex(int index) {
    return resultAtIndex(index)?.thumbnailUrl;
  }

  void onResultPressed(int index) {
    print('onResultPressed $index');
    // TODO: push navigator to detail view controller
    final imageResult = resultAtIndex(index);
    if (imageResult == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailsView(
          DetailsViewModel(imageResult),
        ),
      ),
    );
  }

  void onLoadResults(List<ImageResult> results) {
    _results = results;
    _isLoading = false;
    _didSearch = true;
    notifyListeners();
  }

  void onLoadError(dynamic error) {
    // TODO: Implement error handling
    errorMessage = error.toString();
    _isLoading = false;
    notifyListeners();
  }

  bool _showCancelButton = false;
  bool get showCancelButton => _showCancelButton;

  void onSearchFieldFocusChanged(bool hasFocus) {
    print('onSearchFieldFocusChanged $hasFocus');
    if (hasFocus == _showCancelButton) return;
    _showCancelButton = hasFocus;
    notifyListeners();
  }

  void onCancelButtonPressed() {
    print('onCancelButtonPressed');
    FocusScope.of(context).unfocus();
  }

  // TODO: Implement infinite scrolling
}
