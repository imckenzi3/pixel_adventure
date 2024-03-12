import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class JumpButton extends SpriteComponent
    with HasGameRef<PixelAdventure>, TapCallbacks {
  JumpButton();

  final margin = 32;
  final buttonSize = 64;

  @override
  FutureOr<void> onLoad() {
    // pass in image
    sprite = Sprite(game.images.fromCache('HUD/JumpButton.png'));
    position = Vector2(
        game.size.x - margin - buttonSize, game.size.y - margin - buttonSize);

    priority = 10;
    return super.onLoad();
  }

  // tracks when btn clicked
  @override
  void onTapDown(TapDownEvent event) {
    // grab ref to player
    game.player.hasJumped = true;

    super.onTapDown(event);
  }

  // when btn release jump set to false
  @override
  void onTapUp(TapUpEvent event) {
    game.player.hasJumped = false;
    super.onTapUp(event);
  }
}
