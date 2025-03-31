import 'package:flutter/material.dart';
import 'package:moviewave_tmdb/models/tv_show_models.dart';
import 'package:moviewave_tmdb/service/tv_shows_service.dart';
import 'package:moviewave_tmdb/widgets/tv_show_widget.dart';

class TvShowsPage extends StatefulWidget {
  const TvShowsPage({super.key});

  @override
  State<TvShowsPage> createState() => _MainPageState();
}

class _MainPageState extends State<TvShowsPage> {
  List<TvShow> _tvShows = [];
  bool _isLoading = true;
  String _error = "";

  //Fetch tv shows
  Future<void> _fetchTvShows() async {
    try {
      List<TvShow> tvShows = await TvShowsService().fetchTvShows();

      setState(() {
        _tvShows = tvShows;
        _isLoading = false;
      });
    } catch (error) {
      print("=Error:$error");
      setState(() {
        _error = "Failed to load  tv shows $error";
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchTvShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TV shows")),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error.isNotEmpty
              ? Center(child: Text(_error))
              : ListView.builder(
                itemCount: _tvShows.length,
                itemBuilder: (context, index) {
                  return TvShowWidget(tvShow: _tvShows[index]);
                },
              ),
    );
  }
}
