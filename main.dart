//memasukan package yang dibutuhkan oleh aplikasi
import 'dart:developer';
import 'dart:io';

import 'package:english_words/english_words.dart'; //paket bahasa Ingris
import 'package:flutter/material.dart'; //paket untuk tampilan UI (material UI)
import 'package:provider/provider.dart'; //paket untuk interaksi aplikasi

//fungsi main(fungsi utama)
void main() {
  runApp(
      MyApp()); //memanggil fungsi runApp (yang menjalankan keseluruhan aplikasi di dalam myApp())
}

//membuat abstrak aplikasi dari StatelessWidget (template aplikasi), apliasi nya bernama myApp
class MyApp extends StatelessWidget {
  const MyApp(
      {super.key}); //menunjukan bahwa aplikasi ini akan tetap, tidak berubah setelah di build

  @override //mengganti nilai lama yang sudah ada di template, dengan nilai-nilai yang baru (replace / overwrite)
  Widget build(BuildContext context) {
    //fungsi yang membangun UI (mengatur posisi wigdet, dst)
    //ChangeNotifierProvider mendengarkan / mendeteksi semua interaksi yang terjadi di aplikasi
    return ChangeNotifierProvider(
      create: (context) => MyAppState(), //membuat satu state bernama myAppState
      child: MaterialApp(
        //pada State ini ,menggunakan style desain material Ui
        title: 'Namer App', //diberi judul myApp
        theme: ThemeData(
          //data tema aplikasi, diberi warna deepOrange
          useMaterial3: true, //versi material UI yang dipakai versi 3

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home:
            MyHomePage(), //nama halaman "MyHomePage" yang menggunakan state "MyAppState"
      ),
    );
  }
}

//mendifinisikan MyAppState
class MyAppState extends ChangeNotifier {
  //state MyAppState diisi dengan 2 kata random yang digambung, kata random tsb disimpan divariable Wordpair
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

//membuat layout pada halaman homepage
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState =
        context.watch<MyAppState>(); //wingdet menggunakan state MyAppState
    //dibawah ini adalah kode proggram untuk menyusun layout
    WordPair pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      //base (canvas) dari layout
      body: Center(
        child: Column(
          //diatas scaffold ada body, bodynya diberi kolom
          children: [
            //didalam kolom diberi teks
            Text('A random idea:'),
            BigCard(
                pair:
                    pair), //mengambil random teks dari AppState pada variable wordpair curent, lalu diubah menjadi huruf kecil semua dari ditampilkan sebagai teks
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    print('button pressed!');
                    appState.getNext(); // ← This instead of print().
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ↓ Add this.
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        // ↓ Change this line.
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
