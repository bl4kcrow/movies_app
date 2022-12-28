import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movies_app/helpers/debouncer.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  
  final _debouncer = Debouncer(milliseconds: 500);

  Widget _emptyContainer() {
    return const Center(
      child: Icon(
        Icons.movie_creation_outlined,
        color: Colors.black38,
        size: 130.0,
      ),
    );
  }

  Widget _movieItem(
    BuildContext context,
    Movie movie,
  ) {
    movie.heroId = 'search-${movie.id}';

    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          fit: BoxFit.contain,
          image: NetworkImage(movie.fullPosterImage ?? ''),
          imageErrorBuilder: (_, __, ___) => Image.asset(
            'assets/images/no-image.jpg',
            fit: BoxFit.contain,
          ),
          placeholder: const AssetImage('assets/images/no-image.jpg'),
          width: 50.0,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () => Navigator.pushNamed(
        context,
        'details',
        arguments: movie,
      ),
    );
  }

  @override
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(
          Icons.clear,
        ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(
        Icons.arrow_back,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return const Center(
      child: Text('Result'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(
      context,
      listen: false,
    );

    final completer = Completer<List<Movie>>();

    _debouncer.run(() async {
      completer.complete(await moviesProvider.searchMovies(query));
    });

    return FutureBuilder(
      future: completer.future,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        late Widget widgetResult;
        if (snapshot.hasData) {
          final movies = snapshot.data!;
          widgetResult = ListView.builder(
            itemCount: movies.length,
            itemBuilder: (_, int index) {
              return _movieItem(
                context,
                movies[index],
              );
            },
          );
        } else {
          widgetResult = _emptyContainer();
        }
        return widgetResult;
      },
    );
  }
}
