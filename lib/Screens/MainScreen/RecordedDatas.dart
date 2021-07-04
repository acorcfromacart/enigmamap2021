import 'package:enigmamap520/Models/stats_model.dart';
import 'package:enigmamap520/translation/localizations.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class RecordedData extends StatefulWidget {
  @override
  _RecordedDataState createState() => _RecordedDataState();
}

class _RecordedDataState extends State<RecordedData> {
  @override
  void initState() {
    getAmount().asStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/map');
                  }),
              backgroundColor: Colors.black,
              title: Text(
                'Dados registrados',
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: IconThemeData(color: Colors.black),
            ),
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Image.asset(
                    'images/background_recorded.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        amountOfPosts.toString(),
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 120,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 30),
                        child: Text(
                          AppLocalizations.instance.translate("event_reg"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 36),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Text(
                          AppLocalizations.instance.translate("event_reg_desc"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 21,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: ClipOval(
                          child: Material(
                            color: Color(0xFF372626), // button color
                            child: InkWell(
                              splashColor: Colors.grey, // inkwell color
                              child: SizedBox(
                                width: 96,
                                height: 96,
                                child: Icon(
                                  Icons.share_outlined,
                                  color: Colors.white70,
                                  size: 38,
                                ),
                              ),
                              onTap: () {
                                Share.share(
                                    AppLocalizations.instance.translate("share_app"));
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
