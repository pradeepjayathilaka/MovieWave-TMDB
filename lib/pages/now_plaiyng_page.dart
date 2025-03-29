import 'package:flutter/material.dart';

class NowPlaiyngPage extends StatefulWidget {
  const NowPlaiyngPage({super.key});

  @override
  State<NowPlaiyngPage> createState() => _MainPageState();
}

class _MainPageState extends State<NowPlaiyngPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Now Playing")));
  }
}
