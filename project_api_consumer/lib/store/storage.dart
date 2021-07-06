import 'dart:async';

import 'package:flutter/material.dart';

import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

import 'package:project_api_consumer/main.dart';

void storage(var postsList) async {
  WidgetsFlutterBinding.ensureInitialized();
  String path = join(await getDatabasesPath(), 'database.db');
  Database database = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('CREATE TABLE posts(id INTEGER PRIMARY KEY, title TEXT, text TEXT, comments TEXT)');
      await db.execute('CREATE TABLE comments(id INTEGER PRIMARY KEY, body_text TEXT)');
    },
  );

  Future<void> insertPost(Post postage) async {
    final db = await database;
    await db.insert(
      'posts',
      postage.postToMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Post>> postList() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('posts');

    return List.generate(maps.length, (i){
      return Post(
        postId: maps[i]['id'],
        title: maps[i]['title'],
        text: maps[i]['text'],
        comments: maps[i]['comments'],
      );
    }); 
  }

  Future<void> deletePost(int id) async {
    final db = await database;
    await db.delete(
      'posts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertComment(Comments comentary) async {
    final db = await database;
    await db.insert(
      'comments',
      comentary.commentToMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Comments>> commentsList() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('comments');

    return List.generate(maps.length, (i){
      return Comments(
        commentId: maps[i]['id'],
        bodyText: maps[i]['body_text'],
      );
    }); 
  }

  Future<void> deleteComment(int id) async {
    final db = await database;
    await db.delete(
      'comments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  for (var i in postsList) {
    i['comments'] ??= 'none';
    i = Post(postId: i['post_id'],title: i['title'], text: i['text'], comments: i['comments']);
    await insertPost(i);
  }

  final db = await database;
  await db.close();
}