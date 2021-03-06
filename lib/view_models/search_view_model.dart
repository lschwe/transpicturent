import 'package:flutter/material.dart';
import 'package:transpicturent/models/image_result.dart';
import 'package:transpicturent/services/search_service.dart';
import 'package:transpicturent/view_models/details_view_model.dart';
import 'package:transpicturent/views/details_view.dart';

class SearchViewModel extends ChangeNotifier {
  final BuildContext context;
  SearchViewModel(this.context) {
    SearchService.instance.searchResults.listen(
      _onLoadResults,
      onError: _onLoadError,
    );
    scrollController.addListener(_onDidScroll);
  }

  List<ImageResult> _results = [];
  int get resultsCount => _results.length;
  bool get hasResults => resultsCount > 0;
  ImageResult? _resultAtIndex(int index) =>
      resultsCount > index ? _results[index] : null;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _didSearch = false;
  bool get didSearch => _didSearch;

  void onQuerySubmitted(String query) {
    final _trimmedQuery = query.trim();
    _didSearch = _trimmedQuery.isNotEmpty;
    _pageNumber = 0;
    _results = [];
    _isLoading = true;
    notifyListeners();
    SearchService.instance.loadSearchResults(_trimmedQuery);
  }

  int _pageNumber = 0;
  void _loadMoreResults() async {
    if (!canLoadMore || isLoadingMore) return;

    _isLoadingMore = true;
    notifyListeners();

    _pageNumber++;
    SearchService.instance.loadSearchResults(null, page: _pageNumber);
  }

  String? thumbnailUrlAtIndex(int index) {
    return _resultAtIndex(index)?.thumbnailUrl;
  }

  void onResultPressed(int index) {
    final imageResult = _resultAtIndex(index);
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

  void _onLoadResults(List<ImageResult> results) {
    hasResults ? _results.addAll(results) : _results = results;
    _didReachEnd = results.length < SearchService.maxResults;
    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
  }

  String? errorMessage;
  bool get showError => errorMessage != null;

  void _onLoadError(dynamic error) {
    final _errorMessage = error.toString();
    hasResults
        ? showLoadMoreError(_errorMessage)
        : errorMessage = _errorMessage;
    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
  }

  void showLoadMoreError(String error) {
    final ScaffoldMessengerState? _scaffoldState =
        ScaffoldMessenger.of(context);
    _scaffoldState?.hideCurrentSnackBar();
    _scaffoldState?.showSnackBar(SnackBar(
      content: GestureDetector(
        child: Text(error),
        onTap: _scaffoldState.hideCurrentSnackBar,
      ),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 5),
    ));
  }

  bool _showCancelButton = false;
  bool get showCancelButton => _showCancelButton;

  void onSearchFieldFocusChanged(bool hasFocus) {
    if (hasFocus == _showCancelButton) return;
    _showCancelButton = hasFocus;
    notifyListeners();
  }

  void onCancelButtonPressed() {
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
      _loadMoreResults();
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
