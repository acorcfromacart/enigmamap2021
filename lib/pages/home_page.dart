import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enigmamap520/events/event.dart';
import 'package:enigmamap520/models/auth.dart';
import 'package:enigmamap520/translation/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:translator/translator.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///Translator
  final translator = GoogleTranslator();
  bool isTranslated = false;
  String descriptionTranslated;
  String _mapStyle;

  ///Navegador lateral
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ///Declaring
  Widget mapWindow = Container();
  GoogleMapController mapController;
  double screenWidth;
  BitmapDescriptor customIcon;
  String siteN;

  ScrollController sc;

  PanelController _pc = new PanelController();
  final double _initFabHeight = 120.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 70.0;

  bool processing;

  final spinkit = SpinKitChasingDots(
    color: Colors.white,
    size: 50.0,
  );

  @override
  void initState() {
    super.initState();
    processing = false;
    _fabHeight = _initFabHeight;
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 1.2),
            'images/alien_marker.png')
        .then((d) {
      customIcon = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Marker> locationsList = [];
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Categories')
            .where('CategoryName', isEqualTo: 'Ovnis')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return loading();

          DocumentSnapshot query = snapshot.data.docs[0];

          /// Construindo o slide direamente do build
          return WillPopScope(
            onWillPop: () async => false,
            child: SafeArea(
              child: Scaffold(
                key: _scaffoldKey,
                drawer: drawerList(),
                body: Stack(
                  children: [
                    SlidingUpPanel(
                      controller: _pc,
                      maxHeight: _panelHeightOpen,
                      minHeight: _panelHeightClosed,
                      parallaxEnabled: true,
                      renderPanelSheet: false,
                      parallaxOffset: .5,
                      body: _buildGoogleMap(context, query, locationsList),
                      panelBuilder: (sc) => _mapPopUp(sc),
                      onPanelSlide: (double pos) => setState(() {
                        _fabHeight =
                            pos * (_panelHeightOpen - _panelHeightClosed) +
                                _initFabHeight;
                      }),
                      onPanelClosed: () async {
                        isTranslated = false;
                      },
                    ),
                    topHeader(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  loading() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            spinkit,
            Text(
              AppLocalizations.instance.translate("map_load"),
              style: TextStyle(fontSize: 21, color: Colors.white),
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  drawerList() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: ListView(
              children: [
                imageUrl != null
                    ? CircleAvatar(
                        radius: 42,
                        child: ClipOval(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: 42,
                        child: ClipOval(
                          child: Image.network(
                            'https://i.pinimg.com/originals/45/03/47/450347b23049826628adb86af14c3871.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: name != null
                          ? Text(
                              name,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  letterSpacing: 1),
                              overflow: TextOverflow.ellipsis,
                            )
                          : Text(''),
                    ),
                    Image.asset(
                      'images/alien.png',
                      width: 26,
                      height: 26,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              ListTile(
                leading: Icon(Icons.leaderboard_outlined),
                title:
                    Text(AppLocalizations.instance.translate("drawer_first")),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/rec');
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title:
                    Text(AppLocalizations.instance.translate("drawer_about")),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/about');
                },
              ),
              ListTile(
                leading: Icon(Icons.stars),
                title: Text(AppLocalizations.instance.translate("pro")),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/pro');
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text("Adicionar avistamento"),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/add');
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title:
                    Text(AppLocalizations.instance.translate("drawer_logout")),
                onTap: () {
                  signOutWithGoogle(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  topHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20),
      child: Container(
        child: Row(
          children: [
            ClipOval(
              child: Material(
                color: Colors.white60, // button color
                child: InkWell(
                  splashColor: Colors.grey, // inkwell color
                  child: SizedBox(
                      width: 56, height: 56, child: Icon(Icons.menu_rounded)),
                  onTap: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///Building Marker
  Marker markerHelper(
    String longName,
    String shortName,
    GeoPoint loc,
  ) {
    return Marker(
        markerId: MarkerId(shortName),
        position: LatLng(loc.latitude, loc.longitude),
        icon: customIcon,
        onTap: () {
          setState(() {
            siteN = longName;
            mapWindow = _mapPopUp(sc);
          });
        });
  }

  Widget _mapPopUp(ScrollController sc) {
    return StreamBuilder(
      stream: firestore
          .collection("/Categories/Ovnis/Sites")
          .where('siteName', isEqualTo: siteN)
          .snapshots(),
      builder: (context, snapshot) {
        //This return While the map is Loading
        if (!snapshot.hasData)
          return Container(
            child: Center(
              child: Text(AppLocalizations.instance.translate("loading")),
            ),
          );
        DocumentSnapshot query = snapshot.data.docs[0];

        String title = query['title'];
        String imgURL = query['ImageURL'];
        String description = query['description'];
        String fonte = query['fontUrl'];

        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              child: ListView(
                controller: sc,
                children: [
                  Icon(
                    Icons.keyboard_arrow_up_outlined,
                    color: Colors.white70,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32, right: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imgURL,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 32, right: 32),
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imgURL,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 32, right: 32, top: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 52,
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.translate,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Translate to English',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.white,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                        onPressed: () {
                          setState(() {
                            translator
                                .translate(description, to: 'en')
                                .then((result) {
                              setState(() {
                                descriptionTranslated = result.text;
                                isTranslated = true;
                              });
                            });
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 32, right: 32, top: 24),
                    child: isTranslated == false
                        ? Text(
                            description,
                            textAlign: TextAlign.justify,
                            style:
                                TextStyle(color: Colors.white70, fontSize: 21),
                            softWrap: true,
                          )
                        : Text(
                            descriptionTranslated,
                            textAlign: TextAlign.justify,
                            style:
                                TextStyle(color: Colors.white70, fontSize: 21),
                            softWrap: true,
                          ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 32, right: 32, top: 24),
                    child: Text(
                      'Fonte: $fonte',
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.blueGrey),
                      softWrap: true,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ///Building map
  _buildGoogleMap(BuildContext context, DocumentSnapshot query,
      List<Marker> locationsList) {
    GeoPoint campusLoc = query['Location'];
    double campusZoom = query['Zoom'].toDouble();
    return StreamBuilder(
      stream: checkingCategory().asStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
              child: Text(AppLocalizations.instance.translate("loading")));
        for (int i = 0; i < snapshot.data.docs.length; i++) {
          DocumentSnapshot snap = snapshot.data.docs[i];
          locationsList.add(
              markerHelper(snap['siteName'], snap['title'], snap['location']));
        }
        return Column(
          children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  zoomGesturesEnabled: true,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(campusLoc.latitude, campusLoc.longitude),
                      zoom: campusZoom),
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    mapController.setMapStyle(_mapStyle);
                  },
                  markers: Set.from(locationsList),
                  onTap: (argument) async {
                    setState(() async {
                      mapWindow = Container();
                    });
                  },
                ),
              ),
            ),
            Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
            ),
          ],
        );
      },
    );
  }
}
