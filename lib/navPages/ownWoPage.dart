import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/services/basti_backend.dart';
import 'package:new_projekt/services/hive_communication.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';

class LaxBaum extends StatefulWidget {
  const LaxBaum({Key? key}) : super(key: key);

  @override
  State<LaxBaum> createState() => _LaxBaumState();
}

class _LaxBaumState extends State<LaxBaum> {
  void vibratePhone() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      for (int i = 0; i < 3; i++) {
        Vibration.vibrate();
      }
    } else {
      // Das Gerät unterstützt keine Vibration
    }
  }

  late VideoPlayerController _controller;
  late VideoPlayerController _controller2;
  late VideoPlayerController _controller3;
  final LaxoutBackend _backend = LaxoutBackend();
  bool initanimationvisible = true;
  bool confettianimationshown = false;

  Stream<int?> _getWaterdropsStream() async* {
    int? waterdrops = await _backend.getWaterdrops();
    yield waterdrops;
  }

  Stream<int?> _getConditionStream() async* {
    int? condition = await _backend.getCondition();
    yield condition;
  }

  void _initializeVideoPlayer() async {
    _controller = VideoPlayerController.asset("assets/videos/initanimation.mp4")
      ..addListener(() => setState(() {}))
      ..setLooping(false);

    try {
      await _controller.initialize();
      _controller.setVolume(0.0);
      _controller.play();
      _controller.addListener(() {
        if (_controller.value.position == _controller.value.duration) {
          setState(() {
            initanimationvisible = false;
            _controller2.play();
          });
        }
      });
    } catch (error) {
      print("Fehler beim Initialisieren von Video 1: $error");
    }
  }

  void _initializeVideoPlayer2() async {
    _controller2 =
        VideoPlayerController.asset("assets/videos/plantstanding.mp4")
          ..addListener(() => setState(() {}))
          ..setLooping(true);

    try {
      await _controller2.initialize();    
      _controller2.setVolume(0.0);
      } catch (error) {
      print("Fehler beim Initialisieren von Video 2: $error");
    }
  }

  void _initializeVideoPlayer3() async {
    _controller3 = VideoPlayerController.asset(
        "assets/videos/hundretpercentplantstanding.mp4")
      ..addListener(() {
        if (_controller3.value.position >= _controller3.value.duration) {
          _controller3.pause();
          setState(() {
            confettianimationshown = true;
          });
          _controller3.seekTo(Duration.zero);
          _controller2.play();
        }
      })
      ..setLooping(false);

    try {
      await _controller3.initialize();
      _controller3.setVolume(0.0);      
    } catch (error) {
      print("Fehler beim Initialisieren von Video 3: $error");
    }
  }

    int tutorialCount = 0;
String text1 = "Der LaxBaum";//Title text
String text2 = "Neben den 100 LaxCoins haben Sie zusätzlich ein paar Wassertropfen für den LaxBaum bekommen. Laxout hat Ihnen diesen Baum anvertraut und hofft das Sie ihm stets genügend Wasser geben und sein Zustand nie bei 0% ist.";//Body text
String text3 = "Fortfahren"; //Button text
  void showWelcomeDialog(){
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
            title: Text(text1,textAlign: TextAlign.center, style: TextStyle(fontFamily: "Laxout", fontSize: 22, color: Colors.black),),
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(text2,textAlign: TextAlign.center, style: TextStyle(fontFamily: "Laxout", fontSize: 14,color: Colors.black),),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: (){
                      tutorialCount ++;
                      if(tutorialCount == 1){
                        setState(() {
                          text1 = "Warum soll ich mich um den Baum kümmern?";
                          text2 = "Der LaxBaum ist nicht nur als Spiegel Ihrer persönlichen Gesundheit angedacht, sondern produziert Ihnen zusätzlich LaxCoins, mit denen Sie sich echte Coupons aus dem Shop kaufen können. Die derzeitige tägliche Produktion an LaxCoins wird rechts unten neben dem Zustand des Baumes angezeigt.";
                          text3 = "Weiter";
                        });
                        Navigator.of(context).pop();
                        showWelcomeDialog();
                      }
                      if(tutorialCount == 2){
                        setState(() {
                          text1 = "Lassen Sie uns den Baum gießen!";
                          text2 = "Sie können den Baum durch Tippen auf die Pflanze gießen. Vorraussetzung ist jedoch, dass Sie mehr als 10 Wassertropfen haben.";
                          text3 = "Los";
                        });
                        Navigator.of(context).pop();
                        showWelcomeDialog();
                      }
                      if(tutorialCount == 3){
                        Navigator.of(context).pop();
                      }
                    },
                    child: Container(
                      height: 55,
                      width: 120,
                      decoration: BoxDecoration(color: Appcolors.primary, borderRadius: BorderRadius.circular(20),),
                      child: Center(child: Text(text3, style: TextStyle(color: Colors.white, fontSize: 16),),),
                    ),
                  )
                ],
              ),
            ],
          );
        }));
  }


 bool showTutorial = false;
