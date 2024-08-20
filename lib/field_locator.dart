import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:location/location.dart';
import 'package:mithran/field_locator_form.dart';
import 'package:mithran/utils/snackbar.dart';
import 'package:geocoding/geocoding.dart' as geoencoder;

class FieldLocator extends StatefulWidget {
  const FieldLocator({super.key});

  @override
  _FieldLocatorState createState() => _FieldLocatorState();
}

class _FieldLocatorState extends State<FieldLocator> {
  TextEditingController controller = TextEditingController();
  google_maps.GoogleMapController? _controller;
  final Location _location = Location();
  final Set<google_maps.Marker> _markers = {};
  google_maps.LatLng? _currentLocation;
  String? _mapStyle;
  String? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _getCurrentLocation();
  }

  void _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map_style.txt');
  }

  void _getCurrentLocation() async {
    try {
      LocationData locationData = await _location.getLocation();
      setState(() {
        _currentLocation =
            google_maps.LatLng(locationData.latitude!, locationData.longitude!);
      });
    } catch (e) {
      print('Could not get current location: $e');
    }
  }

  void _onMapCreated(google_maps.GoogleMapController controller) {
    _controller = controller;
    if (_mapStyle != null) {
      _controller!.setMapStyle(_mapStyle);
    }
  }

  Future<void> _onTap(google_maps.LatLng point) async {
    setState(() {
      _currentLocation = point;
      if (_markers.isNotEmpty) _markers.clear();
      _markers.add(
        google_maps.Marker(
          markerId: google_maps.MarkerId(point.toString()),
          position: point,
        ),
      );
    });
    List<geoencoder.Placemark> placemarks =
        await geoencoder.placemarkFromCoordinates(
            _markers.first.position.latitude,
            _markers.first.position.longitude);
    geoencoder.Placemark place = placemarks[0];
    setState(() {
      _selectedAddress = "${place.street}, ${place.locality}, ${place.country}";
      print(_selectedAddress);
      controller.text = _selectedAddress!;
    });
  }

  void _moveCameraToPosition(google_maps.LatLng latLng) {
    _controller?.animateCamera(
      google_maps.CameraUpdate.newLatLngZoom(latLng, 15),
    );
    _onTap(latLng);
  }

  Future<void> _saveLocation() async {
    if (_markers.isNotEmpty) {
      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FieldLocatorForm(location: controller.text, currentLocation: _markers.first.position,)),
            );
      print(
          'Location saved: ${_markers.first.position.latitude}, ${_markers.first.position.longitude}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(buildCustomSnackBar(
          context: context,
          message: "Please mark your field to proceed!!",
          type: SnackBarType.failure));
    }
  }

  @override
  Widget build(context) {
    return (Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 40),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Field Location",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            Text(
              "Step 1 of 2",
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins",
                  color: Color.fromRGBO(110, 110, 110, 1)),
            ),
          ],
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        titleSpacing: 5,
      ),
      body: Column(
        children: [
          Container(
            height: 85,
            width: double.infinity,
            color: Colors.white,
            child: GooglePlaceAutoCompleteTextField(
              boxDecoration: BoxDecoration(border: Border.all(width: 0)),
              textEditingController: controller,
              googleAPIKey: "AIzaSyC2TVVHf30LElef9FuC6DvHhF_7WXL6_Ig",
              textStyle: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                  fontSize: 17),
              inputDecoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 14.0),
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.black54),
                  onPressed: () {
                    setState(() {
                      controller.clear();
                      _markers.clear();
                    });
                  },
                ),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              debounceTime: 800,
              countries: const ["in"],
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (Prediction prediction) {
                _currentLocation = google_maps.LatLng(
                    double.parse(prediction.lat!),
                    double.parse(prediction.lng!));
                _moveCameraToPosition(_currentLocation!);
              },
              itemClick: (Prediction prediction) {
                controller.text = prediction.description!;
                controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: prediction.description!.length));
              },
              itemBuilder: (context, index, Prediction prediction) {
                return Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const Icon(Icons.add_location_alt_outlined),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Text(
                        prediction.description ?? "",
                        style: const TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 17),
                      ))
                    ],
                  ),
                );
              },
              seperatedBuilder: const Divider(
                indent: 0,
                height: 0,
              ),
              isCrossBtnShown: false,
              containerHorizontalPadding: 10,
              placeType: PlaceType.geocode,
            ),
          ),
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.68,
              child: google_maps.GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: google_maps.CameraPosition(
                  target: _currentLocation ??
                      const google_maps.LatLng(12.7495076, 80.198654),
                  zoom: 10.0,
                ),
                markers: _markers,
                onTap: _onTap,
                mapType: google_maps.MapType.hybrid,
                zoomControlsEnabled: true,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
        height: 90,
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () {
            _saveLocation();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            backgroundColor: const Color.fromRGBO(0, 85, 184, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            "Save location",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.white, // Text color
            ),
          ),
        ),
      ),
    ));
  }
}
