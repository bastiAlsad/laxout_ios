/*// Nacken
DesignerItem1(
                            Image.asset('assets/images/workout1.png',
                                ),
                            'Nacken',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Workout(
                                          workoutName: "Nacken-Workout",
                                          listeUebungen: [
                                            "Schulterblattkreisen",
                                            "Halbkreise Links",
                                            "Halbkreise Rechts",
                                            "Dehnung Links Hinten",
                                            "Dehnung Rechts Hinten",
                                          ],
                                          benoutigtesName: Icon(
                                            Icons.chair,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                          dauer: "2:00",
                                          bereich: "Nacken",
                                          start: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Uebung(
                                                        looping: true,
                                                        ausfuehrung:
                                                            "Stehe Hüftbreit und gehe leicht in die Knie. Die Arme hängen dabei nach unten, während deine Schultern eine Kreisbewegung machen. Wichtig ist das die Schultern erst so weit wie möglich nach oben gehen und dann langsam abgesenkt werden.",
                                                        nameUebung:
                                                            "Schulterblattkreisen",
                                                        dauer: 30,
                                                        videoPath:
                                                            'assets/videos/schuterblattkreisen.mp4',
                                                        onBackwardPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        onForwardPressed: () =>
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Uebung(
                                                                              looping:
                                                                                  true,
                                                                              ausfuehrung:
                                                                                  "Wichtig ist dass du aufrecht an der Stuhlkante sitzt und deine Schultern hängen lässt. Führe die Übung bitte langsam aus",
                                                                              nameUebung:
                                                                                  "Halbkreise Links",
                                                                              dauer:
                                                                                  30,
                                                                              videoPath:
                                                                                  'assets/videos/Halbkreisnackenlinks.mp4', // geht nicht
                                                                              onBackwardPressed: () =>
                                                                                  Navigator.pop(context),
                                                                              onForwardPressed: () => Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => Uebung(
                                                                                            looping: true,
                                                                                            ausfuehrung: "Wichtig ist dass du aufrecht an der Stuhlkante sitzt und deine Schultern hängen lässt. Führe die Übung bitte langsam aus",
                                                                                            nameUebung: "Halbkreise Rechts", // geht nicht
                                                                                            dauer: 30,
                                                                                            videoPath: 'assets/videos/HalbkreisNackenrechts.mp4',
                                                                                            onBackwardPressed: () => Navigator.pop(context),
                                                                                            onForwardPressed: () => Navigator.push(
                                                                                                context,
                                                                                                MaterialPageRoute(
                                                                                                    builder: (context) => Uebung(
                                                                                                        looping: false,
                                                                                                        ausfuehrung: "Gehe langsam in die Dehnung, halte sie und bewege deine Schultern nicht. Außerdem ist es gut, wenn du aufrecht sitzt. Bist du fertig mit der Übung, verlasse die Dehnung nicht zu schnell.",
                                                                                                        nameUebung: "Dehnung Links Hinten ",
                                                                                                        dauer: 30,
                                                                                                        videoPath: 'assets/videos/nackenLinksHinten.mp4',
                                                                                                        onBackwardPressed: () => Navigator.pop(context),
                                                                                                        onForwardPressed: () => Navigator.push(
                                                                                                            context,
                                                                                                            MaterialPageRoute(
                                                                                                                builder: (context) => Uebung(
                                                                                                                      looping: false,
                                                                                                                      ausfuehrung: "Gehe langsam in die Dehnung, halte sie und bewege deine Schultern nicht. Außerdem ist es gut, wenn du aufrecht sitzt. Bist du fertig mit der Übung, verlasse die Dehnung nicht zu schnell.",
                                                                                                                      nameUebung: "Dehnung Rechts Hinten",
                                                                                                                      dauer: 30,
                                                                                                                      videoPath: 'assets/videos/nackenRechtsHinten.mp4',
                                                                                                                      onBackwardPressed: () => Navigator.pop(context),
                                                                                                                      onForwardPressed: (() {
                                                                                                                        dialogShow();
                                                                                                                        days.add(createDateTimeObject(todaysDateFormatted()));
                                                                                                                        _heatmap.saveToday(days);
                                                                                                                        _heatmap.putDaysinMap(days);
                                                                                                                        if (_hiveCredit.getControlltime() == 150 && _hiveHeatmap.getToday().length < 0) {
                                                                                                                          _hiveCredit.clearControllTime();
                                                                                                                          actuallcredits = _hiveCredit.getCredits();
                                                                                                                          actuallcredits = actuallcredits + credits;
                                                                                                                          _hiveCredit.addCredits(actuallcredits);
                                                                                                                        }
                                                                                                                      }),
                                                                                                                    )))))),
                                                                                          ))),
                                                                            ))),
                                                      ))),
                                        )))),
//Schultern
DifferentWorkouts(
                            Image.asset('assets/images/Schultern.png',
                                height: 100.0, width: 100.0),
                            'Schultern',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Workout(
                                          workoutName: "Schultern-Workout",
                                          listeUebungen: [
                                            "Schulterkreisen",
                                            "Schulterdehnung im 45 Grad Winkel",
                                            "Schulterdehnung im 90 Grad Winkel",
                                            "Aufrichten",
                                          ],
                                          dauer: "2:00",
                                          benoutigtesName: Icon(
                                            Icons.meeting_room,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                          bereich: "Schultern",
                                          start: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Uebung(
                                                        looping: true,
                                                        ausfuehrung:
                                                            "Fasse mit deinen Fingerspitzen auf die Schultern. Mache deine Ellbogen nun auf Kinnhöhe zusammen. Dannach gehen die Ellbogen mit den Schultern nach oben und klappen nach hinten. Achte auf eine nicht zu schnelle Ausführung",
                                                        nameUebung:
                                                            "Schulterkreisen",
                                                        dauer: 30,
                                                        videoPath:
                                                            'assets/videos/schuterblattkreisen.mp4',
                                                        onBackwardPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        onForwardPressed: () =>
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Uebung(
                                                                              looping:
                                                                                  false,
                                                                              ausfuehrung:
                                                                                  "Lege deine Hände im geschätzen 45 Grad Winkel wie gezeigt an die Wand. Dannach machst du einen Ausfallschritt und verlagerst dein Gewicht langsam nach vorne.",
                                                                              nameUebung:
                                                                                  "Schulterdehnung im 45 Grad Winkel",
                                                                              dauer:
                                                                                  30,
                                                                              videoPath:
                                                                                  'assets/videos/schulterdehnung.mp4',
                                                                              onBackwardPressed: () =>
                                                                                  Navigator.pop(context),
                                                                              onForwardPressed: () => Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => Uebung(
                                                                                            looping: false,
                                                                                            ausfuehrung: "Lege deine Hände so hoch wie möglich an die Wand, wie als ob dich jemand nach oben zieht. Dannach machst du einen Ausfallschritt und verlagerst dein Gewicht langsam nach vorne.",
                                                                                            nameUebung: "Schulterdehnung im 90 Grad Winkel",
                                                                                            dauer: 30,
                                                                                            videoPath: 'assets/videos/schulterdehnungGerade.mp4',
                                                                                            onBackwardPressed: () => Navigator.pop(context),
                                                                                            onForwardPressed: () => Navigator.push(
                                                                                                context,
                                                                                                MaterialPageRoute(
                                                                                                    builder: (context) => Uebung(
                                                                                                          looping: true,
                                                                                                          ausfuehrung: "Lasse deinen Nacken locker, wärend deine Hände sich auf Arschhöhre verschränken. Deine Schultern gehen nun hinten zusammen, während die Hände nach unten gezogen werden. ",
                                                                                                          nameUebung: "Aufrichten",
                                                                                                          dauer: 30,
                                                                                                          videoPath: 'assets/videos/aufrichtenoberkoerper.mp4',
                                                                                                          onBackwardPressed: () => Navigator.pop(context),
                                                                                                          onForwardPressed: () => Navigator.push(
                                                                                                              context,
                                                                                                              MaterialPageRoute(
                                                                                                                  builder: (context) => Uebung(
                                                                                                                        looping: false,
                                                                                                                        ausfuehrung: "Deine Hände sind auf Brusthöhe, während du dich nach vorne neigst, als ob jemand an deinen Unterarmen zieht. Stell dir vor du willst etwas vor dir umarmen.",
                                                                                                                        nameUebung: "Bagger",
                                                                                                                        dauer: 30,
                                                                                                                        videoPath: 'assets/videos/bagger.mp4',
                                                                                                                        onBackwardPressed: () => Navigator.pop(context),
                                                                                                                        onForwardPressed: (() {
                                                                                                                          dialogShow();
                                                                                                                          days.add(createDateTimeObject(todaysDateFormatted()));
                                                                                                                          _heatmap.saveToday(days);
                                                                                                                          _heatmap.putDaysinMap(days);
                                                                                                                          if (_hiveCredit.getControlltime() == 150 && _hiveHeatmap.getToday().length < 0) {
                                                                                                                            _hiveCredit.clearControllTime();
                                                                                                                            actuallcredits = _hiveCredit.getCredits();
                                                                                                                            actuallcredits = actuallcredits + credits;
                                                                                                                            _hiveCredit.addCredits(actuallcredits);
                                                                                                                          }
                                                                                                                        }),
                                                                                                                      ))),
                                                                                                        ))),
                                                                                          ))),
                                                                            ))),
                                                      ))),
                                        )))),
//mittlerer Rücken
DifferentWorkouts(
                            Image.asset('assets/images/UntererRuecken.png',
                                height: 100.0, width: 100.0),
                            'Unterer Rücken',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Workout(
                                          workoutName: "Unterer-Rücken-Workout",
                                          listeUebungen: [
                                            "Bewegung Unterer Rücken",
                                            "Plumpsen",
                                            "Dehnung Unterer Rücken links",
                                            "Dehung Unterer Rücken rechts",
                                          ],
                                          benoutigtesName: Icon(
                                            Icons.directions_run,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                          dauer: "2:00",
                                          bereich: "Unterer Rücken",
                                          start: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Uebung(
                                                        looping: true,
                                                        ausfuehrung:
                                                            "Setze dich aufrecht an die Stuhlkante und beginne mit dem Becken zu kreisen. Der Oberkörper muss möglichst ruhig bleiben. ",
                                                        nameUebung:
                                                            "Bewegung Unterer Rücken",
                                                        dauer: 30,
                                                        videoPath:
                                                            'assets/videos/beckenschuakel.mp4',
                                                        onBackwardPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        onForwardPressed: () =>
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Uebung(
                                                                              looping:
                                                                                  true,
                                                                              ausfuehrung:
                                                                                  "Du schaust gerade nach oben zur Decke. Lege deine Beine langsam und abwechselnd links und rechts zur Seite ab. Dabei bewegt sich dein Oberkörper nicht. ",
                                                                              nameUebung:
                                                                                  "Plumpsen",
                                                                              dauer:
                                                                                  30,
                                                                              videoPath:
                                                                                  'assets/videos/Plumpsenrechtslinks.mp4',
                                                                              onBackwardPressed: () =>
                                                                                  Navigator.pop(context),
                                                                              onForwardPressed: () => Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => Uebung(
                                                                                            looping: false,
                                                                                            ausfuehrung: "Du schaust gerade nach oben zur Decke. Dannach legst du deine Beine langsam zur Seite ab und hältst die Dehnung. Dabei bewegt sich dein Oberkörper nicht.",
                                                                                            nameUebung: "Dehnung Unterer Rücken rechts",
                                                                                            dauer: 30,
                                                                                            videoPath: 'assets/videos/untererRueckenrechts.mp4',
                                                                                            onBackwardPressed: () => Navigator.pop(context),
                                                                                            onForwardPressed: () => Navigator.push(
                                                                                                context,
                                                                                                MaterialPageRoute(
                                                                                                    builder: (context) => Uebung(
                                                                                                          looping: false,
                                                                                                          ausfuehrung: "Du schaust gerade nach oben zur Decke. Dannach legst du deine Beine langsam zur Seite ab und hältst die Dehnung. Dabei bewegt sich dein Oberkörper nicht",
                                                                                                          nameUebung: "Dehnung Unterer Rücken links",
                                                                                                          dauer: 30,
                                                                                                          videoPath: 'assets/videos/untererRueckenlinks.mp4',
                                                                                                          onBackwardPressed: () => Navigator.pop(context),
                                                                                                          onForwardPressed: (() {
                                                                                                            dialogShow();
                                                                                                            days.add(createDateTimeObject(todaysDateFormatted()));
                                                                                                            _heatmap.saveToday(days);
                                                                                                            _heatmap.putDaysinMap(days);
                                                                                                            if (_hiveCredit.getControlltime() == 150 && _hiveHeatmap.getToday().length < 0) {
                                                                                                              _hiveCredit.clearControllTime();
                                                                                                              actuallcredits = _hiveCredit.getCredits();
                                                                                                              actuallcredits = actuallcredits + credits;
                                                                                                              _hiveCredit.addCredits(actuallcredits);
                                                                                                            }
                                                                                                          }),
                                                                                                        ))),
                                                                                          ))),
                                                                            ))),
                                                      ))),
                                        )))),
//unterer Rücken
DesignerItem1(
                            Image.asset('assets/images/MittlererRuecken.png',
                                height: 100.0, width: 100.0),
                            'Mittlerer Rücken',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Workout(
                                          workoutName: "Mittlerer-Rücken-Workout",
                                          dauer: "2:00",
                                          listeUebungen: [
                                            "Rotation Oberkörper",
                                            "Seitliche Dehnung links",
                                            "Seitliche Dehnung rechts",
                                            "Brustwirbelsäule links",
                                            "Brustwirbelsäule rechts",
                                          ],
                                          benoutigtesName: Icon(
                                            Icons.chair,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                          bereich: "Mittlerer Rücken",
                                          start: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Uebung(
                                                        looping: true,
                                                        ausfuehrung:
                                                            "Setze dich so an die Stuhlkante, dass deine Knie auseinander sind und du aufrecht sitzt. Bei der Drehnung darf sich dein Becken und dein Kopf nicht bewegen. Tipp nehme hierfür deine Hände, wie gezeigt vor die Brust",
                                                        nameUebung:
                                                            "Rotation Oberkörper",
                                                        dauer: 30,
                                                        videoPath:
                                                            'assets/videos/rotationMittlererR.mp4',
                                                        onBackwardPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        onForwardPressed: () =>
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Uebung(
                                                                              looping:
                                                                                  false,
                                                                              ausfuehrung:
                                                                                  "Setze dich so an die Stuhlkante, dass deine Knie auseinander sind und du aufrecht sitzt. Neige dich nun mit ausgestrecktem Arm zur Seite und versuche tief zu atmen. Schau dabei auf den Boden, der gerade vor dir ist.",
                                                                              nameUebung:
                                                                                  "Seitliche Dehnung links",
                                                                              dauer:
                                                                                  30,
                                                                              videoPath:
                                                                                  'assets/videos/seitlicheDehnunglins.mp4',
                                                                              onBackwardPressed: () =>
                                                                                  Navigator.pop(context),
                                                                              onForwardPressed: () => Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => Uebung(
                                                                                            looping: false,
                                                                                            ausfuehrung: "Setze dich so an die Stuhlkante, dass deine Knie auseinander sind und du aufrecht sitzt. Neige dich nun mit ausgestrecktem Arm zur Seite und versuche tief zu atmen. Schau dabei auf den Boden, der gerade vor dir ist.",
                                                                                            nameUebung: "Seitliche Dehnung rechts",
                                                                                            dauer: 30,
                                                                                            videoPath: 'assets/videos/seitlicheDehnungm.rechts.mp4',
                                                                                            onBackwardPressed: () => Navigator.pop(context),
                                                                                            onForwardPressed: () => Navigator.push(
                                                                                                context,
                                                                                                MaterialPageRoute(
                                                                                                    builder: (context) => Uebung(
                                                                                                          looping: true,
                                                                                                          ausfuehrung: "Lege dir für diese Übung am besten ein Kissen wie gezeigt unter. Dannach geht der ausgestreckte Arm zur anderen Seite, während du ihm nachschaust und dein Kopf sich mit ihm mitbewegt.",
                                                                                                          nameUebung: "Brustwirbelsäule links",
                                                                                                          dauer: 30,
                                                                                                          videoPath: 'assets/videos/brustwirbelsauleLinks.mp4',
                                                                                                          onBackwardPressed: () => Navigator.pop(context),
                                                                                                          onForwardPressed: () => Navigator.push(
                                                                                                              context,
                                                                                                              MaterialPageRoute(
                                                                                                                  builder: (context) => Uebung(
                                                                                                                        looping: true,
                                                                                                                        ausfuehrung: "Lege dir für diese Übung am besten ein Kissen wie gezeigt unter. Dannach geht der ausgestreckte Arm zur anderen Seite, während du ihm nachschaust und dein Kopf sich mit ihm mitbewegt.",
                                                                                                                        nameUebung: "Brustwirbelsäule rechts",
                                                                                                                        dauer: 30,
                                                                                                                        videoPath: 'assets/videos/brustwirbelsauleRechts.mp4',
                                                                                                                        onBackwardPressed: () => Navigator.pop(context),
                                                                                                                        onForwardPressed: (() {
                                                                                                                          print(_hiveCredit.getControlltime());
                                                                                                                          dialogShow();
                                                                                                                          days.add(createDateTimeObject(todaysDateFormatted()));
                                                                                                                          _heatmap.saveToday(days);
                                                                                                                          _heatmap.putDaysinMap(days);
                                                                                                                          if (_hiveCredit.getControlltime() == 150 && _hiveHeatmap.getToday().length < 0) {
                                                                                                                            _hiveCredit.clearControllTime();
                                                                                                                            actuallcredits = _hiveCredit.getCredits();
                                                                                                                            actuallcredits = actuallcredits + credits;
                                                                                                                            _hiveCredit.addCredits(actuallcredits);
                                                                                                                          }
                                                                                                                        }),
                                                                                                                      ))),
                                                                                                        ))),
                                                                                          ))),
                                                                            ))),
                                                      ))),
                                        )))),
*/