class Movie {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String originallanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  Movie({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originallanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  //method to convert the JSON data into a dart object
  factory Movie.fromjson(Map<String, dynamic> json) {
    return Movie(
      adult: json["adult"] ?? false,
      backdropPath: json["backdrop_path"] as String?,
      genreIds: List<int>.from(json["genre_ids"] ?? []),
      id: json["id"] ?? 0,
      originallanguage: json["original_language"] ?? "",
      originalTitle: json["original_title"] ?? "",
      overview: json["overview"] ?? "",
      popularity: (json["popularity"] ?? 0).toDouble(),
      posterPath: json["poster_path"] as String?,
      releaseDate: json["release_date"] ?? "",
      title: json["title"] ?? "",
      video: json["video"] ?? false,
      voteAverage: (json["vote_average"] ?? 0).toDouble(),
      voteCount: json["vote_count"] ?? 0,
    );
  }
}
