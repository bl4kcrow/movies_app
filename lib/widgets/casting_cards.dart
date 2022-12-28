import 'package:flutter/cupertino.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  const CastingCards({
    super.key,
    required this.movieId,
  });

  final int movieId;

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        if (snapshot.hasData) {
          final castList = snapshot.data;

          return Container(
            height: 180.0,
            margin: const EdgeInsets.only(bottom: 30.0),
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: castList!.length,
              itemBuilder: (_, int index) {
                return _CastCard(
                  name: castList[index].name,
                  profilePath: castList[index].fullProfilePath,
                );
              },
            ),
          );
        } else {
          return const SizedBox(
            height: 180.0,
            width: double.infinity,
            child: CupertinoActivityIndicator(),
          );
        }
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  const _CastCard({
    required this.name,
    this.profilePath,
  });

  final String name;
  final String? profilePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      width: 110.0,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                fit: BoxFit.cover,
                height: 140.0,
                image: NetworkImage(
                  profilePath ?? '',
                ),
                imageErrorBuilder: (_, __, ___) => Image.asset(
                  'assets/images/no-image.jpg',
                  height: 140.0,
                ),
                placeholder: const AssetImage('assets/images/no-image.jpg'),
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
