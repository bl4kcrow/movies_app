import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  MoviesProvider() {
    debugPrint('MoviesProvider init');
    getOnDisplayMovies();
    getPopularMovies();
  }

  final String _apiKey = 'your-api-key';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  int _popularPage = 0;

  Map<int, List<Cast>> moviesCast = {};
  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Future<String> _getJsonData({
    required String endpoint,
    int page = 1,
    Map<String, String>? queryParameters,
  }) async {
    queryParameters ??= {
      'api_key': _apiKey,
      'language': _language,
    };

    queryParameters['page'] = page.toString();

    var url = Uri.https(
      _baseUrl,
      endpoint,
      queryParameters,
    );

    final response = await http.get(url);
    return response.body;
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    var castList = <Cast>[];

    if (moviesCast.containsKey(movieId)) {
      castList = moviesCast[movieId]!;
    } else {
      final jsonData = await _getJsonData(
        endpoint: '3/movie/$movieId/credits',
      );

      final creditsResponse = CreditsResponse.fromJson(jsonData);
      castList = moviesCast[movieId] = creditsResponse.cast;
    }

    return castList;
  }

  void getOnDisplayMovies() async {
    final jsonData = await _getJsonData(endpoint: '3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  void getPopularMovies() async {
    _popularPage++;

    final jsonData = await _getJsonData(
      endpoint: '3/movie/popular',
      page: _popularPage,
    );
    final popularResponse = PopularResponse.fromJson(jsonData);

    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Movie>> searchMovies(String query) async {
    var searchResult = <Movie>[];
    

    final jsonData = await _getJsonData(
      endpoint: '3/search/movie',
      queryParameters: {
        'api_key': _apiKey,
        'query': query,
        'language': _language,
      },
    );

    final searchResponse = SearchMoviesResponse.fromJson(jsonData);
    searchResult = searchResponse.results;

    return searchResult;
  }
}
