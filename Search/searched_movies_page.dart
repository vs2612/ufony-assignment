// *****************************  searched_movies_page.dart **********************


import 'package:flutter/material.dart';
import 'package:movie_app/HomePage/home_page_movies.dart';


class SearchedMoviesPage extends StatelessWidget {
  final List<SearchMovie> searchResults;

  const SearchedMoviesPage({Key? key, required this.searchResults})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          var movie = searchResults[index];
          return Container(
            padding:const EdgeInsets.all(10.0),
            height: 350,
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  height: double.infinity,
                  child: movie.poster != 'N/A'
                      ? Image.network(
                          movie.poster,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey,
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
                        style:const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Year: ${movie.year}',
                        style:const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'IMDb Rating: ${movie.imdbRating}',
                        style:const TextStyle(fontSize: 16),
                      ),
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
