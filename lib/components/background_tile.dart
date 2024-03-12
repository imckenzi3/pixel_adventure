import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class BackgroundTile extends ParallaxComponent<PixelAdventure> {
  BackgroundTile();
  // BackgroundTile({required color, required Vector2 position});

  // final String color;

  // BackgroundTile({
  //   this.color = "Gray",
  //   position,
  // }) : super(
  //         position: position,
  //       );

  // get gameRef => null;

  // final double scrollSpeed = 40;

  @override
  Future<FutureOr<void>> onLoad() async {
    // set background to "behind"
    priority = -10;
    size = Vector2.all(64);

    // parallax = await gameRef.loadParallax(
    //     [ParallaxImageData('background/background_layer_1.png')],
    //     baseVelocity: Vector2(0, 0),
    //     repeat: ImageRepeat.repeat,
    //     fill: LayerFill.none);

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
