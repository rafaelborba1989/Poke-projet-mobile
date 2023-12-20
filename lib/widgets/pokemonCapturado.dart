import 'package:flutter/material.dart';
import 'package:prova3/domain/pokemon.dart';
import 'package:prova3/ui/pokemon_floor.dart';
import 'package:prova3/widgets/telaSobre.dart';

import 'detalheDoPokemon.dart';
import 'telaSoltarPokemon.dart';

class PokemonCapturado extends StatefulWidget {
  @override
  _TelaPokemonCapturadoState createState() => _TelaPokemonCapturadoState();
}

class _TelaPokemonCapturadoState extends State<PokemonCapturado> {
  late Future<List<Pokemon>> futurePokemons;

  @override
  void initState() {
    super.initState();
    refreshPokemons();
  }

  Future<List<Pokemon>> getPokemonsCapturados() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final pokemonDao = database.pokemonDao;
    return pokemonDao
        .findAllPokemons(); // Substitua por sua função que retorna apenas Pokémons capturados
  }

  void refreshPokemons() {
    setState(() {
      futurePokemons = getPokemonsCapturados();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémons Capturados'),
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
      body: FutureBuilder<List<Pokemon>>(
        future: futurePokemons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            // Se algo der errado...
            return Center(child: Text('Ocorreu um erro!'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            // Se não houver Pokémons capturados...
            return Center(child: Text('Nenhum Pokémon capturado ainda.'));
          } else {
            // Se houver Pokémons capturados...
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetalhesPokemon(id: snapshot.data![i].id),
                    ),
                  );
                },
                onLongPress: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TelaSoltarPokemon(id: snapshot.data![i].id),
                    ),
                  );
                  if (result == true) {
                    refreshPokemons();
                  }
                },
                child: ListTile(
                  title: Text(snapshot.data![i].name),
                  // Adicione mais detalhes sobre o Pokémon aqui...
                ),
              ),
            );
          }
        },
      ),
    );
  }
}