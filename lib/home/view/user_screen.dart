import 'package:health/health.dart';
import 'package:flutter/material.dart';
import 'dart:core';

enum UserState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
}

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<HealthDataPoint> _healthDataList = [];
  double _sum = 0.0;
  UserState _state = UserState.DATA_NOT_FETCHED;
  HealthFactory health = HealthFactory();

  @override
  void initState() {
    super.initState();
  }

  Future fetchData() async {
    setState(() {
      _state = UserState.FETCHING_DATA;
    });
    final types = [
      HealthDataType.DISTANCE_WALKING_RUNNING,
    ];
    final permissions = [
      HealthDataAccess.READ,
    ];
    bool requested =
        await health.requestAuthorization(types, permissions: permissions);
    final now = DateTime.now();
    if (requested) {
      try {
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
            DateTime(now.year, now.month, now.day, 0, 0, 0),
            DateTime(now.year, now.month, now.day, 23, 59, 59),
            types);
        _healthDataList.addAll(healthData);
        _healthDataList = HealthFactory.removeDuplicates(_healthDataList);
        _healthDataList.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
        for (var i = 0; i < _healthDataList.length; i++) {
          _sum += double.parse(_healthDataList[i].value.toString());
        }
        _sum = _sum / 1000;
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }
      setState(() {
        _state =
            _healthDataList.isEmpty ? UserState.NO_DATA : UserState.DATA_READY;
      });
    } else {
      setState(() {
        _state = UserState.DATA_NOT_FETCHED;
      });
    }
  }

  Widget _content() {
    if (_state == UserState.FETCHING_DATA)
      return _contentFetchingData();
    else if (_state == UserState.NO_DATA)
      return _contentNoData();
    else if (_state == UserState.DATA_READY)
      return _contentDataReady();
    else
      return _contentNotFetched();
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(strokeWidth: 10)),
        Text("Fetching data ...")
      ],
    );
  }

  Widget _contentDataReady() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
          margin: const EdgeInsets.all(5.0),
          child: Container(
              margin: const EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: Column(children: [
                const Text(
                  '本日の歩行総距離',
                  style: TextStyle(fontSize: 35),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  '${_sum.toStringAsFixed(3)} (km)',
                  style: TextStyle(fontSize: 50),
                ),
              ]))),
      Flexible(
          child: ListView.builder(
              itemCount: _healthDataList.length,
              itemBuilder: (_, index) {
                HealthDataPoint p = _healthDataList[index];
                if (p.value is AudiogramHealthValue) {
                  return ListTile(
                    title: Text("${p.typeString}: ${p.value}"),
                    trailing: Text('${p.unitString}'),
                    subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
                  );
                }
                if (p.value is WorkoutHealthValue) {
                  return ListTile(
                    title: Text(
                        "${p.typeString}: ${(p.value as WorkoutHealthValue).totalEnergyBurned} ${(p.value as WorkoutHealthValue).totalEnergyBurnedUnit?.typeToString()}"),
                    trailing: Text(
                        '${(p.value as WorkoutHealthValue).workoutActivityType.typeToString()}'),
                    subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
                  );
                }
                return Card(
                  margin: const EdgeInsets.all(5.0),
                  child: Container(
                      margin: const EdgeInsets.all(10.0),
                      width: 300,
                      height: 100,
                      child: Column(children: [
                        Text(
                          '${p.dateFrom.hour.toString().padLeft(2, "0")}:${p.dateFrom.minute.toString().padLeft(2, "0")}:${p.dateFrom.second.toString().padLeft(2, "0")}~${p.dateTo.hour.toString().padLeft(2, "0")}:${p.dateTo.minute.toString().padLeft(2, "0")}:${p.dateTo.second.toString().padLeft(2, "0")}',
                          style: TextStyle(fontSize: 30),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          "${double.parse(p.value.toString()).toStringAsFixed(1)} (m)",
                          style: TextStyle(fontSize: 20),
                        ),
                      ])),
                );
              }))
    ]);
  }

  Widget _contentNoData() {
    return Text('No Data to show');
  }

  Widget _contentNotFetched() {
    return Column(
      children: [
        Text('Press the download button to fetch data.'),
        const SizedBox(
          height: 25,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 5),
              borderRadius: BorderRadius.circular(10)),
          child: IconButton(
            onPressed: () {
              fetchData();
            },
            icon: Icon(Icons.download),
            iconSize: 50,
          ),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _content());
  }
}
