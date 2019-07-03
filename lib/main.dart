import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';

import 'flare_artboard.dart';

Future<void> main() async {
  // Preload our Flare files (you could also do this in a widget).
  var asset = await cachedActor(rootBundle, 'assets/Chatbot-back.flr');
  asset.ref();
  var artboardBack =
      asset.actor.artboard.makeInstance() as FlutterActorArtboard;
  artboardBack.initializeGraphics();
  artboardBack.advance(0);

  var asset2 = await cachedActor(rootBundle, 'assets/Chatbot-front.flr');
  asset2.ref();
  var artboardFront =
      asset2.actor.artboard.makeInstance() as FlutterActorArtboard;
  artboardFront.initializeGraphics();
  artboardFront.advance(0);

  runApp(MyApp(artboardFront, artboardBack));
}

class MyApp extends StatelessWidget {
  final FlutterActorArtboard artboardFront;
  final FlutterActorArtboard artboardBack;
  final FlareControls heroFlareControls = FlareControls();
  MyApp(this.artboardFront, this.artboardBack);

  @override
  Widget build(BuildContext context) {
    timeDilation = 5;
    return Container(
      color: Colors.white,
      child: MaterialApp(
        title: "Flare Bot",
        routes: {
          "/page1": (context) => Page1(
              artboardBack: artboardBack,
              artboardFront: artboardFront,
              heroControls: heroFlareControls),
          "/page2": (context) => Page2(
              artboardBack: artboardBack,
              artboardFront: artboardFront,
              heroControls: heroFlareControls),
        },
        home: Page1(
            artboardBack: artboardBack,
            artboardFront: artboardFront,
            heroControls: heroFlareControls),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  final FlutterActorArtboard artboardFront;
  final FlutterActorArtboard artboardBack;
  final FlareControls heroControls;
  const Page1({this.artboardFront, this.artboardBack, this.heroControls});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        heroControls.play("face-to-broken");
        Navigator.pushNamed(context, "/page2");
      },
      child: Container(
        child: Align(
            alignment: Alignment.topCenter,
            child: Hero(
              tag: "tag",
              child: Container(
                width: 300,
                height: 300,
                child: Stack(
                  children: <Widget>[
                    FlareArtboard(artboardBack),
                    FlareArtboard(artboardFront, controller: heroControls)
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  final FlutterActorArtboard artboardFront;
  final FlutterActorArtboard artboardBack;
  final FlareControls heroControls;

  Page2({this.artboardFront, this.artboardBack, this.heroControls});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        heroControls.play("broken-to-face");
        Navigator.pushNamed(context, "/page1");
      },
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 300,
            height: 300,
            child: Hero(
              tag: "tag",
              child: Stack(
                children: <Widget>[
                  FlareArtboard(artboardBack),
                  FlareArtboard(artboardFront, controller: heroControls)
                ],
              ),
            ),
          )),
    );
  }
}
