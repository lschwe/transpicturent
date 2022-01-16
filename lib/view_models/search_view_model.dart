import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transpicturent/models/image_result.dart';
import 'package:transpicturent/services/search_service.dart';

class SearchViewModel extends ChangeNotifier {
  SearchViewModel() {
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

    print('onQueryChanged $query');
    SearchService.instance.loadSearchResults(query);
  }

  List<ImageResult> _results = [];
  int get resultsCount => _results.length;
  bool get hasResults => resultsCount > 0;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _didSearch = false;
  bool get didSearch => _didSearch;

  String? thumbnailUrlAtIndex(int index) {
    if (resultsCount > index) return _results[index].thumbnailUrl;
    return null;
  }

  void onResultPressed(int index) {
    print('onResultPressed $index');
    // TODO: push navigator to detail view controller
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
}
