// *************************** home_page.dart *********************
import 'package:flutter/material.dart';
import 'home_page_movies.dart';
import '../FavoriteMovies/fav_movies_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Search/searched_movies_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedSort;
  final List<String> list = ['Years', 'Rating'];
  List<Movie> favoriteMovies = [];
 final _searchController = TextEditingController();
  List<SearchMovie> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _selectedSort = 'Years';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.grey),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              prefixIcon: IconButton(
                icon:const Icon(Icons.search),
                onPressed: _search,
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FavoriteMoviesPage(favoriteMovies: favoriteMovies),
                ),
              );
            },
            icon:const Icon(Icons.favorite),
            label:const Text('Favorites'),
          ),
         const SizedBox(width: 8),
          DropdownButton<String>(
            value: _selectedSort,
            onChanged: (String? newValue) {
              setState(() {
                _selectedSort = newValue;
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            underline: Container(),
          ),
        const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              HomePageVids(
                selectedSort: _selectedSort!,
                onFavorite: (movie) {
                  setState(() {
                    if (movie.isFavorite) {
                      favoriteMovies.add(movie);
                     
                    } else {
                      favoriteMovies.removeWhere(
                          (element) => element.imdbId == movie.imdbId);
                    
                    }
                  });
                },
              ),
            ]),
          )
        ],
      ),
    );
  }

  void _search() async {
    String query = _searchController.text.trim();
    try {
      final response = await http.get(
        Uri.parse('http://www.omdbapi.com/?apikey=b9d43b38&t=$query'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
          
        if (jsonData['Response'] == 'True') {
          setState(() {
            _searchResults.add(SearchMovie.fromJson(jsonData));
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SearchedMoviesPage(searchResults: _searchResults),
            ),
          );
        } else {
          setState(() {
            _searchResults = [];
          });
        }
      } 
    } catch (e) {
      setState(() {
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}
