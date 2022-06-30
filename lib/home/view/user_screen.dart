import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[350],
      child: ListView(children: [
        Card(
            margin: const EdgeInsets.all(5.0),
            child: Container(
                margin: const EdgeInsets.all(10.0),
                width: 300,
                height: MediaQuery.of(context).size.height / 3,
                child: Column(children: [
                  const Text(
                    '本日の歩行総距離',
                    style: TextStyle(fontSize: 35),
                  ),
                  Text(
                    4.6.toString() + "(km)",
                    style: TextStyle(fontSize: 50),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    '消費カロリー',
                    style: TextStyle(fontSize: 35),
                  ),
                  Text(
                    (4.6 * 40).toString() + "(kcal)",
                    style: TextStyle(fontSize: 50),
                  ),
                ]))),
        const SizedBox(
          height: 10,
        ),
        Card(
          margin: const EdgeInsets.all(5.0),
          child: Container(
              margin: const EdgeInsets.all(10.0),
              width: 300,
              height: 100,
              child: Column(children: [
                const Text(
                  '12:00~12:15',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  "0.8 km",
                  style: TextStyle(fontSize: 20),
                ),
              ])),
        ),
        Card(
          margin: const EdgeInsets.all(5.0),
          child: Container(
              margin: const EdgeInsets.all(10.0),
              width: 300,
              height: 100,
              child: Column(children: [
                Text(
                  '12:15~12:30',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "1.1 km",
                  style: TextStyle(fontSize: 20),
                ),
              ])),
        ),
        Card(
          margin: const EdgeInsets.all(5.0),
          child: Container(
              margin: const EdgeInsets.all(10.0),
              width: 300,
              height: 100,
              child: Column(children: [
                Text(
                  '12:30~12:45',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "1.2 km",
                  style: TextStyle(fontSize: 20),
                ),
              ])),
        ),
        Card(
          margin: const EdgeInsets.all(5.0),
          child: Container(
              margin: const EdgeInsets.all(10.0),
              width: 300,
              height: 100,
              child: Column(children: [
                Text(
                  '12:45~13:00',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "1.5 km",
                  style: TextStyle(fontSize: 20),
                ),
              ])),
        ),
      ]),
    );
  }
}
