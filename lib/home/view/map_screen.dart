import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trace_health/home/view/weight_screen.dart';

class firestoreObject {
  final latitude;
  final longitude;
  final occured_at;

  firestoreObject({this.latitude, this.longitude, this.occured_at});
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(35.5728957, 139.3900851),
    zoom: 14,
  );

  Map<String, Marker> markers = {};
  List<LatLng> latlng = [];
  Map<String, Polyline> polyline = {};
  List<firestoreObject> snapshotDocs = [];

  void _getLocationSet(LatLng pos) async {
    DateTime now = DateTime.now();
    final snapshot = await FirebaseFirestore.instance
        .collection("location")
        .doc("${FirebaseAuth.instance.currentUser?.email}")
        .collection("${now.year}年${now.month}月")
        .get();

    snapshot.docs.forEach(
      (element) {
        var firestoreobj = firestoreObject(
            latitude: element["latitude"],
            longitude: element["longitude"],
            occured_at: element["occured_at"]);
        snapshotDocs.add(firestoreobj);
      },
    );
    snapshotDocs.sort((a, b) => a.occured_at.compareTo(b.occured_at));
    // var locationList = await LocationDBModel.instance.selectTodaylocations();
    setState(() {
      for (var f in snapshotDocs) {
        latlng.add(LatLng(f.latitude, f.longitude));
        markers[f.occured_at.toString()] = Marker(
            markerId: MarkerId(f.occured_at.toString()),
            infoWindow: InfoWindow(title: f.occured_at.toString()),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: LatLng(f.latitude, f.longitude));
      }
      polyline = {
        DateTime.now().toIso8601String(): Polyline(
          polylineId: const PolylineId("test"),
          visible: true,
          points: latlng,
          color: Colors.green,
        )
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        new Factory<OneSequenceGestureRecognizer>(
          () => new EagerGestureRecognizer(),
        ),
      ].toSet(),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      initialCameraPosition: _initialCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        GoogleMapController _googleMapController = controller;
      },
      markers: markers.values.toSet(),
      polylines: polyline.values.toSet(),
      onLongPress: _getLocationSet,
    );
  }
}
