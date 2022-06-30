import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  // void _getLocationSet(LatLng pos) async {
  //   var locationList = await LocationDBModel.instance.selectTodaylocations();
  //   setState(() {
  //     for (var location in locationList) {
  //       latlng.add(LatLng(location.latitude, location.longitude));
  //       markers[location.id.toString()] = Marker(
  //           markerId: MarkerId(location.time.toString()),
  //           infoWindow: InfoWindow(title: location.time.toIso8601String()),
  //           icon: BitmapDescriptor.defaultMarkerWithHue(
  //               BitmapDescriptor.hueGreen),
  //           position: LatLng(location.latitude, location.longitude));
  //     }
  //     polyline = {
  //       DateTime.now().toIso8601String(): Polyline(
  //         polylineId: const PolylineId("test"),
  //         visible: true,
  //         points: latlng,
  //         color: Colors.green,
  //       )
  //     };
  //   });
  // }

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
      // onLongPress: _getLocationSet,
    );
  }
}
