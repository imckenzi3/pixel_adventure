import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Spike extends SpriteAnimationComponent with HasGameRef<PixelAdventure> {
  Spike({position, size}) : super(position: position, size: size);

  // animation speed
  static const stepTime = 0.15;
  // final double stepTime = 0.1;

  // pass animation
  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Spike/Spike_B.png'),
        SpriteAnimationData.sequenced(
            amount: 10, stepTime: stepTime, textureSize: Vector2.all(32)));
    return super.onLoad();
  }
}
