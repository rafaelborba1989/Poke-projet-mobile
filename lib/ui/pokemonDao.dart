import 'package:floor/floor.dart';

import '../domain/pokemon.dart';

@dao

abstract class PokemonDao {
  @insert
  Future<void> insertPokemon(Pokemon pokemon);

  @delete
  Future<void> deletePokemon(Pokemon pokemon);

  @Query('SELECT * FROM Pokemon')
  Future<List<Pokemon>> findAllPokemons();

  @Query('SELECT * FROM Pokemon WHERE id = :id')
  Future<Pokemon?> findPokemonById(int id);
}