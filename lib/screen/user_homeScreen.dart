import 'package:flutter/material.dart';

List<String> image = [
  'https://cdn.pixabay.com/photo/2021/06/01/07/03/sparrow-6300790_960_720.jpg',
  'https://cdn.pixabay.com/photo/2017/10/20/10/58/elephant-2870777_960_720.jpg',
  'https://cdn.pixabay.com/photo/2014/09/08/17/32/humming-bird-439364_960_720.jpg',
  'https://cdn.pixabay.com/photo/2018/05/03/22/34/lion-3372720_960_720.jpg'
];
List<String> title = ['Sparrow', 'Elephant', 'Humming Bird', 'Lion'];

class user_homeLogin extends StatelessWidget {
  const user_homeLogin({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 29, 116, 183),
                    width: 0.0,
                  ),
                ),
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7, // Adjust as needed
              ),
              itemCount: image.length,
              itemBuilder: (BuildContext context, int index) {
                return CardItem(image: image[index], title: title[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final String image;
  final String title;

  const CardItem({required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.yellow[50],
      elevation: 8.0,
      margin: EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(0.0),
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(0.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: user_homeLogin()));
}
