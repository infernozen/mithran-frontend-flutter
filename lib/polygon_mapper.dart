import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:latlong2/latlong.dart' as latlong;
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/snackbar.dart';

const double EARTH_RADIUS = 6371000.0;
const double SQM_TO_ACRES = 0.000247105;

class PolygonMap extends StatefulWidget {
  google_maps.LatLng currentLocation;
  Function(List<google_maps.LatLng> polygonLatLngs, String size)
      setMappingAndFieldSize;

  PolygonMap(
      {super.key,
      required this.currentLocation,
      required this.setMappingAndFieldSize});

  @override
  _PolygonMapState createState() => _PolygonMapState();
}

class _PolygonMapState extends State<PolygonMap> {
  google_maps.GoogleMapController? _controller;
  final List<google_maps.LatLng> _polygonLatLngs = [];
  final Set<google_maps.Polygon> _polygons = {};
  final Set<google_maps.Marker> _markers = {};
  double _area = 0.0;
  double _perimeter = 0.0;
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
  }

  void _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map_style.txt');
  }

  void _onMapCreated(google_maps.GoogleMapController controller) {
    _controller = controller;
    if (_mapStyle != null) {
      _controller!.setMapStyle(_mapStyle);
    }
  }

  void _onTap(google_maps.LatLng point) {
    setState(() {
      _polygonLatLngs.add(point);
      _markers.add(
        // add your custom marker logic here
        google_maps.Marker(
          icon: google_maps.BitmapDescriptor.defaultMarkerWithHue(
              google_maps.BitmapDescriptor.hueGreen),
          markerId: google_maps.MarkerId(point.toString()),
          position: point,
        ),
      );
      if (_polygonLatLngs.length > 2) {
        _polygons.add(
          google_maps.Polygon(
            polygonId: const google_maps.PolygonId('polygon_0'),
            points: _polygonLatLngs,
            strokeWidth: 2,
            strokeColor: Colors.green,
            fillColor: Colors.green.withOpacity(0.2),
          ),
        );
        _area = _calculatePolygonArea(_polygonLatLngs);
        _perimeter = _calculatePolygonPerimeter(_polygonLatLngs);
        _savePolygons();
      }
    });
  }

  double _calculatePolygonArea(List<google_maps.LatLng> points) {
    if (points.length < 3) return 0.0;

    double area = 0.0;
    int j = points.length - 1;

    for (int i = 0; i < points.length; i++) {
      double lon1 = _toRadians(points[j].longitude);
      double lat1 = _toRadians(points[j].latitude);
      double lon2 = _toRadians(points[i].longitude);
      double lat2 = _toRadians(points[i].latitude);

      area += (lon1 - lon2) * (2 + sin(lat2) + sin(lat1));
      j = i;
    }

    return area.abs() * EARTH_RADIUS * EARTH_RADIUS / 2.0;
  }

  double _calculatePolygonPerimeter(List<google_maps.LatLng> points) {
    if (points.length < 2) return 0.0;

    final latlongPoints =
        points.map((p) => latlong.LatLng(p.latitude, p.longitude)).toList();
    const distance = latlong.Distance();

    double perimeter = 0.0;
    for (int i = 0; i < latlongPoints.length; i++) {
      final p1 = latlongPoints[i];
      final p2 = latlongPoints[(i + 1) % latlongPoints.length];
      perimeter += distance(p1, p2);
    }

    return perimeter;
  }

  double _toRadians(double degree) {
    return degree * (pi / 180.0);
  }

  void _savePolygons() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, double>> polygonData = _polygonLatLngs
        .map((latLng) => {
              'latitude': latLng.latitude,
              'longitude': latLng.longitude,
            })
        .toList();
    await prefs.setString('polygon_data', json.encode(polygonData));
  }

  // void _loadPolygons() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? polygonDataString = prefs.getString('polygon_data');
  //   if (polygonDataString != null) {
  //     List<dynamic> polygonData = json.decode(polygonDataString);
  //     setState(() {
  //       _polygonLatLngs = polygonData
  //           .map((data) => google_maps.LatLng(
  //                 data['latitude'],
  //                 data['longitude'],
  //               ))
  //           .toList();
  //       _polygons.add(
  //         google_maps.Polygon(
  //           polygonId: const google_maps.PolygonId('polygon_0'),
  //           points: _polygonLatLngs,
  //           strokeWidth: 2,
  //           strokeColor: Colors.orangeAccent,
  //           fillColor: Colors.orange.withOpacity(0.2),
  //         ),
  //       );
  //       _area = _calculatePolygonArea(_polygonLatLngs);
  //       _perimeter = _calculatePolygonPerimeter(_polygonLatLngs);
  //       _markers = _polygonLatLngs
  //           .map((point) => google_maps.Marker(
  //                 markerId: google_maps.MarkerId(point.toString()),
  //                 position: point,
  //               ))
  //           .toSet();
  //     });
  //   }
  // }

  void _reMap() {
    if (_area > 0.0) {
      widget.setMappingAndFieldSize(
          _polygonLatLngs, (_area * SQM_TO_ACRES).toStringAsFixed(2));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(buildCustomSnackBar(
          context: context,
          message: "Please mark your field to proceed!!",
          type: SnackBarType.failure));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          google_maps.GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: google_maps.CameraPosition(
              target: widget.currentLocation,
              zoom: 18.0,
            ),
            polygons: _polygons,
            markers: _markers,
            onTap: _onTap,
            mapType: google_maps.MapType.satellite,
            zoomControlsEnabled: false,
          ),
          Positioned(
              top: 0,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            weight: 800,
                            size: 28,
                          ),
                          onPressed: () {
                            // Non-functional back button
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Map My Farm',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 75,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.info_outlined,
                            color: Colors.white,
                            weight: 800,
                            size: 28,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.replay_sharp,
                            color: Colors.white,
                            weight: 800,
                            size: 28,
                          ),
                          onPressed: () {
                            setState(() {
                              _polygonLatLngs.clear();
                              _polygons.clear();
                              _markers.clear();
                              _area = 0.0;
                              _perimeter = 0.0;
                              _savePolygons();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          if (_area > 0)
            Positioned(
              top: 60,
              left: 20,
              right: 15,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(104, 153, 1, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Perimeter',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              '${_perimeter.toStringAsFixed(2)} meters',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Area',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              '${(_area * SQM_TO_ACRES).toStringAsFixed(2)} acres',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
        color: Colors.white,
        height: 90,
        child: Row(
          children: [
            Container(
              width: 185,
              margin: const EdgeInsets.all(2),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _markers.removeWhere(
                        (marker) => marker.position == _polygonLatLngs.last);
                    _polygonLatLngs.removeLast();
                    _polygons.clear();
                    if (_polygonLatLngs.length > 2) {
                      _polygons.add(
                        google_maps.Polygon(
                          polygonId: const google_maps.PolygonId('polygon_0'),
                          points: _polygonLatLngs,
                          strokeWidth: 2,
                          strokeColor: Colors.green,
                          fillColor: Colors.green.withOpacity(0.2),
                        ),
                      );
                      _area = _calculatePolygonArea(_polygonLatLngs);
                      _perimeter = _calculatePolygonPerimeter(_polygonLatLngs);
                    } else {
                      _area = 0.0;
                      _perimeter = 0.0;
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Color(0XFF0055B8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const SizedBox(
                  width: 72,
                  child: Row(
                    children: [
                      Icon(
                        Icons.undo,
                        color: Color(0XFF0055B8),
                        size: 24,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Undo',
                        style: TextStyle(
                            color: Color(0XFF0055B8),
                            fontSize: 15,
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 185,
              child: ElevatedButton(
                onPressed: _reMap,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: const Color(0XFF0055B8),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text(
                  'Save boundary',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
