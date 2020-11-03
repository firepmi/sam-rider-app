import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class IntroPage extends StatefulWidget {
  IntroPage({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroPage> {
  List<Slide> slides = new List();

  Function goToTab;

  void initSlides(BuildContext context) {
    var style1 = TextStyle(
        color: Color(0xff29ba50),
        fontSize: AppConfig.size(context, 12),
        fontWeight: FontWeight.w900,
        fontFamily: 'RobotoMono');
    var style2 = TextStyle(
        color: Color(0xfff111111),
        fontSize: AppConfig.size(context, 12),
        fontWeight: FontWeight.w900,
        fontFamily: 'RobotoMono');
    slides.add(
      new Slide(
        title: "Get help with",
        styleTitle: style1,
        description: "everything in life",
        styleDescription: style2,
        pathImage: "assets/images/img_intro1.png",
      ),
    );
    slides.add(
      new Slide(
        title: "SAM is your personal",
        styleTitle: style1,
        description: "runner for your\nconstruction needs",
        styleDescription: style2,
        pathImage: "assets/images/img_intro2.png",
      ),
    );
    slides.add(
      new Slide(
        title: "Read the reviews of",
        styleTitle: style1,
        description: "background-checked\ndrivers",
        styleDescription: style2,
        pathImage: "assets/images/img_intro3.png",
      ),
    );
  }

  void onDonePress() {
    // Back to the first tab
    Navigator.pushNamed(context, '/signup');
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Color(0xffffcc5c),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Color(0xffffcc5c),
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color(0xffffcc5c),
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
          margin: EdgeInsets.only(
              bottom: AppConfig.size(context, 3),
              top: AppConfig.size(context, 6)),
          child: ListView(
            children: <Widget>[
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(
                    top: AppConfig.size(context, 3), left: 30, right: 30),
              ),
              Container(
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(left: 30, right: 30),
              ),
              GestureDetector(
                  child: Image.asset(
                currentSlide.pathImage,
                width: AppConfig.size(context, 300),
                height: AppConfig.size(context, 300),
                fit: BoxFit.contain,
              )),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    initSlides(context);
    return new IntroSlider(
      // List slides
      slides: this.slides,

      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Color(0x33ffcc5c),
      highlightColorSkipBtn: Color(0xffffcc5c),

      // Next button
      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn: Color(0x33ffcc5c),
      highlightColorDoneBtn: Color(0xffffcc5c),

      // Dot indicator
      colorDot: Color(0xffffcc5c),
      sizeDot: 13.0,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

      // Tabs
      listCustomTabs: this.renderListCustomTabs(),
      backgroundColorAllSlides: Colors.white,
      refFuncGoToTab: (refFunc) {
        this.goToTab = refFunc;
      },

      // Show or hide status bar
      shouldHideStatusBar: true,

      // On tab change completed
      onTabChangeCompleted: this.onTabChangeCompleted,
    );
  }
}
