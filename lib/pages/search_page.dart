import 'package:flutter/material.dart';
import 'package:moviewave_tmdb/models/movie_models.dart';
import 'package:moviewave_tmdb/service/movies_service.dart';
import 'package:moviewave_tmdb/widgets/search_details.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _MainPageState();
}

class _MainPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResults = [];
  bool _isLoading = false;
  String _error = "";

  // Method to  search for movies
  Future<void> _searchMovies() async {
    setState(() {
      _isLoading = true;
      _error = "";
    });
    try {
      List<Movie> movies = await MoviesService().searchMovies(
        _searchController.text,
      );
      setState(() {
        _searchResults = movies;
      });
    } catch (error) {
      print("Error: $error");
      setState(() {
        _error = "Error fetching search results $error";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Page")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "Search for movie",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                      onSubmitted: (_) {
                        _searchMovies();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.red[600],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search, size: 30, weight: 10),
                      onPressed: () {
                        _searchMovies();
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(_error, style: const TextStyle(color: Colors.red)),
              )
            else if (_searchResults.isEmpty)
              const Center(child: Text("No movies found. Please Search..."))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SearchDetailsWidget(movie: _searchResults[index]),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
