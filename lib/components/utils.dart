bool checkCollision(player, block) {
  // grab ref from player (x,y,width,heigth)
  final playerX = player.position.x;
  final playerY = player.position.y;
  final playerWidth = player.width;
  final playerHeight = player.height;

  // grab ref from object (x,y,width,heigth)
  final blockX = block.x;
  final blockY = block.x;
  final blockWidth = block.width;
  final blockHeight = block.height;

  // return if colliding
  return (playerY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      playerX < blockX + blockWidth &&
      playerX + playerWidth > blockX);
}
