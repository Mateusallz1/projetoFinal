import 'dart:convert';
import 'dart:async';

import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; 

import 'package:http/http.dart' as http;


 Future<List<Post>> fetchPosts(http.Client client) async {
  final response =
    await client.get(Uri.parse('http://127.0.0.1:8000/post-comments/'));
  
  if (response.statusCode == 200) {
      return compute(parsePost, response.body);
  } else {
    throw Exception('Failed to load Posts.');
  }
}


List<Post> parsePost(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Post>((json) => Post.fromJson(json)).toList();
}


void main() {
  runApp(MyApp());
  //storage();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Será se funfa?';

    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: appTitle,),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
    MyHomePage({Key key, this.title}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text(title),),
        body: FutureBuilder<List<Post>>(
          future: fetchPosts(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
              ? PostsList(posts: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}


class PostsList extends StatelessWidget {
  final List<Post> posts;
  PostsList({Key key, this.posts}) : super(key: key);
  
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${posts[index].title}'),
          onTap: () {
          },
        );
      }
    );
  }
}

void storage() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), 'database.db'),
    onCreate: (db, version) async {
      await db.execute('CREATE TABLE posts(id INTEGER PRIMARY KEY, title TEXT, text TEXT, comments TEXT)');
      await db.execute('CREATE TABLE comments(id INTEGER PRIMARY KEY, body_text TEXT)');
    },
    version: 1,
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
}


class Post {
  final int postId;
  final String title;
  final String text;
  final List<dynamic> comments;

  Post({this.postId, this.text, this.title, this.comments});

  Map<String, dynamic> postToMap() {
    return {
      'id': postId,
      'title': title,
      'text': text,
      'comments': comments,
    };
  }

  @override
  String toString() {
    return 'Post{id: $postId, title: $title, text: $text, comments: $comments}';
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['post_id'] as int,
      title: json['title'] as String,
      text: json['text'] as String,
      comments: json['comments'] as List,
    );
  }
}

class Comments {
  final int commentId;
  final String bodyText;

  Comments({this.commentId, this.bodyText,});

  Map<String, dynamic> commentToMap() {
    return {
      'id': commentId,
      'body_text': bodyText,
    };
  }

  @override
  String toString() {
    return 'Comments{id: $commentId, body_text: $bodyText}';
  }

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      commentId: json['comment_id'] as int,
      bodyText: json['body_text'] as String,
    );
  }
}