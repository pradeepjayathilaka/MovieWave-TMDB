import 'package:flutter/material.dart';
import 'package:moviewave_tmdb/models/movie_models.dart';
import 'package:moviewave_tmdb/service/movies_service.dart';
import 'package:moviewave_tmdb/widgets/movie_details.dart';

class NowPlaiyngPage extends StatefulWidget {
  const NowPlaiyngPage({super.key});

  @override
  State<NowPlaiyngPage> createState() => _MainPageState();
}

class _MainPageState extends State<NowPlaiyngPage> {
  List<Movie> _movies = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isloading = false;

  //Method to fetch the movies
  Future<void> _fetchMovies() async {
    setState(() {
      _isloading = true;
    });
    try {
      await Future.delayed(const Duration(seconds: 1));
      List<Movie> fetchedMovies = await MoviesService().fetchNowPlayingMovies(
        page: _currentPage,
      );
      setState(() {
        _movies = fetchedMovies;
        _totalPages = 100; // Assuming this is the total pages
      });
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  //got to previous page
  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _fetchMovies();
    }
  }

  //go to next page
  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
      });
      _fetchMovies();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Now Playing")),
      body:
          _isloading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _movies.length + 1,
                      itemBuilder: (context, index) {
                        if (index > _movies.length - 1) {
                          return _buildPaginationControls();
                        } else {
                          return MovieDetailsWidget(movie: _movies[index]);
                        }
                      },
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _currentPage > 1 ? _previousPage : null,
          child: const Text("Previous"),
        ),
        const SizedBox(width: 8),
        Text("Page $_currentPage of $_totalPages"),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _currentPage < _totalPages ? _nextPage : null,
          child: const Text("Next"),
        ),
      ],
    );
  }
}
