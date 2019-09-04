import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: ListPage(),
  ));
}

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
      ),
      body: ListView.builder(  itemBuilder: (context, position) {
        return ListItem(position);
      }),
    );
  }
}

String photo1 = 'images/royal_enfield.jpg';
String photo2 = 'images/royal_enfield_2.jpg';
String photo3 = 'images/royal_enfield_3.jpg';

class ListItem extends StatelessWidget {
  int count;

  ListItem(int count) {
    this.count = count;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openFullViewPage(context, count);
      },
      child: Card(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Hero(
                    tag: "photo" + count.toString(),
                    child: Center(
                      child: Image(
                        image: AssetImage(
                            count == 0 ? photo1 : count == 1 ? photo2 : photo3),
                        width: 200,
                        height: 100,
                      ),
                    )),
                Text(count.toString()),
                RaisedButton(
                  child: Text("full view"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SecondRoute(count)),
                    );
                  },
                ),
              ],
            )),
      ),
    );
  }

  void openFullViewPage(BuildContext context, int count) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondRoute(count)),
    );
  }
}

class SecondRoute extends StatelessWidget {
  int count;

  SecondRoute(int count) {
    this.count = count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Column(
        children: <Widget>[
          Hero(
            tag: "photo" + count.toString(),
            child: Image(
              image: AssetImage(
                  count == 0 ? photo1 : count == 1 ? photo2 : photo3),
              width: 600,
              height: 300,
            ),
          ),
          Text(count.toString() +
              " : ioasfoas dofo sfas odfioa sfh oa\n asd aoijsdioas jdjasio djoaja \n aosdjoas jd"),
        ],
      ),
    );
  }
}
