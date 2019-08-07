import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<Post> fetchPost() async{
  final response = await http.get(
      'https://jsonplaceholder.typicode.com/posts/1',
      headers: {HttpHeaders.authorizationHeader:"Basic your_api_token_here"}
      );
      final responseJson = json.decode(response.body);

      return Post.fromJson(responseJson);
}

class Post{
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId,this.id,this.title,this.body});

  factory Post.fromJson(Map<String,dynamic>json){
    return Post(
      userId:json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}


void main() => runApp(MyApp(post:fetchPost()));

class MyApp extends StatelessWidget {
  final Future<Post> post;

  MyApp({Key key, this.post}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: post,
            builder: (context,snapshot){
              if(snapshot.hasData){
                return Text(snapshot.data.body);
              }else if(snapshot.hasError){
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      )
    );
  }
}
