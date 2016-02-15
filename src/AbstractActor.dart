part of molegame;

abstract class AbstractActor implements Actor {

  num _x = 0;
  num _y = 0;
  World _world;
  Sprite _sprite;
  bool _textureLoaded = false;
  Point _size = new Point(80, 80);
  Point _scale = new Point(1, 1);

  void setupSprite(RenderingContext gl) {
    _sprite = new Sprite(gl);
    if (getTextureName() != null) {
      _sprite.load(getTextureName());
    }
  }

  void setWorld(World world) {
    if (_world != null) _world.removeActor(this);
    _world = world;
  }

  void addTo(World world) {
    world.addActor(this);
  }

  World getWorld() {
    return _world;
  }

  void move(num x, num y) {
    _x = x;
    _y = y;
  }

  void moveIfFree(num x, num y) {
    if (!getWorld().isCollidingWithTilesAtLocation(this, x, y)) {
      move(x, y);
    } else {
      num cx = (getX() - x).abs();
      num cy = (getY() - y).abs();
      bool dx = x > getX();
      bool dy = y > getY();
      num check = 1;
      while (cx >= 0 || cy >= 0) {
        cx -= check;
        cy -= check;
        if (cx >= 0) x += check * (dx ? -1.0 : 1.0);
        if (cy >= 0) y += check * (dy ? -1.0 : 1.0);
        if (!getWorld().isCollidingWithTilesAtLocation(this, x, y)) {
          move(x, y);
          return;
        }
      }
    }
  }

  num getX() {
    return _x;
  }

  num getY() {
    return _y;
  }

  Point getLocation() {
    return new Point(getX(), getY());
  }

  Sprite getSprite() {
    return _sprite;
  }

  Point getRenderSize() {
    return _size;
  }

  num getRenderWidth() {
    return getRenderSize().x;
  }

  num getRenderHeight() {
    return getRenderSize().y;
  }

  Rectangle getHitbox() {
    return getHitboxInternal();
  }

  Rectangle getHitboxInternal() {
    return new Rectangle(0, 0, getRenderWidth(), getRenderHeight());
  }

  void setScale(Point scale) {
    _scale = scale;
  }

  Point getScale() {
    return _scale;
  }

}