import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Fire extends SpriteAnimationComponent with HasGameRef<PixelAdventure> {
  Fire({position, size}) : super(position: position, size: size);

  // animation speed
  //static const stepTime = 0.5;
  final double stepTime = 0.1;
  // pass animation
  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('fire/orange/loops/burning_loop_1.png'),
        SpriteAnimationData.sequenced(
            amount: 8, stepTime: stepTime, textureSize: Vector2.all(24)));
    return super.onLoad();
  }
}
