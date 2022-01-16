import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:transpicturent/models/image_result.dart';

class SearchService {
  static final SearchService instance = SearchService();
  static const maxResults = 30;
  final searchResults = PublishSubject<List<ImageResult>>();

  String? _lastQuery;
  int? _lastPage;

  Future<void> loadSearchResults(String? query, {int page = 0}) async {
    query != null ? _lastQuery = query : query = _lastQuery;
    _lastPage = page;

    // TODO: Use SearchService to get image results
    if (query?.isEmpty ?? true) return searchResults.add([]);

    dynamic error;
    List<ImageResult> results = [];

    try {
      results = await fetchImages(query!, page);
    } catch (e) {
      error = e;
    }

    // Check that last search query matches with current search
    if (_lastQuery != query || _lastPage != page) return;

    // TODO: Handle error messaging
    if (error != null) return searchResults.addError(error);

    // TODO: Update results and notify listeners
    searchResults.add(results);
  }

  Future<List<ImageResult>> fetchImages(String query, int page) async {
    await Future.delayed(Duration(seconds: 3));
    return ImageResult.listFromJson(_dummyResultsJson);
  }
}

const Map<String, dynamic> _dummyResultJson = {
  "position": 1,
  "thumbnail":
      "https://ggsc.s3.amazonaws.com/images/made/images/uploads/The_Science-Backed_Benefits_of_Being_a_Dog_Owner_600_400_int_c1-2x.jpg",
  "source": "amazon.com",
  "title":
      "Amazon.com: Gala Apples Fresh Produce Fruit, 3 LB Bag : Grocery & Gourmet Food",
  "link":
      "https://www.amazon.com/Gala-Apples-Fresh-Produce-Fruit/dp/B007OC5X40",
  "original":
      "https://ggsc.s3.amazonaws.com/images/made/images/uploads/The_Science-Backed_Benefits_of_Being_a_Dog_Owner_600_400_int_c1-2x.jpg",
  "is_product": true
};

final List<dynamic> _dummyResultsJson =
    List.filled(SearchService.maxResults, _dummyResultJson);
