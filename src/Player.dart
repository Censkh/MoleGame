part of molegame;

class Player extends AbstractActor {

  List<int> dirs = new List();
  Point velocity = new Point(0, 0);
  num timer = 0.0;
  num jumpTimer = 0.0;
  bool jumping = false;

  Player() {
    Game.instance.keyboard.addPressListener((KeyboardEvent e) {
      if (e.keyCode == KeyCode.SPACE) {
        jump();
      }
    });
  }

  void setupSprite(RenderingContext gl) {
    super.setupSprite(gl);
    getSprite().setTileSize(new Point(12, 12));
  }

  void update(num delta) {
    num clamp = 0.05;
    if (velocity.y.abs() < clamp) velocity = new Point(velocity.x, 0);
    if (velocity.x.abs() < clamp) velocity = new Point(0, velocity.y);
    moveIfFree(getX() + (velocity.x * 0.13 * delta), getY() + (velocity.y * 0.13 * delta));
    num friction = 0.93;
    velocity = new Point(velocity.x * friction, velocity.y * friction);
    moveIfFree(getX(), getY() - (0.32 * delta));
    if (Game.instance.keyboard.isKeyPressed(KeyCode.A)) {
      moveIfFree(getX() - (0.2 * delta), getY());
      setScale(new Point(-1.0, getScale().y));
      timer += delta;
    } else if (Game.instance.keyboard.isKeyPressed(KeyCode.D)) {
      moveIfFree(getX() + (0.2 * delta), getY());
      setScale(new Point(1.0, getScale().y));
      timer += delta;
    } else {
      timer = 0;
      getSprite().setCurrentTile(new Point(0, 0));
    }
    if (timer > 30) {
      timer = 0;
      getSprite().setCurrentTile(new Point((getSprite().getCurrentTile().x + 1) % 9, 0));
    }
    if (jumping) {
      if (Game.instance.keyboard.isKeyPressed(KeyCode.SPACE)) {
        jumpTimer += delta;
        velocity = new Point(velocity.x, 5.4);
      }
    }
    if ((isGrounded() && jumpTimer > 200) || !Game.instance.keyboard.isKeyPressed(KeyCode.SPACE) || jumpTimer > 200 || getWorld().isCollidingWithTilesAtLocation(this, getX(), getY() + 4)) {
      jumping = false;
      jumpTimer = 0.0;
    }
  }

  bool isGrounded() {
    return getWorld().isCollidingWithTilesAtLocation(this, getX(), getY() - 4);
  }

  void jump() {
    if (isGrounded() && !jumping) {
      jumping = true;
      jumpTimer = 0.0;
    }
  }

  String getTextureName() {
    return "res/mole.png";
  }

  Rectangle getHitboxInternal() {
    return new Rectangle(0, 0, Chunk.tileSize - 24, Chunk.tileSize - 16);
  }

}