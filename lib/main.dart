import 'package:flutter/material.dart';
import 'models/pokemon.dart';
import 'services/pokemon_service.dart';
import 'screens/pokemon_detail_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const PokemonListScreen(),
    );
  }
}

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  List<Pokemon> cards = [];
  Pokemon? firstCard;
  bool lockBoard = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  void initGame() {
    cards = [
      Pokemon(
        id: 1,
        name: 'BULBASAUR',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
        attack: 49,
      ),
      Pokemon(
        id: 2,
        name: 'IVYSAUR',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png',
        attack: 62,
      ),
      Pokemon(
        id: 1,
        name: 'BULBASAUR',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
        attack: 49,
      ),
      Pokemon(
        id: 2,
        name: 'IVYSAUR',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png',
        attack: 62,
      ),
      Pokemon(
        id: 3,
        name: 'VENUSAUR',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png',
        attack: 82,
      ),
      Pokemon(
        id: 4,
        name: 'CHARMANDER',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png',
        attack: 52,
      ),
    ];

    cards = [
      ...cards,
      ...cards.map(
        (c) => Pokemon(
          id: c.id,
          name: c.name,
          imageUrl: c.imageUrl,
          attack: c.attack,
          isMatched: c.isMatched,
          isFlipped: c.isFlipped,
        ),
      ),
    ];

    cards.shuffle();
  }

  void onCardTap(Pokemon card) async {
    if (lockBoard || card.isFlipped || card.isMatched) return;

    setState(() => card.isFlipped = true);

    if (firstCard == null) {
      firstCard = card;
    } else {
      lockBoard = true;

      if (firstCard!.id == card.id) {
        setState(() {
          firstCard!.isMatched = true;
          card.isMatched = true;
          score++;
        });
      } else {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          firstCard!.isFlipped = false;
          card.isFlipped = false;
        });
      }
      firstCard = null;
      lockBoard = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pokedex - Score: $score')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.75,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final pokemon = cards[index];
          return PokemonCard(pokemon: pokemon, onTap: onCardTap);
        },
      ),
    );
  }
}

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final void Function(Pokemon) onTap;
  const PokemonCard({super.key, required this.pokemon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(pokemon),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: pokemon.isMatched
              ? Colors.green.shade100
              : Colors.red.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 8)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: pokemon.isFlipped || pokemon.isMatched
              ? Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Hero(
                        tag: 'pokemon_${pokemon.id}',
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/pokeball.png',
                          image: pokemon.imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              pokemon.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Attack: ${pokemon.attack}',
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  color: Colors.blue.shade100,
                  child: const Center(
                    child: Icon(
                      Icons.help_outline,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
