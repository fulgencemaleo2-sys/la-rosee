import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  runApp(const LA_ROSEE());
}

class LA_ROSEE extends StatelessWidget {
  const LA_ROSEE({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LA ROSEE',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final pages = [const ElevesPage(), const MinervalPage(), const PresencesPage()];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Institut LA ROSEE')),
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Élèves'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Minerval'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Présences'),
        ],
      ),
    );
  }
}

// DB + 3 pages Élèves, Minerval, Présences
class DB {
  static Database? _db;
  static Future<Database> get db async => _db ??= await init();
  static Future<Database> init() async {
    String path = join(await getDatabasesPath(), 'larosee.db');
    return await openDatabase(path, version: 1, onCreate: (db, v) async {
      await db.execute('CREATE TABLE classes(id INTEGER PRIMARY KEY, nom TEXT, section TEXT)');
      await db.execute('CREATE TABLE eleves(id INTEGER PRIMARY KEY, nom TEXT, postnom TEXT, prenom TEXT, classe_id INTEGER, sexe TEXT)');
      await db.execute('CREATE TABLE paiements(id INTEGER PRIMARY KEY, eleve_id INTEGER, montant REAL, motif TEXT, date TEXT)');
      await db.execute('CREATE TABLE presences(id INTEGER PRIMARY KEY, eleve_id INTEGER, date TEXT, statut TEXT, UNIQUE(eleve_id, date))');
      await db.insert('classes', {'nom': '1ère Primaire', 'section': 'Primaire'});
      await db.insert('classes', {'nom': '2ème Primaire', 'section': 'Primaire'});
    });
  }
}

// Pages simplifiées pour démarrer - ElevesPage, MinervalPage, PresencesPage
class ElevesPage extends StatelessWidget {
  const ElevesPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Module Élèves - v1.0'));
}
class MinervalPage extends StatelessWidget {
  const MinervalPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Module Minerval - v1.0'));
}
class PresencesPage extends StatelessWidget {
  const PresencesPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Module Présences - v1.0'));
}
