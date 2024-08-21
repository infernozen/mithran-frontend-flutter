import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapPreview extends StatefulWidget {
  final double latitude;
  final double longitude;
  String place;
  MapPreview(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.place});
  @override
  _MapPreviewState createState() => _MapPreviewState();
}

class _MapPreviewState extends State<MapPreview> {
  String _placeName = "Loading ....";
  LatLng _location = LatLng(0.0, 0.0);
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _location = LatLng(widget.latitude, widget.longitude);
    _placeName = widget.place;
  }

  @override
  void didUpdateWidget(MapPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      if (widget.latitude != oldWidget.latitude ||
          widget.longitude != oldWidget.longitude) {
        _location = LatLng(widget.latitude, widget.longitude);

        print(widget.latitude);
        print(widget.longitude);
        _placeName = widget.place;
        _moveCamera();
      }
    });
  }

  void _moveCamera() {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _location, zoom: 18),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final containerHeight = screenHeight * 0.20;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: [
          Container(
            height: containerHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GoogleMap(
                mapType: MapType.satellite,
                initialCameraPosition: CameraPosition(
                  target: _location,
                  zoom: 18,
                ),
                zoomControlsEnabled: false,
                markers: Set<Marker>.of(<Marker>[
                  Marker(
                    markerId: MarkerId('someId'),
                    position: _location,
                    infoWindow: InfoWindow(title: 'Location'),
                  ),
                ]),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              width: 200,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.locationDot,
                    size: 16,
                    color: Color.fromARGB(255, 30, 30, 31),
                  ),
                  SizedBox(width: 5),
                  SizedBox(
                    width: 150,
                    child: Text(
                      _placeName,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Poppins",
                          color: Colors.grey[800],
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
