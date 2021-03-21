import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'image-post-list',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(title: 'image-post-list'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Post {
  final String text;
  final String image;
  final int likes;
  final List<String> tags;
  final String publishDate;
  Post._({this.text, this.image, this.likes, this.tags, this.publishDate});
  factory Post.fromJson(Map<String, dynamic> json) {
    return new Post._(
      text: json['text'],
      image: json['image'],
      likes: json['likes'],
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      publishDate: json['publishDate'],
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  String baseUrl = 'https://dummyapi.io/data/api';
  Map<String, String> headers = {"app-id": '6057843714e694f0a7f48c8f'};
  bool isLoading = false;
  List<Post> list = [];

  @override
  void initState() {
    _fetchData();
  }

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    Uri uri = Uri.parse("${baseUrl}/post");
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      list = (json.decode(response.body)['data'] as List)
          .map((data) => new Post.fromJson(data))
          .toList();
      print(list.length);
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception(
          "Request to ${uri.toString()} failed with status ${response.statusCode}: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("image-post-list"),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(list[index].image),
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.pink,
                                            size: 24.0,
                                            semanticLabel:
                                                'Text to announce in accessibility modes',
                                          ),
                                          Text(list[index].likes.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .overline)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          ...list[index].tags.map((t) => Text(
                                              "#${t}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .overline))
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Description:'),
                                      Text(list[index].text),
                                    ],
                                  )
                                ],
                              )),
                        ],
                      ));
                }));
  }
}
