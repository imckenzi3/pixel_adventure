import 'dart:async';
// import 'dart:html';
// import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/components/Saw.dart';
import 'package:pixel_adventure/components/coin.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/custom_hitbox.dart';
import 'package:pixel_adventure/components/utils.dart';
// import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

// player state - allows us to give different states that we can call later
enum PlayerState { idle, running, jumping, falling, hit, appearing, death }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler, CollisionCallbacks {
  String character;
  // if no character set default to character
  Player({position, this.character = 'character'}) : super(position: position);

  final double stepTime = 0.1;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation deathAnimation;

  // move player
  // horizontalMovement will check for left and right
  double horizontalMovement = 0;
  double moveSpeed = 100;

  // health
  int health = 100;

  // score
  int score = 0;

  // starting position
  Vector2 startingPosition = Vector2.zero();

  Vector2 velocity = Vector2.zero();

  // gravity
  final double _gravity = 9.8;
  final double _jumpForce = 450;
  final double _terminalVelocity = 300;

  bool isOnGround = false;

  // jumping
  bool hasJumped = false;

  // got hit
  bool gotHit = false;

  List<CollisionBlock> collisionBlocks = [];

  // player hitbox
  CustomHitbox hitbox =
      CustomHitbox(offsetX: 20, offsetY: 12, width: 20, height: 35);

  // make player move
  // best way: make var = velocity, change velocty and set to player position

  // animations
  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();

    // as soon as player spawns set starting position
    startingPosition = Vector2(position.x, position.y);

    // player collisions
    debugMode = true;

    // hitbox
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));
    return super.onLoad();
  }

  // movement
  @override
  void update(double dt) {
    // check to see not gotHit
    if (!gotHit) {
      // update player state
      _updatePlayerState();

      // method for playermovement
      _updatePlayerMovement(dt);

      // horizontalCollisionCheck
      _checkHorizontalCollisions();

      // gravity
      // check collisions first before gravity
      _applyGravty(dt);

      // check vert collisions
      _checkVerticalCollisions();
    }
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

    // jump - if played pressed space, hasJumped = true
    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }

  // collision
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // if collide with coin
    if (other is Coin) other.collidedWithPlayer();

    // if collide with saw
    if (other is Saw) _respawn();

    if (other is Saw) {
      health -= 10;
      if (health <= 0) {
        health = 0;
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  // animations
  void _loadAllAnimations() {
    // idle animation
    idleAnimation = _spriteAnimation('idle', 6);

    // running animation
    runningAnimation = _spriteAnimation('running', 8);

    // jumping animation
    jumpingAnimation = _spriteAnimation('jump', 8);

    // falling animation
    fallingAnimation = _spriteAnimation('fall', 8);

    // hit animation
    hitAnimation = _spriteAnimation('hit', 4);

    // appearing animation
    appearingAnimation = _specialSpriteAnimation('appearing', 8);

    // death animation
    deathAnimation = _specialSpriteAnimationDeath('death', 8);

    // different animations linked to enum (list of all animations)
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.appearing: appearingAnimation,
      PlayerState.death: deathAnimation
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

  // appearing / death
  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Effects/$state.png'),
      SpriteAnimationData.sequenced(
          amount: amount, stepTime: stepTime, textureSize: Vector2.all(16)),
    );
  }

  // death - do we need special?
  SpriteAnimation _specialSpriteAnimationDeath(String state, int amount) {
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

    // Check if falling set to falling
    if (velocity.y > 0) playerstate = PlayerState.falling;

    // Check if jumping set to jumping
    if (velocity.y < 0) playerstate = PlayerState.jumping;

    current = playerstate;
  }

// method for playermovement
  void _updatePlayerMovement(double dt) {
    // jump
    if (hasJumped && isOnGround) {
      _playerJump(dt);
    }

    //platform collisions
    //if (velocity.y > _gravity) isOnGround = false; //optional

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  // jump
  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

// horizontalCollisionCheck
  void _checkHorizontalCollisions() {
    // loop through collision box
    for (final block in collisionBlocks) {
      // make sure block is not a platform
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            // stop velocty change position on x
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

//gravity
  void _applyGravty(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

// vert collisions
  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        // check collision to see if colliding with block
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }

  // respawn
  // got hit, play hit animation, appearing animation, move to starting pos, delay
  // let player move
  void _respawn() async {
    const hitDuration = Duration(milliseconds: 500);

    gotHit = true;
    current = PlayerState.hit;

    // appearing
    const appearingDuration = Duration(milliseconds: 700);

    // move duration
    const canMoveDuration = Duration(milliseconds: 400);

    // position
    // position = startingPosition - Vector2.all(40);

    // delay code
    Future.delayed(hitDuration, () {
      // hit player move to starting pos

      // always facing right
      scale.x = 1;
      position = startingPosition - Vector2.all(-20);

      // animation
      // animation plays a bit off need to find a way to off set it to normal
      current = PlayerState.appearing;

      Future.delayed(appearingDuration, () {
        velocity = Vector2.zero();
        position = startingPosition;
        _updatePlayerState();
        Future.delayed(canMoveDuration, () => gotHit = false);
      });
    });
  }
}
