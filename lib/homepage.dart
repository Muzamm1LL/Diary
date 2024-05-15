import 'package:diaryapp/account.dart';
import 'package:diaryapp/extentions.dart';
import 'package:diaryapp/favourite.dart';
import 'package:diaryapp/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'sql_helper.dart';
import 'setting.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<Map<String, dynamic>> _diaries;
  bool _isLoading = true;
  bool _isDarkMode = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _refreshDiaries();
  }

  void _refreshDiaries() async {
    final data = await SQLHelper.getDiaries();
    setState(() {
      _diaries = data.map((diary) => {...diary, 'isFavorite': false}).toList();
      _isLoading = false;
    });
  }

  final TextEditingController _feelingController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existingDiary =
          _diaries.firstWhere((element) => element['id'] == id);
      _feelingController.text = existingDiary['feeling'];
      _descriptionController.text = existingDiary['description'];
    } else {
      _feelingController.text = '';
      _descriptionController.text = '';
    }

    String selectedEmoji =
        _feelingController.text; // Store selected emoji separately

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 220,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Merge the first and third text fields
            TextField(
              controller: _feelingController,
              decoration: InputDecoration(
                hintText: 'Feeling',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.emoji_emotions),
                  onPressed: () =>
                      _showEmojiPicker(), // This function is removed
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Second text field
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  await _addDiary();
                } else {
                  await _updateDiary(id);
                }
                _feelingController.clear();
                _descriptionController.clear();
                Navigator.of(context).pop();
              },
              child: Text(id == null ? 'Create New' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        height: 250,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Add the selected emoji to the feeling text field
                _feelingController.text = _emojis[index];
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text(
                  _emojis[index],
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            );
          },
          itemCount: _emojis.length,
        ),
      ),
    );
  }

  static const List<String> _emojis = [
    '😀',
    '😃',
    '😄',
    '😁',
    '😆',
    '😍',
    '😎',
    '🥰',
    '😊',
    '😇',
    '💀',
    '😠',
    '😢',
  ];

  Future<void> _addDiary() async {
    await SQLHelper.createDiary(
      _feelingController.text,
      _descriptionController.text,
    );
    _refreshDiaries();
    Fluttertoast.showToast(msg: 'Diary created successfully');
  }

  Future<void> _updateDiary(int id) async {
    await SQLHelper.updateDiary(
      id,
      _feelingController.text,
      _descriptionController.text,
    );
    _refreshDiaries();
    Fluttertoast.showToast(msg: 'Diary updated successfully');
  }

  Future<void> _deleteDiary(int id) async {
    await SQLHelper.deleteDiary(id);
    _refreshDiaries();
    Fluttertoast.showToast(msg: 'Diary deleted successfully');
  }

  void _logOut() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginDemo()),
      (route) => false,
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _navigateToAccountSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountSettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text("Persona Diary"),
          titleTextStyle: _isDarkMode
              ? const TextStyle(color: Colors.white)
              : const TextStyle(color: Colors.black),
          backgroundColor:
              _isDarkMode ? '14213D'.toColor() : 'BEE3BA'.toColor(),
          leading: IconButton(
            icon: Icon(
              _isDarkMode ? Icons.menu_open_outlined : Icons.menu,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: const Text('Hi!'),
                accountEmail: const Text('Muzammil'),
                currentAccountPicture: Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 100,
                    child: Image.asset('assets/images/chad.jpg'),
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Favourite diary'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FavoritePage(diaries: _diaries)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.play_arrow),
                title: const Text('activity'),
                onTap: _navigateToAccountSettings,
              ),
              ListTile(
                leading: Icon(
                  _isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                ),
                title: const Text('Dark Mode'),
                onTap: _toggleDarkMode,
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Account'),
                onTap: _navigateToAccountSettings,
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log Out'),
                onTap: () {
                  _logOut();
                },
              ),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _diaries.length,
                itemBuilder: (context, index) {
                  final isExpanded = _diaries[index]['isExpanded'] ?? false;

                  return Card(
                    color:
                        _isDarkMode ? '14213D'.toColor() : 'BEE3BA'.toColor(),
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: Text(
                        _diaries[index]
                            ['feeling'], // Display emoji as text in leading
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(_diaries[index]['description']),
                      subtitle: Text(_diaries[index]['createdAt']),
                      trailing: SizedBox(
                        width: 150,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showForm(_diaries[index]['id']),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteDiary(_diaries[index]['id']),
                            ),
                            IconButton(
                              icon: Icon(
                                _diaries[index]['isFavorite']
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                              ),
                              color: _diaries[index]['isFavorite']
                                  ? Colors.red
                                  : null,
                              onPressed: () {
                                setState(() {
                                  _diaries[index]['isFavorite'] =
                                      !_diaries[index]['isFavorite'];
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor:
              _isDarkMode ? '266867'.toColor() : '266867'.toColor(),
          onPressed: () => _showForm(null),
        ),
      ),
    );
  }
}
