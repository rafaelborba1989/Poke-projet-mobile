import 'package:flutter/material.dart';
import 'package:prova3/domain/pokemon.dart';
import 'package:prova3/ui/pokemon_floor.dart';
import 'package:prova3/widgets/telaSobre.dart';

import '../ui/pokemonDao.dart';

class TelaSoltarPokemon extends StatefulWidget {
  final int id;

  TelaSoltarPokemon({required this.id});

  @override
  _TelaSoltarPokemonState createState() => _TelaSoltarPokemonState();
}

class _TelaSoltarPokemonState extends State<TelaSoltarPokemon> {
  Future<Pokemon?>? futurePokemon;
  PokemonDao? pokemonDao;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final database =
          await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      pokemonDao = database.pokemonDao;
      setState(() {
        futurePokemon = getPokemon();
      });
    });
  }

  void initializeDbAndDao() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    pokemonDao = database.pokemonDao;
    futurePokemon = getPokemon();
  }

  Future<Pokemon?> getPokemon() async {
    print('Getting Pokemon with ID: ${widget.id}');
    final pokemon = await pokemonDao!.findPokemonById(widget.id);
    print('Got Pokemon: $pokemon');
    return pokemon;
  }

  void deletePokemon(Pokemon pokemon) async {
    await pokemonDao!.deletePokemon(pokemon);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soltar Pokémon'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaSobre()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Pokemon?>(
        future: futurePokemon,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Center(child: Text('Ocorreu um erro!'));
          } else if (snapshot.data == null) {
            return Center(child: Text('Nenhum dado encontrado.'));
          } else {
            return Column(
              children: <Widget>[
                Text('Nome: ${snapshot.data!.name}'),
                Text('ID: ${snapshot.data!.id}'),
                Image.network(
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${snapshot.data!.id}.png',
                  height: 100,
                  width: 100,
                ),
                Text('Nome: ${snapshot.data!.name}'),
                Text('ID: ${snapshot.data!.id}'),
                Text('Base Experience: ${snapshot.data!.baseExperience}'),
                ElevatedButton(
                  onPressed: () {
                    deletePokemon(snapshot.data!);
                  },
                  child: Text('Confirmar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}