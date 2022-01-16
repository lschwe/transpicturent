import 'package:rxdart/rxdart.dart';
import 'package:transpicturent/models/image_result.dart';

class SearchService {
  static final SearchService instance = SearchService();
  final searchResults = PublishSubject<List<ImageResult>>();

  String? _lastQuery;
  Future<void> loadSearchResults(String query) async {
    // TODO: Wait a 0.2 seconds before loading results

    _lastQuery = query;
    final currentQuery = query;

    // TODO: Use SearchService to get image results
    await Future.delayed(Duration(seconds: 3));

    // TODO: Handle error messaging

    // TODO: Check that last search query matches with current search
    if (_lastQuery != currentQuery) return;

    // TODO: Update results and notify listeners
    searchResults.add(ImageResult.listFromJson(_dummyResultsJson));
  }
}

const Map<String, dynamic> _dummyResultJson = {
  "position": 1,
  "thumbnail": "https://m.media-amazon.com/images/I/918YNa3bAaL._SL1500_.jpg",
  "source": "amazon.com",
  "title":
      "Amazon.com: Gala Apples Fresh Produce Fruit, 3 LB Bag : Grocery & Gourmet Food",
  "link": "http://www.amazon.com/Gala-Apples-Fresh-Produce-Fruit/dp/B007OC5X40",
  "original": "https://m.media-amazon.com/images/I/918YNa3bAaL._SL1500_.jpg",
  "is_product": true
};

final List<dynamic> _dummyResultsJson = List.filled(20, _dummyResultJson);
