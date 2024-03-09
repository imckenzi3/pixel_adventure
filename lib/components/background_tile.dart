import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class BackgroundTile extends ParallaxComponent<PixelAdventure> {
  BackgroundTile();

  @override
  Future<FutureOr<void>> onLoad() async {
    final background =

        //parallax background images goes here
        await Flame.images.load('background/background_layer_1.png');
    await Flame.images.load('background/background_layer_2.png');
    await Flame.images.load('background/background_layer_3.png');

    parallax = Parallax([
      ParallaxLayer(
        ParallaxImage(background),
      ),
    ]);
  }

  // makes background move
  // @override
  // void update(double dt) {
  //   super.update(dt);
  //   parallax?.baseVelocity.x = Config.gameSpeed;
  // }
}
