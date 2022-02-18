import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final TextEditingController _photoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Colors.white,
        child: Center(
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(30),
              ),
              Image.asset(
                'assets/photobay.png',
                width: 200,
                height: 200,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: TextFormField(
                  controller: _photoController,
                  decoration: InputDecoration(
                    labelText: 'Enter Category',
                    hintText: 'e.g. dogs, bikes, etc...',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: MaterialButton(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AnotherPage(
                          pictureCategory: _photoController.text,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Search',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnotherPage extends StatefulWidget {

  final String pictureCategory;

  AnotherPage({required this.pictureCategory});

  @override
  _AnotherPageState createState() => _AnotherPageState();
}

class _AnotherPageState extends State<AnotherPage> {
  var apiKey = '25766206-1bbed9745c2523c69066287fa';

  Future<Map> getPictures(String category) async {
    String apiUrl =
        'https://pixabay.com/api/?key=$apiKey&q=$category&image_type=photo&pretty=true';
    http.Response photoResponse = await http.get(Uri.parse(apiUrl));
    return jsonDecode(photoResponse.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Photo bay',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getPictures(widget.pictureCategory),
        builder: (context, snapshot) {
          Map? pictureData = snapshot.data as Map;
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Text('No Data');
          } else if (snapshot.hasData) {
            return Center(
              child: ListView.builder(
                itemCount: pictureData.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: InkWell(
                          onTap: () {},
                          child: Image.network(
                              '${pictureData['hits'][index]['largeImageURL']}'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container();
        },
      ),
    );
  }
}
