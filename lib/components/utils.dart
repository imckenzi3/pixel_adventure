bool checkCollision(player, block) {
  final hitbox = player.hitbox;

  // grab ref from player (x,y,width,heigth)
  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  // grab ref from object (x,y,width,heigth)
  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  // fix y based on left or right
  // check if scale is less than 0 = going left
  final fixedX = player.scale.x < 0
      ? playerX - (hitbox.offsetX * 2) - playerWidth
      : playerX;

  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

  // return if colliding
  return (fixedY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}
