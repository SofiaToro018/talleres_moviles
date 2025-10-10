import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/character_model.dart';
import '../../services/character_service.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  late Future<List<Character>> _charactersFuture;
  final CharacterService _service = CharacterService();

  @override
  void initState() {
    super.initState();
    _charactersFuture = _service.fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personajes de Rick and Morty')),
      body: FutureBuilder<List<Character>>(
        future: _charactersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron personajes'));
          }

          final characters = snapshot.data!;
          return ListView.builder(
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(character.image),
                ),
                title: Text(character.name),
                subtitle: Text('${character.species} - ${character.status}'),
                onTap: () => context.go(
                  '/character_detail/${character.id}',
                  extra: character,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
