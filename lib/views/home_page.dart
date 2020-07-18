import 'package:flutter/material.dart';
import 'package:books_scraper/entities/books.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Books>> _getBooks() async {
    var data = await http.get(
        "https://raw.githubusercontent.com/shivashashank/Json/master/Json%20for%20Flutter.json");
    var jsonData = json.decode(data.body);
    List<Books> books = [];
    for (var i in jsonData) {
      Books booksobj =
          Books(i['id'], i['name'], i['price'], i['image'], i['rating']);
      books.add(booksobj);
    }
    //print(books.length);
    return books;
  }

  //final double _borderRadius = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Books Scraper"),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getBooks(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == Null) {
              return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data[index].image),
                    ),
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].price),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
