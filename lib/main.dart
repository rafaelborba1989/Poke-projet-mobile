import 'package:flutter/material.dart';
import 'package:prova3/widgets/telaDeCaptura.dart';
import 'package:prova3/widgets/pokemonCapturado.dart';
import 'package:provider/provider.dart';
import 'ui/pokemon_floor.dart';
import 'widgets/telaSobre.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necessário para usar async antes do runApp

  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  runApp(
    Provider<AppDatabase>(
      create: (context) => database,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terceira Prova',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

// O restante do seu código vai aqui...

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    TelaCaptura(),
    PokemonCapturado(),
    TelaSobre(), // Adicione a TelaSobre à lista
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terceira Prova'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Captura',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Capturados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Sobre', 
          ),
        ],
      ),
    );
  }
}