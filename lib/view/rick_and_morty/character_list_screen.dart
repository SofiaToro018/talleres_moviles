import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/character_model.dart';
import '../../services/character_service.dart';
import '../../widgets/base_drawer.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  late Future<List<Character>> _charactersFuture;
  final CharacterService _service = CharacterService();
  String _lastLoggedState = '';

  @override
  void initState() {
    super.initState();
    _charactersFuture = _fetchAndLog();
  }

  Future<List<Character>> _fetchAndLog() {
    // Logs para la consola sobre el ciclo de la petición
    print('Antes de la consulta');
    final future = _service.fetchCharacters();
    print('Durante la consulta');
    future
        .then((data) {
          print('Después de la consulta - éxito: ${data.length} elementos');
        })
        .catchError((e) {
          print('Después de la consulta - error: $e');
        });
    return future;
  }

  void _logState(String state) {
    if (_lastLoggedState != state) {
      _lastLoggedState = state;
      print(state);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseView(
      title: 'Personajes de Rick and Morty',
      appBar: AppBar(
        title: const Text('Personajes de Rick and Morty'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Container(
        color: theme.colorScheme.surface, // Fondo igual al del home
        padding: const EdgeInsets.all(12),
        child: FutureBuilder<List<Character>>(
          future: _charactersFuture,
          builder: (context, snapshot) {
            // Log de estado para consola
            if (snapshot.connectionState == ConnectionState.waiting) {
              _logState('Estado: Cargando');
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              _logState('Estado: Error - ${snapshot.error}');
              // Mensaje de error amigable con opción para reintentar
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'No se pudieron cargar los personajes.',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => setState(
                        () => _charactersFuture = _service.fetchCharacters(),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              _logState('Estado: Vacío');
              // Lista vacía: mensaje claro y reintento
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'No se encontraron personajes.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => setState(
                        () => _charactersFuture = _service.fetchCharacters(),
                      ),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            final characters = snapshot.data!;
            _logState('Estado: Éxito - ${characters.length} elementos');

            return ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
                return _AnimatedCharacterCard(character: character);
              },
            );
          },
        ),
      ),
    );
  }
}

class _AnimatedCharacterCard extends StatefulWidget {
  final Character character;

  const _AnimatedCharacterCard({required this.character});

  @override
  State<_AnimatedCharacterCard> createState() => _AnimatedCharacterCardState();
}

class _AnimatedCharacterCardState extends State<_AnimatedCharacterCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8),
        transform: _isHovered
            ? Matrix4.translationValues(0, -5, 0)
            : Matrix4.translationValues(0, 0, 0),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.go(
            '/character_detail/${widget.character.id}',
            extra: widget.character,
          ),
          child: Card(
            color: theme.cardColor,
            elevation: _isHovered ? 10 : 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(widget.character.image),
              ),
              title: Text(
                widget.character.name,
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${widget.character.species} - ${widget.character.status}',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
