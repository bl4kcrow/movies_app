import 'package:flutter/material.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:movies_app/search/movie_search_delegate.dart';
import 'package:movies_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies TMDB'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search_outlined,
            ),
            onPressed: () => showSearch(
              context: context,
              delegate: MovieSearchDelegate(),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwipper(
              movies: moviesProvider.onDisplayMovies,
            ),
            MovieSlider(
              onNextPage: () => moviesProvider.getPopularMovies(),
              movies: moviesProvider.popularMovies,
              title: 'Populares',
            ),
          ],
        ),
      ),
    );
  }
}
