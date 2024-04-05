// *********************** fav_movies_page.dart ******************



import 'package:flutter/material.dart';
import '../HomePage/home_page_movies.dart';

class FavoriteMoviesPage extends StatelessWidget {
  final List<Movie> favoriteMovies;

  const FavoriteMoviesPage({Key? key, required this.favoriteMovies})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
      ),
      body: ListView.builder(
        itemCount: favoriteMovies.length,
        itemBuilder: (context, index) {
          final movie = favoriteMovies[index];
          return Container(
            padding: const EdgeInsets.all(10.0),
            height: 350,
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  height: double.infinity,
                  child: Image.network(
                    movie.imageUrl.first,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                          style:const TextStyle(fontSize: 16),
                          'Released: ${movie.released}'),
                      Text(
                          style:const TextStyle(fontSize: 16),
                          'IMDB Rating: ${movie.imdbRating}'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
