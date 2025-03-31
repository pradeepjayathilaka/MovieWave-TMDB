import 'package:flutter/material.dart';
import 'package:moviewave_tmdb/models/movie_models.dart';
import 'package:moviewave_tmdb/pages/single_movie_details_page.dart';
import 'package:moviewave_tmdb/service/movies_service.dart';
import 'package:moviewave_tmdb/widgets/movie_details.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Movie> _movies = [];
  int currentPage = 1;
  bool _isloading = false;
  bool _hashasmore = true;

  //this method fetches the upcoming movies from the api and this method is called in the  initstate method

  Future<void> _fetchmovies() async {
    if (_isloading || !_hashasmore) {
      return;
    }
    setState(() {
      _isloading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    try {
      final newmovies = await MoviesService().fetchUpcomingMovies(
        page: currentPage,
      );

      setState(() {
        if (newmovies.isEmpty) {
          _hashasmore = false;
        } else {
          _movies.addAll(newmovies);
          currentPage++;
        }
      });
    } catch (error) {
      print("Error:$error");
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchmovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MovieWave",
          style: TextStyle(fontSize: 24, color: Colors.redAccent),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification Notification) {
          if (!_isloading &&
              Notification.metrics.pixels ==
                  Notification.metrics.maxScrollExtent) {
            _fetchmovies();
          }
          return true;
        },
        child: ListView.builder(
          itemCount: _movies.length + (_isloading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _movies.length) {
              return const Center(child: CircularProgressIndicator());
            }
            ;
            final Movie movie = _movies[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SingleMovieDetailsPage(movie: movie),
                  ),
                );
              },
              child: MovieDetailsWidget(movie: movie),
            );
          },
        ),
      ),
    );
  }
}
