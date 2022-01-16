import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:transpicturent/model/image_result.dart';

class SearchViewModel extends ChangeNotifier {
  String? _lastSearchQuery;

  List<ImageResult> _searchResults = [];
  UnmodifiableListView<ImageResult> get searchResults =>
      UnmodifiableListView(_searchResults);

  // TODO: Implement error handling
  bool get showError => false;
  String get errorMessage => '';

  void didChangeQuery(String searchQuery) {
    _lastSearchQuery = searchQuery;
    final currentSearch = searchQuery;

    // TODO: Use SearchService to get image results

    // TODO: Check that last search query matches with current search
    if (_lastSearchQuery != currentSearch) return;

    // TODO: Update results and notify listeners
  }
}
