bool checkCollision(player, block) {
  // grab ref from player (x,y,width,heigth)
  final playerX = player.position.x;
  final playerY = player.position.y;
  final playerWidth = player.width;
  final playerHeight = player.height;

  // grab ref from object (x,y,width,heigth)
  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  // fix y based on left or right
  // check if scale is less than 0 = going left
  final fixedX = player.scale.x < 0 ? playerX - playerWidth : playerX;

  // return if colliding
  return (playerY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}
