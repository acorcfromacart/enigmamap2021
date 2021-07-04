import 'package:enigmamap520/translation/localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const _url = 'https://play.google.com/store/apps/details?id=com.fivetwozeroapps.enima_map_pro';

class ProVersion extends StatefulWidget {
  @override
  _ProVersionState createState() => _ProVersionState();
}

class _ProVersionState extends State<ProVersion> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2.2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('images/back_pro.png')),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20))),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_outlined,
                        size: 32,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/map');
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 72, left: 21, right: 80),
                  child: Text(
                    AppLocalizations.instance.translate("pro_text"),
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 120,
                  child: Image.asset(
                    'images/alien_pro.png',
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2.8,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 32),
              child: Row(
                children: [
                  Icon(
                    Icons.update_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 32,
                  ),
                  Flexible(
                    child: Text(
                      AppLocalizations.instance.translate("first_pro"),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 32),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_none,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 32,
                  ),
                  Flexible(
                    child: Text(
                      AppLocalizations.instance.translate("second_pro"),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 32),
              child: Row(
                children: [
                  Icon(
                    Icons.new_releases_sharp,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 32,
                  ),
                  Flexible(
                    child: Text(
                      AppLocalizations.instance.translate("third_pro"),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 32, right: 32, top: 32, bottom: 32),
              child: Row(
                children: [
                  Icon(
                    Icons.gps_fixed_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 32,
                  ),
                  Flexible(
                    child: Text(
                      AppLocalizations.instance.translate("fouth_pro"),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 32, top: 32),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _launchURL,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(AppLocalizations.instance.translate("be_premium")),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

}
