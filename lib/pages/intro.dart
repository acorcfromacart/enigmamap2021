import 'package:enigmamap520/models/validation.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  Function goToTab;

  @override
  void initState() {
    super.initState();
    checkPref();
    slides.add(
      new Slide(
        title: "Avistamentos",
        styleTitle: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "Todos os avestimentos enviados pelos usuários incluindo as notícias são verificados e analisados.",
        styleDescription: TextStyle(color: Colors.black87, fontSize: 20.0, fontFamily: 'Raleway'),
        pathImage: "images/slide1.png",
      ),
    );
    slides.add(
      new Slide(
        title: "Localizações no mapa",
        styleTitle: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold),
        description:
            "Acesse os avistamentos de forma mais fácil diretamente no nosso mapa intuitivo.",
        styleDescription: TextStyle(color: Colors.black87, fontSize: 20.0, fontFamily: 'Raleway'),
        pathImage: "images/slide2.png",
      ),
    );
    slides.add(
      new Slide(
        title: "Notificações",
        styleTitle: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold),
        description:
            "Receba notificações em tempo real sempre que houver algum avistamento ou notícia sobre OVNIs.",
        styleDescription: TextStyle(color: Colors.black87, fontSize: 20.0),
        pathImage: "images/slide3.png",
      ),
    );
  }

  void onDonePress() {
    // Back to the first tab
    this.goToTab(0);
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Colors.white,
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Colors.white,
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Colors.white,
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                  child: Image.asset(
                currentSlide.pathImage,
                width: 200.0,
                height: 200.0,
                fit: BoxFit.contain,
              )),
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              Container(
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // List slides
      // slides: this.slides,

      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Colors.black87,
      highlightColorSkipBtn: Colors.black87,

      // Next button
      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: (){
        checkFirstSeen();
      },
      colorDoneBtn: Colors.black87,
      highlightColorDoneBtn: Colors.black87,

      // Dot indicator
      colorDot: Colors.black87,
      sizeDot: 13.0,
      //typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

      // Tabs
      listCustomTabs: this.renderListCustomTabs(),
      backgroundColorAllSlides: Colors.white,
      refFuncGoToTab: (refFunc) {
        this.goToTab = refFunc;
      },

      // Behavior
      scrollPhysics: BouncingScrollPhysics(),

    );
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true);
    Navigator.of(context)
        .pushReplacement(new MaterialPageRoute(builder: (context) => new ValidationScreen()));
  }

  Future checkPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      Navigator.of(context)
          .pushReplacement(new MaterialPageRoute(builder: (context) => new ValidationScreen()));
    }
  }
}
