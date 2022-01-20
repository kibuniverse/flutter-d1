import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Welcome to Flutter', home: RandomWords());
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = <WordPair>{};

  Widget _buildSuggestion() {
    return ListView.builder(itemBuilder: (context, i) {
      if (i.isOdd) return const Divider();
      final index = i ~/ 2;
      if (index >= _suggestions.length) {
        _suggestions.addAll(generateWordPairs().take(10));
      }
      return _buildRow(_suggestions[index]);
    });
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      final tiles = _saved.map((pair) => ListTile(
              title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          )));
      final divided =
          ListTile.divideTiles(tiles: tiles, context: context).toList();
      return Scaffold(
        appBar: AppBar(
          title: const Text('save suggestion'),
        ),
        body: ListView(
          children: divided,
        ),
      );
    }));
  }

  Widget _buildRow(WordPair pair) {
    final _isAddFavor = _saved.contains(pair);
    return ListTile(
      title: Text(pair.asPascalCase, style: _biggerFont),
      trailing: Icon(_isAddFavor ? Icons.favorite : Icons.favorite_border,
          color: _isAddFavor ? Colors.red : null),
      onTap: () => {
        setState(() {
          if (_isAddFavor) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        })
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Startup Name Generator"),
        actions: [
          IconButton(onPressed: _pushSaved, icon: const Icon(Icons.list))
        ],
      ),
      body: _buildSuggestion(),
    );
  }
}
