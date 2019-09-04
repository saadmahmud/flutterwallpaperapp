import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

String photo1 = 'images/royal_enfield.jpg';
String photo2 = 'images/royal_enfield_2.jpg';
String photo3 = 'images/royal_enfield_3.jpg';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: ListPage(),
  ));
}

/*APIs..*/
var accessKey =
    "/?client_id=68f5dd759ddde598990157151f4a49a0d2595b5624f44d6e63c50f3105f7b565";

var baseUrl = "https://api.unsplash.com";

var listPhotos = "/photos";

final GET_PHOTOS_URL = baseUrl + listPhotos + accessKey;
/*APIs..*/

Future<List<Photo>> fetchPhotos(http.Client client) async {
  print("fetchPhotos url: " + GET_PHOTOS_URL);

  final response = await client.get(GET_PHOTOS_URL);
  print("fetchPhotos response: " + response.body);

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final String id;
  final String title;
  final String fullUrl;
  final String largeUrl;
  final String smallUrl;
  final String thumbnailUrl;

  Photo(
      {this.id,
      this.title,
      this.fullUrl,
      this.largeUrl,
      this.smallUrl,
      this.thumbnailUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as String,
      title: json['alt_description'] as String,
      fullUrl: json['urls']['full'] as String,
      largeUrl: json['urls']['regular'] as String,
      smallUrl: json['urls']['small'] as String,
      thumbnailUrl: json['urls']['thumb'] as String,
    );
  }
}

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("fetching..");
//    List.generate(snapshot.data.toSet().length, (index) {
//      return ListItem(snapshot.data.elementAt(index));
//    })
    return Scaffold(
      appBar: AppBar(
        title: Text("Image List"),
      ),
      body: FutureBuilder<List<Photo>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              print("fetching done");
              if (snapshot.hasError) {
                print("fetching error");
                print("fetching error : " + snapshot.error.toString());
                return Center(
                    child: Text(
                        "Issue occured fetching images, please try again later!!"));
              } else {
                print("fetching success");
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  itemCount: snapshot.data.toSet().length,
                  itemBuilder: (BuildContext context, int index) =>
                      new ListItem(snapshot.data.elementAt(index)),
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                );
              }
              break;

            default:
              print("fetching default");
              return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
} // PhotosList(photos: snapshot.data)

class ListItem extends StatelessWidget {
  Photo photo;

  ListItem(Photo photo) {
    this.photo = photo;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openFullViewPage(context, photo);
      },
      child: Card(
        child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: <Widget>[
                Hero(
                    tag: "photo" + photo.thumbnailUrl.toString(),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Image(
                          image: CachedNetworkImageProvider(
                            photo.smallUrl,
                          ),
                        ),
                      ),
                    )),
//                Text("hi"),
//                photo.title
//                RaisedButton(
//                  child: Text("full view"),
//                  onPressed: () {
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => SecondRoute(photo)),
//                    );
//                  },
//                ),
              ],
            )),
      ),
    );
  }

  void openFullViewPage(BuildContext context, Photo photo) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondRoute(photo)),
    );
  }
}

class SecondRoute extends StatelessWidget {
  Photo photo;

  SecondRoute(Photo photo) {
    this.photo = photo;
  }

  @override
  Widget build(BuildContext context) {
//    Wallpaper.ImageDownloadProgress();
//    Wallpaper.homeScreen();
    return Scaffold(
      body: Hero(
        tag: "photo" + photo.thumbnailUrl.toString(),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(photo.largeUrl),
                fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
