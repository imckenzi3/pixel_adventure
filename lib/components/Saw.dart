import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Saw extends SpriteAnimationComponent with HasGameRef<PixelAdventure> {
  final bool isVertical;
  final double offNeg;
  final double offPos;

  Saw(
      {this.isVertical = false,
      this.offNeg = 0,
      this.offPos = 0,
      position,
      size})
      : super(position: position, size: size);

  // animation speed
  static const double stepTime = 0.05;

  // how fast saw moves
  static const moveSpeed = 50;

  // get ref to tile size of map
  static const tileSize = 15;

  double moveDirection = 1;
  double rangeNeg = 0;
  double rangePos = 0;

  // pass animation
  @override
  FutureOr<void> onLoad() {
    // collision
    add(CircleHitbox());
    debugMode = true;

    // get access to where saws can move to
    // check to see if vertical
    if (isVertical) {
      rangeNeg = position.y - offNeg * tileSize;
      rangePos = position.y + offPos * tileSize;

      // if not vertical horizontal
    } else {
      rangeNeg = position.x - offNeg * tileSize;
      rangePos = position.x + offPos * tileSize;
    }

    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Saw/Saw.png'),
        SpriteAnimationData.sequenced(
            amount: 8, stepTime: stepTime, textureSize: Vector2.all(32)));
    return super.onLoad();
  }

  // anytime we want to move change position
  @override
  void update(double dt) {
    // check if vertical
    if (isVertical) {
      _moveVertically(dt);
    } else {
      _moveHorizontally(dt);
    }
    super.update(dt);
  }

  void _moveVertically(double dt) {
    if (position.y >= rangePos) {
      moveDirection = -1;
    } else if (position.y <= rangeNeg) {
      moveDirection = 1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }

  void _moveHorizontally(double dt) {
    if (position.x >= rangePos) {
      moveDirection = -1;
    } else if (position.x <= rangeNeg) {
      moveDirection = 1;
    }
    position.x += moveDirection * moveSpeed * dt;
  }
}
