import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:transpicturent/constants.dart';
import 'package:transpicturent/models/image_result.dart';

class SearchService {
  static final SearchService instance = SearchService();
  static const int maxResults = 100;
  final searchResults = PublishSubject<List<ImageResult>>();

  String? _lastQuery;
  int? _lastPage;

  Future<void> loadSearchResults(String? query, {int page = 0}) async {
    query != null ? _lastQuery = query : query = _lastQuery;
    _lastPage = page;

    if (query?.isEmpty ?? true) return searchResults.add([]);

    dynamic error;
    List<ImageResult> results = [];
    try {
      results = await fetchImages(query!, page);
    } catch (e) {
      error = e;
    }

    // Check this is the last executed search
    if (_lastQuery != query || _lastPage != page) return;

    error == null ? searchResults.add(results) : searchResults.addError(error);
  }

  Future<List<ImageResult>> fetchImages(String query, int page) async {
    final response = await http.get(buildApiUrl(query, page));
    print('response.statusCode ${response.statusCode}');

    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
      print('body $body');
    } catch (e) {
      throw genericError;
    }

    if (response.statusCode != 200) {
      throw body.containsKey('error') ? body['error'] : genericError;
    }

    print(
        'body[images_results].length ${(body['images_results'] as List).length}');
    return ImageResult.listFromJson(body['images_results']);
  }

  Uri buildApiUrl(String query, int page) => Uri.https(
        'serpapi.com',
        '/search.json',
        {
          'q': query,
          'tbm': 'isch',
          'ijn': page,
          'api_key': SecretKeys.serpApiKey,
        }.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

  static const String genericError =
      'Failed to fetch images. Please try again.';
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
