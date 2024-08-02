import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await DatabaseHelper().database;

  runApp(MaterialApp(home: MyApp(db)));
}

class MyApp extends StatelessWidget {
  final Database? db;

  MyApp(this.db);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cadastro de Alunos'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nome do Aluno',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final nome = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Digite o nome do aluno'),
                        content: TextField(
                          decoration: InputDecoration(
                            labelText: 'Nome do Aluno',
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop('ok');
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );

                  if (nome != null) {
                    await db!.insert(DatabaseHelper.tableName, {
                      'nome': nome,
                    });
                    print('Aluno cadastrado com sucesso!');
                  }
                },
                child: Text('Cadastrar Aluno'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final alunos = await db!.query(DatabaseHelper.tableName);
                  print('Alunos cadastrados:');
                  for (var aluno in alunos) {
                    print('ID: ${aluno['id']}, Nome: ${aluno['nome']}');
                  }
                },
                child: Text('Listar Alunos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
