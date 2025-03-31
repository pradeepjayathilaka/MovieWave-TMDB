import 'package:flutter/material.dart';
import 'package:moviewave_tmdb/models/movie_models.dart';
import 'package:moviewave_tmdb/service/movies_service.dart';
import 'package:moviewave_tmdb/widgets/search_details.dart';

class SingleMovieDetailsPage extends StatefulWidget {
  Movie movie;
  SingleMovieDetailsPage({super.key, required this.movie});

  @override
  State<SingleMovieDetailsPage> createState() => _SingleMovieDetailsPageState();
}

class _SingleMovieDetailsPageState extends State<SingleMovieDetailsPage> {
  List<Movie> _similarMovie = [];
  List<Movie> _recommendedMovies = [];
  List<String> _movieImages = [];

  bool _isLoadingSimilar = true;
  bool _isLoadingRecommende = true;
  bool _isLoadingImage = true;

  //fetch similar movies
  Future<void> _fetchSimilarMovies() async {
    try {
      List<Movie> fetchMovies = await MoviesService().fetchSimilarMovies(
        widget.movie.id,
      );
      setState(() {
        _similarMovie = fetchMovies;
        _isLoadingSimilar = false;
      });
    } catch (error) {
      print("Error from Similar :$error");
      setState(() {
        _isLoadingSimilar = false;
      });
    }
  }

  //fetch recommended movies
  Future<void> _fetchRecommendedMovies() async {
    try {
      List<Movie> fetchRecommended = await MoviesService()
          .fetchRecommendedMovies(widget.movie.id);
      setState(() {
        _recommendedMovies = fetchRecommended;
        _isLoadingRecommende = false;
      });
    } catch (error) {
      print("Error from Similar :$error");
      setState(() {
        _isLoadingRecommende = false;
      });
    }
  }

  //fetch movie images
  Future<void> _fetchMovieImage() async {
    try {
      List<String> fetchImages = await MoviesService().fetchImageFromMovied(
        widget.movie.id,
      );
      setState(() {
        _movieImages = fetchImages;
        _isLoadingImage = false;
      });
    } catch (error) {
      print("Error from Similar :$error");
      setState(() {
        _isLoadingImage = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSimilarMovies();
    _fetchRecommendedMovies();
    _fetchMovieImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchDetailsWidget(movie: widget.movie),
              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Movie Images",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _buildImageSection(),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Similar Movies",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _buildMovieSection(_similarMovie, _isLoadingSimilar),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "REcommended Movies",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _buildMovieSection(_recommendedMovies, _isLoadingRecommende),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    if (_isLoadingImage) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_movieImages.isEmpty) {
      return const Center(child: Text("No Image found"));
    }
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _movieImages.length,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            margin: const EdgeInsets.all(4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(_movieImages[index], fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieSection(List<Movie> movies, bool isLoading) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (movies.isEmpty) {
      return const Center(child: Text('No movies found.'));
    }
    return SizedBox(
      height: 200, // Height for horizontal list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                widget.movie = movies[index];
                //fetch the images and the similar movies for the selected movie
                _fetchMovieImage();
                _fetchSimilarMovies();
                _fetchRecommendedMovies();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(2),
              ),
              margin: const EdgeInsets.all(4.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (movies[index].posterPath != null)
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movies[index].posterPath}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 100,
                      child: Text(
                        movies[index].title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Text(
                      'Average Vote: ${movies[index].voteAverage}',
                      style: TextStyle(fontSize: 7, color: Colors.red[600]),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
