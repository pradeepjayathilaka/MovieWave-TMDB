import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:moviewave_tmdb/models/movie_models.dart';

class MoviesService {
  //get the api key from .env
  final String _api_key = dotenv.env["TMDB_DATABASE_API_KEY"] ?? "";
  final String _base_url = "https://api.themoviedb.org/3";

  //fetch the movies from the api
  Future<List<Movie>> fetchUpcomingMovies({int page = 1}) async {
    try {
      final String url =
          "$_base_url/movie/upcoming?api_key=$_api_key&page=$page";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data["results"];
        return results.map((movieData) => Movie.fromjson(movieData)).toList();
      } else {
        throw Exception("Failed to load movies");
      }
    } catch (error) {
      print("Error fetching upcoming movies: $error");
      return [];
    }
  }

  //fetch all now playing  movies
  Future<List<Movie>> fetchNowPlayingMovies({int page = 1}) async {
    try {
      final String url =
          "$_base_url/movie/now_playing?api_key=$_api_key&page=$page";
      final Responce = await http.get(Uri.parse(url));
      if (Responce.statusCode == 200) {
        final data = json.decode(Responce.body);
        final List<dynamic> results = data["results"];
        return results.map((movieData) => Movie.fromjson(movieData)).toList();
      } else {
        throw Exception("Failed to load movies");
      }
    } catch (error) {
      print("Error fetching now playing movies: $error");
      return [];
    }
  }
  //search movie by query

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final String url =
          "$_base_url/search/movie?query=$query&api_key=$_api_key";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data["results"];
        return results.map((movieData) => Movie.fromjson(movieData)).toList();
      } else {
        throw Exception("Failed to search movies");
      }
    } catch (error) {
      print("Error searching movies: $error");
      throw Exception("Failed to search movies:$error");
    }
  }
  //similar Movies

  Future<List<Movie>> fetchSimilarMovies(int MoviedID) async {
    try {
      final responce = await http.get(
        Uri.parse(
          "https://api.themoviedb.org/3/movie/$MoviedID/similar?api_key=$_api_key",
        ),
      );
      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> results = data["results"];

        return results.map((movieData) => Movie.fromjson(movieData)).toList();
      } else {
        throw Exception("Failed to fetch Similar movies");
      }
    } catch (error) {
      print("Failed to fetch Similar movies: $error");
      return [];
    }
  }

  //recommended movies
  Future<List<Movie>> fetchRecommendedMovies(int MoviedID) async {
    try {
      final responce = await http.get(
        Uri.parse(
          "https://api.themoviedb.org/3/movie/$MoviedID/recommendations?api_key=$_api_key",
        ),
      );
      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> results = data["results"];

        return results.map((movieData) => Movie.fromjson(movieData)).toList();
      } else {
        throw Exception("Failed to fetch recommended movies");
      }
    } catch (error) {
      print("Failed to fetch recommended movies: $error");
      return [];
    }
  }

  //fetch by the movieid

  Future<List<String>> fetchImageFromMovied(int MovieId) async {
    try {
      final _responce = await http.get(
        Uri.parse(
          "https://api.themoviedb.org/3/movie/$MovieId/images?api_key=$_api_key",
        ),
      );
      if (_responce.statusCode == 200) {
        final data = json.decode(_responce.body);
        final List<dynamic> backdrops = data["backdrops"];

        // Extract file paths and return the first 10 images
        return backdrops
            .take(10)
            .map(
              (imageData) =>
                  "https://image.tmdb.org/t/p/w500${imageData["file_path"]}",
            )
            .toList();
      } else {
        throw Exception("Failed to fetch images");
      }
    } catch (error) {
      print("Error fetching image: $error");
      return [];
    }
  }
}
