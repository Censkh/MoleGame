part of molegame;

abstract class Actor {

  num getX();

  num getY();

  num getRenderWidth();

  num getRenderHeight();

  Point getRenderSize();

  void move(num x, num y);

  void moveIfFree(num x, num y);

  void setupSprite(RenderingContext gl);

  void addTo(World world);

  World getWorld();

  Rectangle getHitbox();

  Sprite getSprite();

  void setWorld(World world);

  void update(num delta);

  Point getLocation();

  String getTextureName();

  Point getScale();

  void setScale(Point scale);

}