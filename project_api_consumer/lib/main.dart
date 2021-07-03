import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<List<Post>> fetchPosts(http.Client client) async {
  final response =
    await client.get(Uri.parse('http://localhost:8000/posts/'));
  return compute(parsePost, response.body);
}


List<Post> parsePost(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Post>((json) => Post.fromJson(json)).toList();
}


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      
    );
  }
}


class Post {
  final int postid;
  final String title;
  final String text;

  Post({this.postid, this.text, this.title,});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postid: json['postid'] as int,
      title: json['title'] as String,
      text: json['text'] as String,
    );
  }
}

