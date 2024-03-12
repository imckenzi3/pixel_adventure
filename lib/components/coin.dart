import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/custom_hitbox.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Coin extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final String coin;

  Coin({
    this.coin = 'Coin (16 x 16)',
    position,
    size,
  }) : super(position: position, size: size, removeOnFinish: true);

  // anim time
  final double stepTime = 0.1;

  // hit box
  final hitbox = CustomHitbox(offsetX: 6, offsetY: 10, width: 12, height: 12);

  //give animation
  @override
  FutureOr<void> onLoad() {
    // see rez of coins
    // debugMode = true;

    // add hit box to coins
    add(
      RectangleHitbox(
          position: Vector2(hitbox.offsetX, hitbox.offsetY),
          size: Vector2(hitbox.width, hitbox.height),

          // check collision with player
          collisionType: CollisionType.passive),
    );

    // animate coins
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Common Pick-ups/$coin.png'),
        SpriteAnimationData.sequenced(
            amount: 4, stepTime: stepTime, textureSize: Vector2.all(16)));
    return super.onLoad();
  }

  // get rid of coin when player collides
  void collidedWithPlayer() async {
    // check if not collected
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Effects/Cloud_Poof (16 x 16).png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: stepTime,
        textureSize: Vector2.all(16),

        // run animation once
        loop: false,
      ),
    );

    // add to score
    gameRef.player.score += 1;

    await animationTicker?.completed;

    removeFromParent();
  }
}
