import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'ABout Us',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          foregroundColor: Colors.black,
          centerTitle: true,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent),
      body: Container(
          width: 300,
          height: 300,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: Color.fromARGB(138, 237, 234, 234),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Text(
                  'About Us',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  selectionColor: Colors.amber,
                ),
                Container(
                  height: 20,
                  width: 20,
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(color: Colors.amber),
                )
              ],
            ),
          )),
    );
  }
}
