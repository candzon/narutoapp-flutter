import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Ensure correct import path
import 'character_detail.dart'; // Ensure correct import path

class CharacterList extends StatefulWidget {
  @override
  _CharacterListState createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  ApiService apiService = ApiService();
  List<dynamic> characters = [];
  int currentPage = 1;
  final int limit = 20;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCharacters();
  }

  Future<void> fetchCharacters() async {
    if (characters.length >= limit) {
      return; // Stop fetching if the limit is reached
    }
    setState(() {
      isLoading = true;
    });
    var newCharacters = await apiService.fetchCharacters(currentPage, limit);
    setState(() {
      characters.addAll(newCharacters);
      isLoading = false;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      characters.clear();
      currentPage = 1;
    });
    await fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Naruto Characters"),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            currentPage++;
            fetchCharacters();
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: characters.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: characters.length + 1,
            itemBuilder: (context, index) {
              if (index == characters.length) {
                return isLoading ? Center(child: CircularProgressIndicator()) : SizedBox.shrink();
              }
              final character = characters[index];
              final imageUrl = (character['images'] is List && character['images'].isNotEmpty)
                  ? character['images'][0]
                  : 'https://via.placeholder.com/150';

              // Ensure id is a string:
              final String characterId = character['id'].toString();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 30,
                      child: ClipOval(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.jpg',
                          image: imageUrl,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image,
                              size: 60,
                            );
                          },
                        ),
                      ),
                    ),
                    title: Text(
                      character['name'] ?? 'No Name',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Age: ' + (character['personal']['age']?.values.first?.toString() ?? 'Unknown'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: Text(
                      '#${index + 1}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CharacterDetail(id: characterId),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}