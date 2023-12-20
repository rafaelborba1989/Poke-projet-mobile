import 'dart:async';

import 'package:floor/floor.dart';
import '../domain/pokemon.dart';
import '../ui/pokemonDao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'pokemon_floor.g.dart';

@Database(version: 1, entities: [Pokemon])
abstract class AppDatabase extends FloorDatabase {
  PokemonDao get pokemonDao;
}