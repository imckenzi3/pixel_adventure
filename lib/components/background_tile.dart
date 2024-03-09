import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:pixel_adventure/components/configuration.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class BackgroundTile extends ParallaxComponent<PixelAdventure> {
  // final String color;
  // BackgroundTile({
  //   this.color = '/backgroundbackground_layer_1',
  //   position,
  // }) : super(position: position);

  // @override
  // FutureOr<void> onLoad() {
  //   size = Vector2.all(320);
  //   sprite = Sprite(game.images.fromCache('/backgroundbackground_layer_1'));
  //   return super.onLoad();
  // }

  BackgroundTile();

  @override
  Future<FutureOr<void>> onLoad() async {
    final background =
        await Flame.images.load('background/background_layer_1.png');
    // size = gameRef.size;
    parallax = Parallax([
      ParallaxLayer(
        ParallaxImage(background, fill: LayerFill.none),
      ),
    ]);
    //   sprite = Sprite(background);
  }

  @override
  void update(double dt) {
    super.update(dt);
    parallax?.baseVelocity.x = Config.gameSpeed;
  }
}
