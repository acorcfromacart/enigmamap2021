import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Sobre',
              style: TextStyle(color: Colors.black87),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/map');
              },
            ),
          ),
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              SizedBox(
                height: 60,
              ),
              Center(
                child: Image.asset(
                  'images/ufo_down.png',
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.height / 4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(21.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('ENIGMA\nMAP',
                      style:
                      TextStyle(fontSize: 48, fontWeight: FontWeight.w500)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(21.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Encontre e descrubra lugares no mundo inteiro onde ocorreram avistamentos de Objetos Voadores Não Identificados.',
                    style: TextStyle(
                      fontSize: 21,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 62,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/privacy');
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('Política de privacidade', style: TextStyle(fontSize: 21),),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 62,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/terms');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Termos de uso', style: TextStyle(fontSize: 21)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
