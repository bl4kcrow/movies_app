import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';

class CardSwipper extends StatelessWidget {
  const CardSwipper({
    Key? key,
    required this.movies,
  }) : super(key: key);

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.5,
      width: double.infinity,
      child: Swiper(
        itemCount: movies.length,
        itemHeight: size.height * 0.4,
        itemWidth: size.width * 0.6,
        layout: SwiperLayout.STACK,
        itemBuilder: (_, int index) {
          final movie = movies[index];
          movie.heroId = 'swipper-${movie.id}';

          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              'details',
              arguments: movie,
            ),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(movie.fullPosterImage ?? ''),
                  imageErrorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/no-image.jpg',
                    fit: BoxFit.cover,
                  ),
                  placeholder: const AssetImage('assets/images/no-image.jpg'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
