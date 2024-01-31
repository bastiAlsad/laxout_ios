import 'package:flutter/material.dart';

import '../variablePages/Uebung.dart';
import '../navigation/Side_Nav_Bar.dart';
import '../variablePages/UebungUebungsuebersicht.dart';

class Uebungsuebersicht extends StatefulWidget {
  const Uebungsuebersicht({Key? key}) : super(key: key);

  @override
  State<Uebungsuebersicht> createState() => _UebungsuebersichtState();
}

class _UebungsuebersichtState extends State<Uebungsuebersicht> {

  void dialogShow() {
    showDialog<AlertDialog>(
        barrierColor: Colors.white.withOpacity(0),
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              content: Text(
                "Toll gemacht, das war die letzte Übung!",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    final uebungList =  [
            UebungUebungsUebersicht(
                imagePath: "assets/images/Nacken.png",
                ausfuehrung:
                    "Stehe Hüftbreit und gehe leicht in die Knie. Die Arme hängen dabei nach unten, während deine Schultern eine Kreisbewegung machen. Wichtig ist das die Schultern erst so weit wie möglich nach oben gehen und dann langsam abgesenkt werden.",
                nameUebung: "Schulterblattkreisen",
                dauer: 30,
                videoPath: "assets/videos/schuterblattkreisen.mp4",
                onBackwardPressed: () {},
                onForwardPressed: () {}),
            UebungUebungsUebersicht(
                imagePath: "assets/images/Nacken.png",
                ausfuehrung:
                    "Wichtig ist dass du aufrecht an der Stuhlkante sitzt und deine Schultern hängen lässt. Führe die Übung bitte langsam aus.",
                nameUebung: "Halbkreise Links",
                dauer: 30,
                videoPath: "assets/videos/Halbkreisnackenlinks.mp4",
                onBackwardPressed: () {},
                onForwardPressed: () {}),
            UebungUebungsUebersicht(
                imagePath: "assets/images/Nacken.png",
                ausfuehrung:
                    "Wichtig ist dass du aufrecht an der Stuhlkante sitzt und deine Schultern hängen lässt. Führe die Übung bitte langsam aus.",
                nameUebung: "Halbkreise Rechts",
                dauer: 30,
                videoPath: "assets/videos/HalbkreisNackenrechts.mp4",
                onBackwardPressed: () {},
                onForwardPressed: () {}),
            UebungUebungsUebersicht(
                imagePath: "assets/images/Nacken.png",
                ausfuehrung:
                    "Gehe langsam in die Dehnung, halte sie und bewege deine Schultern nicht. Außerdem ist es gut, wenn du aufrecht sitzt. Bist du fertig mit der Übung, verlasse die Dehnung nicht zu schnell.",
                nameUebung: "Dehnung l Hinten",
                dauer: 30,
                videoPath: "assets/videos/nackenLinksHinten.mp4",
                onBackwardPressed: () {},
                onForwardPressed: () {}),
            UebungUebungsUebersicht(
                imagePath: "assets/images/Nacken.png",
                ausfuehrung:
                    "Gehe langsam in die Dehnung, halte sie und bewege deine Schultern nicht. Außerdem ist es gut, wenn du aufrecht sitzt. Bist du fertig mit der Übung, verlasse die Dehnung nicht zu schnell.",
                nameUebung: "Dehnung r Hinten",
                dauer: 30,
                videoPath: "assets/videos/nackenRechtsHinten.mp4",
                onBackwardPressed: () {},
                onForwardPressed: () {}),
            UebungUebungsUebersicht(
                imagePath: "assets/images/Schultern.png",
                ausfuehrung:
                    "Lege deine Hände im geschätzen 45 Grad Winkel wie gezeigt an die Wand. Dannach machst du einen Ausfallschritt und verlagerst dein Gewicht langsam nach vorne.",
                nameUebung: "Schulterdehnung 45*",
                dauer: 30,
                videoPath: "assets/videos/schulterdehnung.mp4",
                onBackwardPressed: () {},
                onForwardPressed: () {}),
            UebungUebungsUebersicht(
                imagePath: "assets/images/Schultern.png",
                ausfuehrung:
                    "Lege deine Hände so hoch wie möglich an die Wand, wie als ob dich jemand nach oben zieht. Dannach machst du einen Ausfallschritt und verlagerst dein Gewicht langsam nach vorne.",
                nameUebung: "Schulterdehnung 90* ",
                dauer: 30,
                videoPath: "assets/videos/schulterdehnungGerade.mp4",
                onBackwardPressed: () {},
                onForwardPressed: () {}),
            UebungUebungsUebersicht(
                imagePath: "assets/images/Schultern.png",
                ausfuehrung:
                    "Lasse deinen Nacken locker, wärend deine Hände sich auf Arschhöhre verschränken. Deine Schultern gehen nun hinten zusammen, während die Hände nach unten gezogen werden.",
                nameUebung: "Aufrichten",
                dauer: 30,
                videoPath: "assets/videos/aufrichtenoberkoerper.mp4",
                onBackwardPressed: () {},
                onForwardPressed: () {}),
            UebungUebungsUebersicht(
                imagePath: "assets/images/Schultern.png",
                ausfuehrung:
                    "Deine Hände sind auf Brusthöhe, während du dich nach vorne neigst, als ob jemand an deinen Unterarmen zieht. Stell dir vor du willst etwas vor dir umarmen.",
                nameUebung: "Bagger",
                dauer: 30,
                videoPath: "assets/videos/bagger.mp4",
                onBackwardPressed: () {},
                onForwardPressed: () {}),
            UebungUebungsUebersicht(
                imagePath: "assets/images/UntererRuecken.png",
                ausfuehrung: "Setze dich aufrecht an die Stuhlkante und beginne mit dem Becken zu kreisen. Der Oberkörper muss möglichst ruhig bleiben.",
                nameUebung: "Bewegung u.Rücken",
                dauer: 30,
                videoPath: "assets/videos/beckenschuakel.mp4",
                onBackwardPressed: () {},
                onForwardPressed: () {}),
            UebungUebungsUebersicht(
                imagePath: "assets/images/UntererRuecken.png",
                ausfuehrung: "Du schaust gerade nach oben zur Decke. Lege deine Beine langsam und abwechselnd links und rechts zur Seite ab. Dabei bewegt sich dein Oberkörper nicht.",
                nameUebung: "Plumpsen",
                dauer: 30,
                videoPath: "assets/videos/Plumpsenrechtslinks.mp4",
                onBackwardPressed: () {},
                onForwardPressed: () {}),
            UebungUebungsUebersicht(
                imagePath: "assets/images/UntererRuecken.png",
                ausfuehrung: "Du schaust gerade nach oben zur Decke. Dannach legst du deine Beine langsam zur Seite ab und hältst die Dehnung. Dabei bewegt sich dein Oberkörper nicht.",
                nameUebung: "Dehnung u. Rücken r",
                dauer: 30,
                videoPath: "assets/videos/untererRueckenrechts.mp4",
                onBackwardPressed: () {},
                onForwardPressed: () {}),
            UebungUebungsUebersicht(
                imagePath: "assets/images/UntererRuecken.png",
                ausfuehrung: "Du schaust gerade nach oben zur Decke. Dannach legst du deine Beine langsam zur Seite ab und hältst die Dehnung. Dabei bewegt sich dein Oberkörper nicht",
                nameUebung: "Dehnung u. Rücken l",
                dauer: 30,
                videoPath: "assets/videos/untererRueckenlinks.mp4",
                onBackwardPressed: () {},
                onForwardPressed: () {}),
            UebungUebungsUebersicht(
                imagePath: "assets/images/MittlererRuecken.png",
                ausfuehrung: "Setze dich so an die Stuhlkante, dass deine Knie auseinander sind und du aufrecht sitzt. Bei der Drehnung darf sich dein Becken und dein Kopf nicht bewegen. Tipp nehme hierfür deine Hände, wie gezeigt vor die Brust.",
                nameUebung: "Rotation Oberkörper",
                dauer: 30,
                videoPath: "assets/videos/rotationMittlererR.mp4",
                onBackwardPressed: () {},
                onForwardPressed: () {}),
            UebungUebungsUebersicht(
                imagePath: "assets/images/MittlererRuecken.png",
                ausfuehrung: "Setze dich so an die Stuhlkante, dass deine Knie auseinander sind und du aufrecht sitzt. Neige dich nun mit ausgestrecktem Arm zur Seite und versuche tief zu atmen. Schau dabei auf den Boden, der gerade vor dir ist.",
                nameUebung: "Dehnung links",
                dauer: 30,
                videoPath: "assets/videos/seitlicheDehnunglins.mp4",
                onBackwardPressed: () {},
                onForwardPressed: () {}),
            UebungUebungsUebersicht(
                imagePath: "assets/images/MittlererRuecken.png",
                ausfuehrung: "Setze dich so an die Stuhlkante, dass deine Knie auseinander sind und du aufrecht sitzt. Neige dich nun mit ausgestrecktem Arm zur Seite und versuche tief zu atmen. Schau dabei auf den Boden, der gerade vor dir ist.",
                nameUebung: "Dehnung rechts",
                dauer: 30,
                videoPath: "assets/videos/seitlicheDehnungm.rechts.mp4",
                onBackwardPressed: () {},
                onForwardPressed: () {}),
            UebungUebungsUebersicht(
                imagePath: "assets/images/MittlererRuecken.png",
                ausfuehrung: "Lege dir für diese Übung am besten ein Kissen wie gezeigt unter. Dannach geht der ausgestreckte Arm zur anderen Seite, während du ihm nachschaust und dein Kopf sich mit ihm mitbewegt.",
                nameUebung: "Brustwirbelsäule l",
                dauer: 30,
                videoPath: "assets/videos/brustwirbelsauleLinks.mp4",
                onBackwardPressed: () {},
                onForwardPressed: () {}),
            UebungUebungsUebersicht(
                imagePath: "assets/images/MittlererRuecken.png",
                ausfuehrung: "Lege dir für diese Übung am besten ein Kissen wie gezeigt unter. Dannach geht der ausgestreckte Arm zur anderen Seite, während du ihm nachschaust und dein Kopf sich mit ihm mitbewegt.",
                nameUebung: "Brustwirbelsäule r",
                dauer: 30,
                videoPath: "assets/videos/brustwirbelsauleRechts.mp4",
                onBackwardPressed: () {},
                onForwardPressed: () {}),
          ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        toolbarHeight: 70,
        centerTitle: true,
        title: const Text(
          "Übungen",
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0)),
                  color: Color.fromRGBO(176, 224, 230, 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20.0,
                      offset: Offset(0, 0),
                    )
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: ListView.builder(
                    itemCount: uebungList.length,
                    itemBuilder: (context, index) {
                      return DifferentWorkouts(
                          imagePath: uebungList[index].imagePath,
                          title: uebungList[index].nameUebung,
                          navigate: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Uebung(
                                    timer: true,
                                    looping: true,
                                        ausfuehrung: uebungList[index].ausfuehrung,
                                        nameUebung: uebungList[index].nameUebung,
                                        dauer: uebungList[index].dauer,
                                        videoPath:
                                            uebungList[index].videoPath,
                                        onBackwardPressed: () =>
                                            Navigator.pop(context),
                                        onForwardPressed: () {},
                                      ))),
                          duration: uebungList[index].dauer.toString());
                    },
                  ),
                )),
          )
        ],
      ),
      drawer: const SideNavBar(),
    );
  }
}

class BereichUebersicht extends StatelessWidget {
  final String bereich;
  const BereichUebersicht({
    Key? key,
    required this.bereich,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(30, 20, 0, 5),
      child: Text(
        bereich,
        style: const TextStyle(
            fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w600),
        textAlign: TextAlign.left,
      ),
    );
  }
}

class DifferentWorkouts extends StatelessWidget {
  final String duration; // Halloo
  final String title;
  final String imagePath;
  final Function navigate;
  const DifferentWorkouts(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.navigate,
      required this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 90,
      margin: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20.0,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return Colors.white;
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ))),
        onPressed: () {
          navigate();
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(
                imagePath,
                height: 75,
                width: 75,
              ),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.watch_outlined,
                    color: Colors.black,
                  ),
                  Text(
                    duration,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
