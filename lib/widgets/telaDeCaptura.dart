import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prova3/domain/pokemon.dart';
import 'package:prova3/ui/pokemon_floor.dart';

import '../ui/pokemonDao.dart';

class TelaCaptura extends StatefulWidget {
  const TelaCaptura({Key? key}) : super(key: key);

  @override
  State<TelaCaptura> createState() => _TelaCapturaState();
}

class _TelaCapturaState extends State<TelaCaptura> {
  late Future<List<Pokemon>> futurePokemonCollection;
  late PokemonDao pokemonRepository;

  @override
  void initState() {
    super.initState();
    _setupDao();
    final List<int> randomPokemonIds =
        List.generate(6, (index) => Random().nextInt(1018));
    futurePokemonCollection = getPokemonList(randomPokemonIds);
  }

  void _setupDao() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    pokemonRepository = database.pokemonDao;
  }

  Future<Pokemon> getPokemonDetails(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> pokemonData = jsonDecode(response.body);
      return Pokemon.fromJson(pokemonData);
    } else {
      throw Exception('Failed to load Pokémon details');
    }
  }

  Future<List<Pokemon>> getPokemonList(List<int> pokemonIds) async {
    final List<Pokemon> pokemonCollection = [];

    for (var id in pokemonIds) {
      final url = 'https://pokeapi.co/api/v2/pokemon/$id';
      final pokemon = await getPokemonDetails(url);
      pokemonCollection.add(pokemon);
    }

    return pokemonCollection;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Pokémon List'),
              onTap: () {
                // Navigate to Pokémon List
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Captured Pokémon'),
              onTap: () {
                // Navigate to Captured Pokémon
                Navigator.pop(context);
                // Implement navigation to the captured Pokémon screen
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Pokemon>>(
          future: futurePokemonCollection,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final pokemon = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.network(
                          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.id}.png',
                          height: 100,
                          width: 100,
                        ),
                        Text('Name: ${pokemon.name}'),
                        Text('ID: ${pokemon.id}'),
                        Text(
                            'Base Experience: ${pokemon.baseExperience.toString()}'),
                        GestureDetector(
                          onTap: () async {
                            pokemon.capture();
                            final existingPokemon =
                                await pokemonRepository.findPokemonById(pokemon.id);
                            if (existingPokemon == null) {
                              await pokemonRepository.insertPokemon(pokemon);
                            }
                            setState(() {});
                          },
                          child: Image.asset(
                            'assets/icon/pokeball.png',
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
