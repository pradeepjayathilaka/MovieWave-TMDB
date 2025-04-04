import 'package:flutter/material.dart';
import 'package:moviewave_tmdb/models/movie_models.dart';

class MovieDetailsWidget extends StatelessWidget {
  final Movie movie;
  const MovieDetailsWidget({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey.shade900),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "https://image.tmdb.org/t/p/w500/${movie.posterPath}",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Text(
              movie.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              "Release Date: ${movie.releaseDate}",
              style: TextStyle(fontSize: 14, color: Colors.red[600]),
            ),
            SizedBox(height: 4),

            SizedBox(height: 4),
            Text(
              "Overview",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              movie.overview,
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Average Vote: ${movie.voteAverage}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),

                Text(
                  "Popularity: ${movie.popularity}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
