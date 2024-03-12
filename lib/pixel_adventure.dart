import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
import 'package:pixel_adventure/components/background_tile.dart';
import 'package:pixel_adventure/components/jump_button.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

// needs to have HasCollisionDetection so stuff we need to collide can have collisionsCallbacks
class PixelAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  late final CameraComponent cam;
  Player player = Player(character: 'character');

  // create joystick
  late JoystickComponent joystick;

  // checks for if on desktop dont need joystick if on desktop
  bool showControls = false;

  // health bar
  late TextComponent _playerHealth;

  // score
  late TextComponent _playerScore;

  // Returns the size of the playable area of the game window.
  Vector2 fixedResolution = Vector2(650, 360);

  @override
  FutureOr<void> onLoad() async {
    // load all images into chache
    // if alot of images can cause issues.
    await images.loadAllImages();

    @override
    final world = Level(
      player: player,
      levelName: 'level-01.tmx',
    );

    // creates cam component w/ fix resolution
    cam = CameraComponent.withFixedResolution(
        world: world, width: 650, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;

    // load cam first then world
    addAll([cam, world, BackgroundTile()]);

    if (showControls) {
      // add joyStick
      addJoystick();
      // add jumpButton
      add(JumpButton());
    }

    // score

    // Create text component for player score.
    _playerScore = TextComponent(
      text: 'Score: 0',
      position: Vector2(10, 10),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'Sans',
        ),
      ),
    );
    add(_playerScore);

    // health bar
    // game start health 100%
    _playerHealth = TextComponent(
      text: 'Health: 100%',

      // health bar location
      position: Vector2(size.x - 10, 10),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'Sans',
        ),
      ),
    );
    _playerHealth.anchor = Anchor.topRight;
    add(_playerHealth);

    return super.onLoad();
  }

  // check where joystick is currently positioned
  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }

    // update score
    _playerScore.text = 'Score: ${player.score}';

    // update health
    _playerHealth.text = 'Health: ${player.health}%';

    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      // sets images as priority (10 layers above 0)
      priority: 10,

      //create knob
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      // where we want to place the joystick
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    // add joystick to game
    add(joystick);
  }

  // grabs joysticks directions
  // based on directions set player direction
  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        // idle
        player.horizontalMovement = 0;
        break;
    }
  }

  // health bar
  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // draw rectangle
    canvas.drawRect(
      Rect.fromLTWH(size.x - 100, 10, player.health.toDouble(), 10),
      Paint()..color = Colors.green,
    );
  }
}
