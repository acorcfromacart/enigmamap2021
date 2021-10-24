import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = [];

  Function goToTab;

  @override
  void initState() {
    super.initState();
    checkPref();
    slides.add(
      Slide(
        title: 'Avistamentos',
        styleTitle: const TextStyle(
          color: Colors.white70,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
        ),
        description:
            'Todos os avestimentos enviados pelos usuários incluindo as notícias são verificados e analisados.',
        styleDescription: const TextStyle(
          color: Colors.white70,
          fontSize: 20.0,
          fontFamily: 'Raleway',
        ),
        pathImage: 'images/slide1.png',
      ),
    );
    slides.add(
      Slide(
        title: 'Localizações no mapa',
        styleTitle: const TextStyle(
          color: Colors.white70,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description:
            'Acesse os avistamentos de forma mais fácil diretamente no nosso mapa intuitivo.',
        styleDescription: const TextStyle(
          color: Colors.white70,
          fontSize: 20.0,
          fontFamily: 'Raleway',
        ),
        pathImage: 'images/slide2.png',
      ),
    );
    slides.add(
      Slide(
        title: 'Notificações',
        styleTitle: const TextStyle(
          color: Colors.white70,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description:
            'Receba notificações em tempo real sempre que houver algum avistamento ou notícia sobre OVNIs.',
        styleDescription: const TextStyle(
          color: Colors.white70,
          fontSize: 20.0,
        ),
        pathImage: 'images/slide3.png',
      ),
    );
  }

  void onDonePress() {
    // Back to the first tab
    goToTab(0);
  }

  void onTabChangeCompleted(dynamic index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return const Icon(
      Icons.navigate_next,
      color: Colors.white,
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return const Icon(
      Icons.done,
      color: Colors.white,
    );
  }

  Widget renderSkipBtn() {
    return const Icon(
      Icons.skip_next,
      color: Colors.white,
    );
  }

  List<Widget> renderListCustomTabs() {
    final List<Widget> tabs = [];
    for (int i = 0; i < slides.length; i++) {
      final Slide currentSlide = slides[i];
      tabs.add(
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            margin: const EdgeInsets.only(
              bottom: 60.0,
              top: 60.0,
            ),
            child: ListView(
              children: <Widget>[
                GestureDetector(
                  child: Image.asset(
                    currentSlide.pathImage,
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    currentSlide.title,
                    style: currentSlide.styleTitle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    currentSlide.description,
                    style: currentSlide.styleDescription,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return tabs;
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(
        const StadiumBorder(),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
        const Color(0x33F3B4BA),
      ),
      overlayColor: MaterialStateProperty.all<Color>(
        const Color(0x33FFA8B0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroSlider(
        // Show or hide status bar

        // Skip button
        renderSkipBtn: renderSkipBtn(),
        skipButtonStyle: myButtonStyle(),

        // Next button
        renderNextBtn: renderNextBtn(),
        nextButtonStyle: myButtonStyle(),

        // Done button
        renderDoneBtn: renderDoneBtn(),
        onDonePress: () {
          checkFirstSeen();
        },

        // Dot indicator
        colorDot: Colors.black87,
        colorActiveDot: Colors.white70,

        sizeDot: 13.0,
        //typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

        // Tabs
        listCustomTabs: renderListCustomTabs(),
        backgroundColorAllSlides: Colors.black87,
        refFuncGoToTab: (refFunc) {
          goToTab = refFunc;
        },

        // Behavior
        scrollPhysics: const BouncingScrollPhysics(),
      ),
    );
  }

  Future checkFirstSeen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true).then((value) {
      Navigator.pushNamed(context, '/validation');
    });
  }

  Future checkPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool _seen = prefs.getBool('seen') ?? false;
    if (_seen) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/validation');
    }
  }
}
