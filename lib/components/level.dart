import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/saw.dart';
import 'package:pixel_adventure/components/coin.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/spike.dart';
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

    // scrolling background
    // _scrollingBackground();

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

  //   if (backgroundLayer != null) {
  //     final backgroundColor =
  //         backgroundLayer.properties.getValue('BackgroundColor');

  //     final backgroundTile = BackgroundTile(
  //       color: backgroundColor ?? 'background_layer_1',
  //       position: Vector2(0, 0),
  //     );

  //     add(backgroundTile);
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
          //spawn player
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            // spawn player right way
            player.scale.x = 1;
            add(player);
            break;
          //spawn coins
          case 'Coin':
            final coin = Coin(
              coin: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(coin);
            break;
          //
          case 'Spike':
            final spike = Spike(
              position: Vector2(spawnPoint.x, spawnPoint.y + 12),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(spike);
            break;
          case 'Saw':
            //  get access to properties
            final isVertical = spawnPoint.properties.getValue('isVertical');
            final offNeg = spawnPoint.properties.getValue('offNeg');
            final offPos = spawnPoint.properties.getValue('offPos');

            final saw = Saw(
              isVertical: isVertical,
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(saw);

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
