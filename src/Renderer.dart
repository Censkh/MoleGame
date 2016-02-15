part of molegame;

abstract class Renderer<T> {

  void setup(RenderingContext gl);

  void render(RenderingContext gl, T subject);

}