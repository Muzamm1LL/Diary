import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  final List<Map<String, dynamic>> diaries;

  const FavoritePage({Key? key, required this.diaries}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Map<String, dynamic>> _favoriteDiaries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavoriteDiaries();
  }

  void _fetchFavoriteDiaries() async {
    setState(() {
      _favoriteDiaries =
          widget.diaries.where((diary) => diary['isFavorite']).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _favoriteDiaries.isEmpty
              ? const Center(
                  child: Text('No favorite diaries found.'),
                )
              : ListView.builder(
                  itemCount: _favoriteDiaries.length,
                  itemBuilder: (context, index) {
                    final favoriteDiary = _favoriteDiaries[index];
                    return Card(
                      // Customize the card appearance as needed
                      child: ListTile(
                        leading: Text(
                          favoriteDiary['feeling'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        title: Text(favoriteDiary['description']),
                      ),
                    );
                  },
                ),
    );
  }
}
