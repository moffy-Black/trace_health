import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

enum WeightState {
  DATA_FETCHED,
  DATA_NOT_FETCHED,
}

class firestoreObject {
  final weight;
  final occured_at;

  firestoreObject({this.weight, this.occured_at});
}

class WeightScreen extends StatefulWidget {
  const WeightScreen({Key? key}) : super(key: key);

  @override
  _WeightScreen createState() => _WeightScreen();
}

class _WeightScreen extends State<WeightScreen> {
  Map snapshot = {};
  List<firestoreObject> snapshotDocs = [];
  List<FlSpot> weightList = [];
  List<String> dayList = [];
  bool showAvg = false;
  WeightState _state = WeightState.DATA_NOT_FETCHED;

  @override
  Widget build(BuildContext context) {
    return _content();
  }

  Widget _content() {
    if (_state == WeightState.DATA_FETCHED)
      return _contentFeched();
    else
      return _contentNotFetched();
  }

  Widget _contentFeched() {
    return Column(children: [
      LineChartWidget(),
      const SizedBox(height: 10),
      Flexible(
        child: ListView.builder(
            itemCount: snapshotDocs.length,
            itemBuilder: (_, index) {
              firestoreObject s = snapshotDocs[index];
              return Card(
                margin: const EdgeInsets.all(5.0),
                child: Container(
                    margin: const EdgeInsets.all(10.0),
                    width: 300,
                    height: 100,
                    child: Column(children: [
                      Text(
                        "${s.occured_at}",
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        "${s.weight}(kg)",
                        style: TextStyle(fontSize: 20),
                      ),
                    ])),
              );
            }),
      )
    ]);
  }

  Widget _contentNotFetched() {
    return ListView(children: [
      LineChartWidget(),
      const SizedBox(height: 50),
      Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 5),
              borderRadius: BorderRadius.circular(10)),
          child: IconButton(
            onPressed: () async {
              DateTime now = DateTime.now();

              final snapshot = await FirebaseFirestore.instance
                  .collection('weight')
                  .doc("${FirebaseAuth.instance.currentUser?.email}")
                  .collection("${now.year}年${now.month}月")
                  .get();

              snapshot.docs.forEach((element) {
                var firestoreobj = firestoreObject(
                    weight: element["weight"],
                    occured_at: element["occured_at"]);
                snapshotDocs.add(firestoreobj);
              });
              snapshotDocs.sort((a, b) => a.occured_at.compareTo(b.occured_at));
              snapshotDocs.asMap().forEach((int i, firestoreObject value) {
                int index = i;
                final w = value.weight - 45.0;
                weightList.add(FlSpot(index.toDouble(), w / 5));
                dayList.add(value.occured_at.toString().substring(8));
              });
              setState(() {
                _state = WeightState.DATA_FETCHED;
              });
            },
            icon: Icon(Icons.get_app),
            iconSize: 50,
          ))
    ]);
  }

  Widget LineChartWidget() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            color: Colors.lightBlue,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                right: 18.0, left: 12.0, top: 36, bottom: 0),
            child: AspectRatio(
              aspectRatio: 1.50,
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 5:
        text = const Text('5', style: style);
        break;
      case 10:
        text = const Text('10', style: style);
        break;
      case 15:
        text = const Text('15', style: style);
        break;
      case 20:
        text = const Text('20', style: style);
        break;
      case 25:
        text = const Text('25', style: style);
        break;
      case 30:
        text = const Text('30', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '45(kg)';
        break;
      case 1:
        text = '50(kg)';
        break;
      case 2:
        text = '55(kg)';
        break;
      case 3:
        text = '60(kg)';
        break;
      case 4:
        text = '65(kg)';
        break;
      case 5:
        text = '70(kg)';
        break;
      case 6:
        text = '75(kg)';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
              top: BorderSide(color: Color(0xff37434d), width: 1),
              bottom: BorderSide(color: Color(0xff37434d), width: 1))),
      minX: 0,
      maxX: 31,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          color: Colors.white,
          spots: weightList,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),
      ],
    );
  }
}