final HiveDatabase _hive = HiveDatabase();


  @override
  void initState() {
    showTutorial = !_hive.getlaxbaumWasOpened();
    _hive.laxbaumWasOpened();
    showTutorial? WidgetsBinding.instance.addPostFrameCallback((_) {
      showWelcomeDialog();
    }):(){};
    super.initState();
    _initializeVideoPlayer();
    _initializeVideoPlayer2();
    _initializeVideoPlayer3();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        toolbarHeight: 70,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.white,
                title: Column(
                  children: [
                    Text(
                      "Was ist der LaxBaum?",
                      style: TextStyle(fontFamily: "Laxout", fontSize: 20),
                    ),
                    Text(
                      "Der LaxBaum soll als eine Art Indikator Ihres persönlichen Wohlbefindens dienen. Der Zustand des Baumes leitet sich daraus ab, wie oft Sie ihn mit den Wassertropfen, die rechts oben angezeigt werden, gießen. Haben Sie genügend Wassertropfen, können Sie den Baum einfach antippen, um ihm Wasser aus Ihrem Vorrat zuzuführen. Der Baum verbraucht dieses Wasser und sein Zustand verschlechtert sich täglich um 25%. Als Gegenleistung produziert er Ihnen LaxCoins, die virtuelle Währung dieser App, mit der Sie sich Belohnungen aus dem Shop kaufen können. Unten rechts wird angezeigt wie viele Coins der Baum derzeit pro Tag für Sie produziert. Machen Sie Ihr Physio-Workout um Wassertropfen zu verdienen und Ihren Baum vor dem Austrocknen zu bewahren!",
                      style: TextStyle(fontFamily: "Laxout", fontSize: 13),
                    )
                  ],
                ),
              ),
            );
          },
          icon: Icon(Icons.info),
        ),
        title: const Text(
          "LaxBaum",
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Laxout",
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: Image.asset("assets/images/tropfen.png"),
              ),
              const SizedBox(
                width: 7,
              ),
              StreamBuilder(
                stream: _getWaterdropsStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data ?? 0;
                    return Text(
                      "$data",
                      style: const TextStyle(
                          fontFamily: "Laxout",
                          fontSize: 25,
                          color: Colors.black),
                    );
                  } else {
                    return SpinKitFadingFour(
                      color: Appcolors.primary,
                    );
                  }
                },
              ),
              const SizedBox(
                width: 19,
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: () async {
                
                await _backend.pourLaxTree();
              },
              child: AspectRatio(
                aspectRatio: 1,
                child: StreamBuilder(
                  stream: _getConditionStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      Container(
                        color: Colors.white,
                        child: SpinKitFadingFour(
                          color: Appcolors.primary,
                        ),
                      );
                    }
                    final condition = snapshot.data ?? 0;

                    if (snapshot.hasData && condition < 100) {
                      
                      return initanimationvisible == true
                          ? VideoPlayer(_controller)
                          : VideoPlayer(_controller2);
                    }

                    if (snapshot.hasData &&
                        condition == 100 ) {
                      _controller2.pause();
                      _controller3.play();
                      for (int i = 0; i < 3; i++) {
                        vibratePhone();
                      }
                      return VideoPlayer(_controller3);
                    }

                    if (snapshot.hasData &&
                        condition == 100 &&
                        confettianimationshown) {
                      _controller3.seekTo(Duration.zero);
                      _controller2.play();
                      return VideoPlayer(_controller2);
                    }
                    return Container(
                      color: Colors.white,
                      child: SpinKitFadingFour(
                        color: Appcolors.primary,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SizedBox(
                  width: 150,
                  height: 130,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Zustand:",
                        style: TextStyle(fontFamily: "Laxout", fontSize: 18),
                      ),
                      StreamBuilder(
                        stream: _getConditionStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final data = snapshot.data ?? 1;
                            return CircularPercentIndicator(
                              radius: 50,
                              percent: data / 100,
                              animation: true,
                              animationDuration: 100,
                              animateFromLastPercent: true,
                              lineWidth: 10,
                              progressColor:
                                  Appcolors.primary,
                              backgroundColor: Colors.white,
                              center: Text(
                                "$data%",
                                style: TextStyle(
                                    fontFamily: "Laxout", fontSize: 18),
                              ),
                            );
                          } else {
                            return SpinKitFadingFour(
                              color: Appcolors.primary,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SizedBox(
                  width: 150,
                  height: 130,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Produktion:",
                        style: TextStyle(fontFamily: "Laxout", fontSize: 18),
                      ),
                      StreamBuilder(
                        stream: _getConditionStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final data = snapshot.data ?? 1;
                            return CircularPercentIndicator(
                              radius: 50,
                              percent: data / 100,
                              animation: true,
                              animationDuration: 100,
                              animateFromLastPercent: true,
                              lineWidth: 10,
                              progressColor:
                                  Appcolors.primary,
                              backgroundColor: Colors.white,
                              center: Text(
                                "${data * 1.5}/T",
                                style: TextStyle(
                                    fontFamily: "Laxout", fontSize: 18),
                              ),
                            );
                          } else {
                            return SpinKitFadingFour(
                              color: Appcolors.primary,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }
}
