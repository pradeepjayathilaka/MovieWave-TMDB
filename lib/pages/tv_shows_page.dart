import 'package:flutter/material.dart';

class TvShowsPage extends StatefulWidget {
  const TvShowsPage({super.key});

  @override
  State<TvShowsPage> createState() => _MainPageState();
}

class _MainPageState extends State<TvShowsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("TV shows")));
  }
}
