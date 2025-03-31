import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:moviewave_tmdb/models/tv_show_models.dart';

class TvShowsService {
  final String _apikey = dotenv.env["TMDB_DATABASE_API_KEY"] ?? "";
  Future<List<TvShow>> fetchTvShows() async {
    try {
      //base url
      final String BaseUrl = "https://api.themoviedb.org/3/tv";
      //popular tv shows
      final popularResponce = await http.get(
        Uri.parse("$BaseUrl/popular?api_key=$_apikey"),
      );
      //airing today tv shows
      final airingTodayResponce = await http.get(
        Uri.parse("$BaseUrl/airing_today?api_key=$_apikey"),
      );
      //top rated tv shows
      final topRatedResponce = await http.get(
        Uri.parse("$BaseUrl/top_rated?api_key=$_apikey"),
      );
      if (popularResponce.statusCode == 200 &&
          airingTodayResponce.statusCode == 200 &&
          topRatedResponce.statusCode == 200) {
        final popularData = json.decode(popularResponce.body);
        final AiringData = json.decode(airingTodayResponce.body);
        final topRatedData = json.decode(topRatedResponce.body);

        final List<dynamic> popularResults = popularData["results"];
        final List<dynamic> airingResults = AiringData["results"];
        final List<dynamic> topRatedResults = topRatedData["results"];

        List<TvShow> tvShows = [];
        tvShows.addAll(
          popularResults.map((tvData) => TvShow.fromJson(tvData)).take(10),
        );
        tvShows.addAll(
          airingResults.map((tvData) => TvShow.fromJson(tvData)).take(10),
        );
        tvShows.addAll(
          topRatedResults.map((tvData) => TvShow.fromJson(tvData)).take(10),
        );
        return tvShows;
      } else {
        throw Exception("Failed to load Tv shows");
      }
    } catch (error) {
      print("Error fetching tv shows:$error");
      return [];
    }
  }
}
