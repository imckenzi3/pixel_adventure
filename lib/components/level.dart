import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Level extends World with HasGameRef<PixelAdventure> {
  final String levelName;
  final Player player;

  Level({required this.levelName, required this.player});
  late TiledComponent level;

  // Collisions
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('level-01.tmx', Vector2.all(24));

    // add level to game
    add(level);

    // spawning objects
    _spawningObjects();

    // add object collisions
    _addCollisions();

    return super.onLoad();
  }

  // background
  // void _scrollingBackground() {
  //   // get access to background layers
  //   final backgroundLayer = level.tileMap.getLayer('Background');

  //   const tileSize = 32;
  //   final numtilesY = (game.size.x / tileSize).floor();

  //   if (backgroundLayer != null) {
  //     final backgroundColor =
  //         backgroundLayer.properties.getValue('BackgroundColor');

  //     for (double y = 0; y < numtilesY; y++) {
  //       final backgroundTile = BackgroundTile(
  //         color: backgroundColor ?? 'background_layer_1',
  //         position: Vector2(0, y * tileSize),
  //       );

  //       add(backgroundTile);
  //     }
  //   }
  // }

  // spawning objects
  void _spawningObjects() {
    //grab spawn layer
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointsLayer != null) {
      // checks for spawn points
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          default:
        }
      }
    }
  }

  // add object collisions
  void _addCollisions() {
    // Collision
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );

            collisionBlocks.add(platform);

            // see collision block on screen
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }

    player.collisionBlocks = collisionBlocks;
  }
}
