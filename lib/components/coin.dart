import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Coin extends SpriteAnimationComponent with HasGameRef<PixelAdventure> {
  final String coin;

  Coin({
    this.coin = 'Coin',
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  // anim time
  final double stepTime = 0.1;

  //give animation
  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Common Pick-ups/Small_Coin (16 x 16).png'),
        SpriteAnimationData.sequenced(
            amount: 4, stepTime: stepTime, textureSize: Vector2.all((32))));
    return super.onLoad();
  }
}
