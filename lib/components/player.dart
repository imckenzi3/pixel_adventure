import 'dart:async';
// import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/components/collision_block.dart';
// import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

// player state - allows us to give different states that we can call later
enum PlayerState { idle, running }

// // keeps track of player direction
// enum PlayerDirection { left, right, none }

// check if player facing right
// bool isFacingRight = true;

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  String character;
  // if no character set default to character
  Player({position, this.character = 'character'}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  final double stepTime = 0.1;

  // ref to PlayerState enum
  // PlayerDirection playerDirection = PlayerDirection.none;

  // move player
  // horizontalMovement will check for left and right
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();

  List<CollisionBlock> collisionBlocks = [];
  // make player move
  // best way: make var = velocity, change velocty and set to player position

  // animations
  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();

    // player collisions
    debugMode = true;
    return super.onLoad();
  }

  // movement
  @override
  void update(double dt) {
    // update player state
    _updatePlayerState();

    // method for playermovement
    _updatePlayerMovement(dt);

    // horizontalCollisionCheck
    _checkHorizontalCollisions();

    super.update(dt);
  }

  // keyboard
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;

    // check if a or left arror are pressed
    // ignore: collection_methods_unrelated_type
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);

    // ignore: collection_methods_unrelated_type
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    // check if going left or right
    // add value if pressing left or right
    // fancy if: if left key press go left else true go right
    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

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

  // update player state
  void _updatePlayerState() {
    // grab playerer state
    PlayerState playerstate = PlayerState.idle;

    // update player animations if going left or right
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // Check if moving, set running
    if (velocity.x > 0 || velocity.x < 0) playerstate = PlayerState.running;

    current = playerstate;
  }

// method for playermovement
  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

// horizontalCollisionCheck
  void _checkHorizontalCollisions() {
    // loop through collision box
    for (final block in collisionBlocks) {
      // handle collision
    }
  }
}
