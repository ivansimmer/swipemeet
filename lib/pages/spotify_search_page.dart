import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SpotifySearchPage extends StatefulWidget {
  const SpotifySearchPage({super.key});

  @override
  State<SpotifySearchPage> createState() => _SpotifySearchPageState();
}

class _SpotifySearchPageState extends State<SpotifySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _results = [];
  bool _isLoading = false;
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _getAccessToken();
  }

  Future<void> _getAccessToken() async {
    const clientId = '6cc751d533ec46cc96a3652f3665e89d';
    const clientSecret = '887c20c3638a486c913d108d101ae8c0';

    final credentials = base64.encode(utf8.encode('$clientId:$clientSecret'));

    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() => _accessToken = data['access_token']);
    } else {
      print('❌ Error obteniendo token: ${response.body}');
    }
  }

  Future<void> _searchSongs(String query) async {
    if (_accessToken == null) return;
    setState(() => _isLoading = true);

    final uri = Uri.https('api.spotify.com', '/v1/search', {
      'q': query,
      'type': 'track',
      'limit': '10',
    });

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $_accessToken'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final tracks = data['tracks']['items'] as List<dynamic>;
      setState(() {
        _results = tracks.map<Map<String, String>>((track) {
          final map = track as Map<String, dynamic>;
          final name = map['name'] ?? '';
          final artist = map['artists']?[0]?['name'] ?? '';
          final imageUrl = map['album']?['images']?[0]?['url'] ?? '';
          return {
            'title': name,
            'artist': artist,
            'image': imageUrl,
          };
        }).toList();
      });
    } else {
      print('❌ Error en búsqueda: ${response.body}');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar canción favorita')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar canción',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchSongs(_searchController.text),
                ),
              ),
              onSubmitted: _searchSongs,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_results.isEmpty)
              const Text('No hay resultados.')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final song = _results[index];
                    return ListTile(
                      leading: song['image']!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                song['image']!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.music_note,
                              size: 40, color: Colors.grey),
                      title: Text(song['title']!),
                      subtitle: Text(song['artist']!),
                      onTap: () {
                        Navigator.of(context).pop({
                          'title': '${song['title']} - ${song['artist']}',
                          'image': song['image'] ?? '',
                        });
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}