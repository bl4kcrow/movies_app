import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)?.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(
            backdropPath: movie.fullBackdropPath,
            title: movie.title,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _PosterAndTitle(
                  heroId: movie.heroId!,
                  originalTitle: movie.originalTitle,
                  posterPath: movie.fullPosterImage,
                  title: movie.title,
                  voteAverage: movie.voteAverage.toString(),
                ),
                _Overview(
                  text: movie.overview,
                ),
                CastingCards(
                  movieId: movie.id,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({
    this.backdropPath,
    required this.title,
  });

  final String? backdropPath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: FadeInImage(
          fit: BoxFit.cover,
          image: NetworkImage(backdropPath ?? ''),
          imageErrorBuilder: (_, __, ___) => Image.asset(
            'assets/images/no-image.jpg',
            fit: BoxFit.cover,
          ),
          placeholder: const AssetImage('assets/images/loading.gif'),
        ),
        centerTitle: true,
        title: Container(
          alignment: Alignment.bottomCenter,
          color: Colors.black26,
          padding: const EdgeInsets.only(
            bottom: 10.0,
            left: 10.0,
            right: 10.0,
          ),
          width: double.infinity,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        titlePadding: EdgeInsets.zero,
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  const _PosterAndTitle({
    required this.heroId,
    required this.originalTitle,
    this.posterPath,
    required this.title,
    required this.voteAverage,
  });

  final String heroId;
  final String originalTitle;
  final String? posterPath;
  final String title;
  final String voteAverage;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Hero(
            tag: heroId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(posterPath ?? ''),
                imageErrorBuilder: (_, __, ___) => Image.asset(
                  'assets/images/no-image.jpg',
                  fit: BoxFit.cover,
                ),
                height: 150.0,
                placeholder: const AssetImage('assets/images/no-image.jpg'),
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  originalTitle,
                  style: textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star_outline,
                      size: 15.0,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      voteAverage,
                      style: textTheme.caption,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10.0,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
