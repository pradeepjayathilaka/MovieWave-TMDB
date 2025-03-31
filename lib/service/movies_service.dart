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
}
