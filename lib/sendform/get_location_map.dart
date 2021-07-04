import 'package:enigmamap520/SendForm/send_map_form.dart';
import 'package:enigmamap520/translation/localizations.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class GetMapLocationScreen extends StatefulWidget {

  GetMapLocationScreen({Key key})
      : super(key: key);

  @override
  _GetMapLocationScreenState createState() => _GetMapLocationScreenState();
}

class _GetMapLocationScreenState extends State<GetMapLocationScreen> {
  List<Marker> _markers = [];
  GoogleMapController mapController;
  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;
  bool tapOnMap = false;

  String dLatitude;
  String dLongitude;

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.instance.translate('mark_the_place'),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                markers: Set.from(_markers),
                zoomGesturesEnabled: true,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(-10.105430, -49.306582),
                ),
                onTap: _handleTap,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
              ),
            ),
          ),
          tapOnMap == true
              ? _buttonSend()
              : SizedBox(
            height: 0,
          ),
        ],
      ),
    );
  }

  _handleTap(LatLng point) {
    _markers.clear();
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: 'Esse é o lugar do avistamento',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));

      //getting coordinates numbers and IT´S WORKING
      // var lat = double.tryParse(point.latitude.toString());
      // var long = double.tryParse(point.longitude.toString());

      String lat = point.latitude.toString();
      String long = point.longitude.toString();
      dLatitude = lat;
      dLongitude = long;

      print(lat);
      print(long);
    });
    tapOnMap = true;
  }

  _buttonSend() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SendForm(
                  latitude: dLatitude,
                  longitude: dLongitude,
                )));
      },
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff111724),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    AppLocalizations.instance.translate('fill_the_fields'),
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getCurrentPosition() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(position.latitude, position.longitude), zoom: 18),
        ));
      });
    }).catchError((e) {
      print(e);
    });
  }
}