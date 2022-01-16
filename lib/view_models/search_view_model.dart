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
    scrollController.addListener(_onDidScroll);
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

  void onQuerySubmitted(String query) {
    _didSearch = query.isNotEmpty;
    _pageNumber = 0;
    _results = [];
    _isLoading = true;
    notifyListeners();
    SearchService.instance.loadSearchResults(query);
  }

  int _pageNumber = 0;
  void loadMoreResults() async {
    if (!canLoadMore || isLoadingMore) return;

    _isLoadingMore = true;
    notifyListeners();

    _pageNumber++;
    SearchService.instance.loadSearchResults(null, page: _pageNumber);
  }

  String? thumbnailUrlAtIndex(int index) {
    return resultAtIndex(index)?.thumbnailUrl;
  }

  void onResultPressed(int index) {
    print('onResultPressed $index');

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
    hasResults ? _results.addAll(results) : _results = results;
    _didReachEnd = results.length < SearchService.maxResults;
    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
  }

  String? errorMessage;
  bool get showError => errorMessage != null;

  void onLoadError(dynamic error) {
    // TODO: Implement error handling
    final _errorMessage = error.toString();
    hasResults
        ? showLoadMoreError(_errorMessage)
        : errorMessage = _errorMessage;
    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
  }

  void showLoadMoreError(String error) {
    // TODO: Implement loading more error
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

  // MARK: Infinite scrolling implementation

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;
  bool get canLoadMore => _didSearch && !showError && !_didReachEnd;
  final GlobalKey backgroundKey = GlobalKey();
  final GlobalKey infiniteScrollKey = GlobalKey();
  final ScrollController scrollController = ScrollController();
  bool _didReachEnd = false;
  RenderBox? infiniteScrollBox;

  void _onDidScroll() {
    if (infiniteScrollKey.currentContext == null) return;

    if (infiniteScrollBox == null || !(infiniteScrollBox?.attached ?? false)) {
      infiniteScrollBox =
          infiniteScrollKey.currentContext?.findRenderObject() as RenderBox?;
    }

    if (infiniteScrollBox == null) return;

    double infiniteScrollKeyTopOffset =
        infiniteScrollBox!.localToGlobal(Offset.zero).dy;

    if (backgroundBottomOffset != null &&
        infiniteScrollKeyTopOffset < backgroundBottomOffset!) {
      loadMoreResults();
    }
  }

  double? _backgroundBottomOffset;
  double? get backgroundBottomOffset {
    if (_backgroundBottomOffset == null) {
      RenderBox? backgroundBox =
          backgroundKey.currentContext?.findRenderObject() as RenderBox?;
      if (backgroundBox == null) return null;

      final backgroundPosition = backgroundBox.localToGlobal(Offset.zero);
      _backgroundBottomOffset =
          backgroundPosition.dy + backgroundBox.size.height;
    }

    return _backgroundBottomOffset;
  }
}
