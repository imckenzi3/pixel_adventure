import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/components/background_tile.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

// needs to have HasCollisionDetection so stuff we need to collide can have collisionsCallbacks
class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  late final CameraComponent cam;
  Player player = Player(character: 'character');

  // create joystick
  late JoystickComponent joystick;

  // checks for if on desktop dont need joystick if on desktop
  bool showJoystick = false;

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

    if (showJoystick) {
      // joystick
      addJoystick();
    }

    return super.onLoad();
  }

  // check where joystick is currently positioned
  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
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
}
