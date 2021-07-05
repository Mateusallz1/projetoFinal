import 'dart:convert';
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


class Post {
  final int postId;
  final String title;
  final String text;
  final List<dynamic> comments;

  Post({this.postId, this.text, this.title, this.comments});

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
  final String bodyText;

  Comments({this.bodyText,});

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      bodyText: json['body_text'] as String,
    );
  }
}