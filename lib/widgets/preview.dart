import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapPreview extends StatefulWidget {
  final double latitude;
  final double longitude;
  MapPreview({super.key, required this.latitude, required this.longitude});
  @override
  _MapPreviewState createState() => _MapPreviewState();
}

class _MapPreviewState extends State<MapPreview> {
  String _placeName = 'Loading...';
  LatLng _location = LatLng(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    _location = LatLng(widget.latitude, widget.longitude);
    _getPlaceName();
  }

  @override
  void didUpdateWidget(MapPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.latitude != oldWidget.latitude ||
        widget.longitude != oldWidget.longitude) {
      _location = LatLng(widget.latitude, widget.longitude);
      print(widget.latitude);
      print(widget.longitude);
      _getPlaceName();
    }
  }

  Future<void> _getPlaceName() async {
    print(_location.latitude);
    print(_location.longitude);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _location.latitude,
        _location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        setState(() {
          _placeName = [place.locality, place.administrativeArea]
              .where((element) => element != null && element.isNotEmpty)
              .join(', ');

          if (_placeName.isEmpty) {
            _placeName = 'Unknown location';
          }
        });
      } else {
        setState(() {
          _placeName = 'No place found';
        });
      }
    } catch (e) {
      setState(() {
        _placeName = 'Error fetching location';
      });
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
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
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
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
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
                  Text(
                    _placeName,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins",
                      color: Colors.grey[800],
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
