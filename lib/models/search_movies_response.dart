import 'dart:convert';

import 'package:movies_app/models/models.dart';

class SearchMoviesResponse {
  SearchMoviesResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  factory SearchMoviesResponse.fromJson(String str) =>
      SearchMoviesResponse.fromMap(json.decode(str));

  factory SearchMoviesResponse.fromMap(Map<String, dynamic> json) =>
      SearchMoviesResponse(
        page: json['page'] ?? 0,
        results: List<Movie>.from(json['results'].map((x) => Movie.fromMap(x))),
        totalPages: json['total_pages'],
        totalResults: json['total_results'],
      );
}
