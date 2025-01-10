import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Ensure correct import path

class CharacterDetail extends StatefulWidget {
  final String id;

  CharacterDetail({required this.id});

  @override
  _CharacterDetailState createState() => _CharacterDetailState();
}

class _CharacterDetailState extends State<CharacterDetail> {
  final ApiService apiService = ApiService();
  late Future<Map<String, dynamic>> characterDetails;

  @override
  void initState() {
    super.initState();
    characterDetails = fetchDetails();
  }

  Future<Map<String, dynamic>> fetchDetails() async {
    return await apiService.fetchCharacterDetails(widget.id);
  }

  Future<void> _refresh() async {
    setState(() {
      characterDetails = fetchDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Character Details"),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<Map<String, dynamic>>(
          future: characterDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              final character = snapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (character['images'] != null && character['images'].isNotEmpty)
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(character['images'][0] ?? 'https://via.placeholder.com/150'),
                        ),
                      ),
                    SizedBox(height: 16),
                    if (character['name'] != null)
                      Text(
                        character['name'],
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    SizedBox(height: 8),
                    if (character['personal'] != null && character['personal']['age'] != null)
                      Text(
                        'Age: ${character['personal']['age']?.values.first?.toString() ?? 'Unknown'}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                    SizedBox(height: 16),
                    if (character['debut'] != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          width: double.infinity,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Debut',
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  if (character['debut']['manga'] != null)
                                    Text('Manga: ${character['debut']['manga']}'),
                                  if (character['debut']['anime'] != null)
                                    Text('Anime: ${character['debut']['anime']}'),
                                  if (character['debut']['novel'] != null)
                                    Text('Novel: ${character['debut']['novel']}'),
                                  if (character['debut']['game'] != null)
                                    Text('Game: ${character['debut']['game']}'),
                                  if (character['debut']['appearsIn'] != null)
                                    Text('Appears In: ${character['debut']['appearsIn']}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 16),
                    if (character['personal'] != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          width: double.infinity,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Personal',
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  if (character['personal']['sex'] != null)
                                    Text('Sex: ${character['personal']['sex']}'),
                                  if (character['personal']['affiliation'] != null)
                                    Text('Affiliation: ${character['personal']['affiliation']}'),
                                  if (character['personal']['titles'] != null)
                                    Text('Titles: ${character['personal']['titles']?.join(', ') ?? 'No Titles'}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 16),
                    if (character['voiceActors'] != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          width: double.infinity,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Voice Actors',
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  if (character['voiceActors']['japanese'] != null)
                                    Text('Japanese: ${character['voiceActors']['japanese']}'),
                                  if (character['voiceActors']['english'] != null)
                                    Text('English: ${character['voiceActors']['english']}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}