import 'dart:async';
// import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

// player state - allows us to give different states that we can call later
enum PlayerState { idle, running }

// keeps track of player direction
enum PlayerDirection { left, right, none }

// check if player facing right
bool isFacingRight = true;

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  String character;
  // if no character set default to character
  Player({position, this.character = 'character'}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  final double stepTime = 0.1;

  // ref to PlayerState enum
  PlayerDirection playerDirection = PlayerDirection.none;

  // move player
  double movespeed = 100;
  Vector2 velocity = Vector2.zero();

  // make player move
  // best way: make var = velocity, change velocty and set to player position

  // animations
  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  // movement
  @override
  void update(double dt) {
    // method for playermovement
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  // keyboard
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // check if a or left arror are pressed
    // ignore: collection_methods_unrelated_type
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);

    // ignore: collection_methods_unrelated_type
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    // both left and right pressed same time nothing happens
    if (isLeftKeyPressed && isRightKeyPressed) {
      playerDirection = PlayerDirection.none;
    } else if (isLeftKeyPressed) {
      playerDirection = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      playerDirection = PlayerDirection.right;
    } else {
      playerDirection = PlayerDirection.none;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  // animations
  void _loadAllAnimations() {
    // idle animation
    idleAnimation = _spriteAnimation('idle', 6);

    // running animation
    runningAnimation = _spriteAnimation('running', 8);

    // different animations linked to enum (list of all animations)
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation
    };

    // set current animation
    current = PlayerState.idle;
  }

// method for animations
  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('character/$state.png'),
      SpriteAnimationData.sequenced(
          amount: amount, stepTime: stepTime, textureSize: Vector2.all(56)),
    );
  }

// method for playermovement
  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;

    //see which direction is player
    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          // if is facing right flip character
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        // what we do when player is facing left
        // change direction x
        // set current animation
        current = PlayerState.running;
        dirX -= movespeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          // if is NOT facing right flip character
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        // what we do when player is facing right
        // change direction x
        // set current animation
        current = PlayerState.running;
        dirX += movespeed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
      default:
    }

    velocity = Vector2(dirX, 0.0);
    position += velocity * dt;
  }
}
