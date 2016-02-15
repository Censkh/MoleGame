part of molegame;

class Camera extends AbstractActor {

  static Camera main;
  Point scale = new Point(1.5, 1.5);

  Camera() {
    move(-640.0 / scale.x, -480.0 / scale.y);
  }


  Point transform(Point point) {
    return transformPerspective(_transformScaleInternal(_transformLocationInternal(point)));
  }

  Point transformScale(Point point) {
    return transformPerspective(_transformScaleInternal(point));
  }

  Point transformLocation(Point point) {
    return transformPerspective(_transformLocationInternal(point));
  }

  Point _transformScaleInternal(Point point) {
    return new Point(point.x * scale.x, point.y * scale.y);
  }

  Point _transformLocationInternal(Point point) {
    return point - getLocation();
  }

  Point transformPerspective(Point point) {
    CanvasElement canvas = Game.instance.canvas;
    return new Point(point.x.toDouble() / canvas.width.toDouble(), point.y.toDouble() / canvas.height.toDouble());
  }

  void update(num delta) {
    Player player = Game.instance.player;
    Point dest = player.getLocation();
    move(getX()+((dest.x-getX())/10), getY()+((dest.y-getY())/10));
  }

  String getTextureName() {
    return null;
  }


}