//***************************** home_page_movies.dart *********************

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

typedef FavoriteMovies<Movies> = void Function(Movies movie);

class HomePageVids extends StatefulWidget {
  final String selectedSort;
  final FavoriteMovies onFavorite;

  const HomePageVids({
    super.key,
    required this.selectedSort,
    required this.onFavorite,
  });

  @override
  State<HomePageVids> createState() => _HomePageVidsState();
}

class _HomePageVidsState extends State<HomePageVids> {
  late List<Movie> movies;
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HomePageVids oldWidget) {
    if (oldWidget.selectedSort != widget.selectedSort) {
      fetchData();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchMoreData();
    }
  }

  Future<void> fetchData() async {
    var url = Uri.parse('https://ott-details.p.rapidapi.com/advancedsearch');
    var queryParams = {
      'start_year': '1970',
      'end_year': '2023',
      'min_imdb': '6',
      'max_imdb': '10',
      'genre': 'action',
      'language': 'english',
      'type': 'movie',
      'page': '1',
    };

    if (widget.selectedSort == 'Years') {
      queryParams['sort'] = 'latest';
    } else if (widget.selectedSort == 'Rating') {
      queryParams['sort'] = 'highestrated';
    }

    var headers = {
      'X-RapidAPI-Key': 'a4a16e8045mshe91253efaf14385p19dc85jsne4f99a38c933',
      'X-RapidAPI-Host': 'ott-details.p.rapidapi.com'
    };

    try {
      var response = await http.get(url.replace(queryParameters: queryParams),
          headers: headers);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        setState(() {
          movies = (responseData['results'] as List)
              .map((movieJson) => Movie.fromJson(movieJson))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = true;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = true;
      });
    }
  }

  Future<void> fetchMoreData() async {
    setState(() {
      isLoading = true;
    });

    var nextPage = (movies.length / 50) + 1;
    var url = Uri.parse('https://ott-details.p.rapidapi.com/advancedsearch');
    var queryParams = {
      'start_year': '1970',
      'end_year': '2023',
      'min_imdb': '6',
      'max_imdb': '10',
      'genre': 'action',
      'language': 'english',
      'type': 'movie',
      'page': nextPage.toString(),
    };

    if (widget.selectedSort == 'Years') {
      queryParams['sort'] = 'latest';
    } else if (widget.selectedSort == 'Rating') {
      queryParams['sort'] = 'highestrated';
    }

    var headers = {
      'X-RapidAPI-Key': 'a4a16e8045mshe91253efaf14385p19dc85jsne4f99a38c933',
      'X-RapidAPI-Host': 'ott-details.p.rapidapi.com'
    };

    try {
      var response = await http.get(url.replace(queryParameters: queryParams),
          headers: headers);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        setState(() {
          movies.addAll((responseData['results'] as List)
              .map((movieJson) => Movie.fromJson(movieJson))
              .toList());
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                const SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
              ],
            ),
          )
        : movies.isEmpty
            ? const Center(
                child: Text('No movies found'),
              )
            : Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final movie = movies[index];
                            return Container(
                              padding: const EdgeInsets.all(10.0),
                              height: 300,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 250,
                                    height: double.infinity,
                                    child: Image.network(
                                      movie.imageUrl.first,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                movie.title,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Released: ${movie.released}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          'IMDB Rating: ${movie.imdbRating}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              movie.toggleFavorite();
                                              widget.onFavorite(movie);
                                            });
                                          },
                                          icon: Icon(
                                            movie.isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: movie.isFavorite
                                                ? Colors.red
                                                : null,
                                          ),
                                          iconSize: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: movies.length,
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }
}

class Movie {
  final String imdbId;
  final List<String> imageUrl;
  final String title;
  final int released;
  final double imdbRating;
  bool isFavorite;

  Movie({
    required this.imdbId,
    required this.imageUrl,
    required this.title,
    required this.released,
    required this.imdbRating,
    this.isFavorite = false,
  });
  factory Movie.fromJson(Map<String, dynamic> json) {
    var imageUrl = json['imageurl'] != null && json['imageurl'].isNotEmpty
        ? List<String>.from(json['imageurl'])
        : [
            'https://toppng.com/uploads/preview/movie-moviemaker-film-cut-svg-png-icon-free-download-movie-icon-11563265487xzdashbdvx.png'
          ];
    return Movie(
      imdbId: json['imdbid'],
      imageUrl: imageUrl,
      title: json['title'] ?? '',
      released: json['released'] ?? 0,
      imdbRating: json['imdbrating'] != null
          ? double.tryParse(json['imdbrating'].toString()) ?? 0.0
          : 0.0,
    );
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}

class SearchMovie {
  final String imdbID;
  final String title;
  final String year;
  final String poster;
  final String imdbRating;

  SearchMovie({
    required this.title,
    required this.imdbID,
    required this.year,
    required this.poster,
    required this.imdbRating,
  });

  factory SearchMovie.fromJson(Map<String, dynamic> json) {
    return SearchMovie(
      imdbID: json['imdbID'],
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      poster: json['Poster'] ?? '',
      imdbRating: json['imdbRating'] ?? '',
    );
  }
}
