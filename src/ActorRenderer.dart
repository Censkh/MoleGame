part of molegame;

class ActorRenderer implements Renderer<Actor> {

  World world;

  Buffer vertBuffer;
  Buffer uvBuffer;
  UniformLocation offsetLocation;
  UniformLocation textureLocation;
  UniformLocation scaleLocation;
  int vertAttrib;
  int uvAttrib;

  ActorRenderer(World world) {
    this.world = world;
  }

  void setup(RenderingContext gl) {
    vertBuffer = gl.createBuffer();
    gl.bindBuffer(ARRAY_BUFFER, vertBuffer);
    List<num> verts = [
      -0.5, -0.5,
      -0.5, 0.5,
      0.5, 0.5,

      0.5, 0.5,
      0.5, -0.5,
      -0.5, -0.5];
    gl.bufferData(ARRAY_BUFFER, new Float32List.fromList(verts), STATIC_DRAW);

    uvBuffer = gl.createBuffer();

    offsetLocation = gl.getUniformLocation(Game.instance.program, "uOffset");
    textureLocation = gl.getUniformLocation(Game.instance.program, "uTexture");
    scaleLocation = gl.getUniformLocation(Game.instance.program, "uScale");
    vertAttrib = gl.getAttribLocation(Game.instance.program, "aPosition");
    uvAttrib = gl.getAttribLocation(Game.instance.program, "aUv");
  }

  void render(RenderingContext gl, Actor subject) {
    if (!subject.getSprite().isTextureLoaded()) {
      return;
    }
    gl.bindTexture(TEXTURE_2D, subject.getSprite().getTexture());

    gl.bindBuffer(ARRAY_BUFFER, vertBuffer);
    gl.enableVertexAttribArray(vertAttrib);
    gl.vertexAttribPointer(vertAttrib, 2, RenderingContext.FLOAT, false, 0, 0);

    gl.bindBuffer(ARRAY_BUFFER, uvBuffer);
    Point uv = new Point(subject.getSprite().getCurrentTile().x,subject.getSprite().getTiledSize().y-subject.getSprite().getCurrentTile().y - 1);
    List<num> uvs = [
      uv.x/subject.getSprite().getTiledSize().x, uv.y/subject.getSprite().getTiledSize().y,
      uv.x/subject.getSprite().getTiledSize().x, (uv.y+1)/subject.getSprite().getTiledSize().y,
      (uv.x+1)/subject.getSprite().getTiledSize().x, (uv.y+1)/subject.getSprite().getTiledSize().y,

      (uv.x+1)/subject.getSprite().getTiledSize().x, (uv.y+1)/subject.getSprite().getTiledSize().y,
      (uv.x+1)/subject.getSprite().getTiledSize().x, uv.y/subject.getSprite().getTiledSize().y,
      uv.x/subject.getSprite().getTiledSize().x, uv.y/subject.getSprite().getTiledSize().y];
    gl.bufferData(ARRAY_BUFFER, new Float32List.fromList(uvs), STATIC_DRAW);

    gl.bindBuffer(ARRAY_BUFFER, uvBuffer);
    gl.enableVertexAttribArray(uvAttrib);
    gl.vertexAttribPointer(uvAttrib, 2, RenderingContext.FLOAT, false, 0, 0);
    Point point = Camera.main.transform(new Point(subject.getX() + (subject.getHitbox().width/2.0), subject.getY() + 32));
    gl.uniform2f(offsetLocation, point.x  , point.y  );
    Point size = Camera.main.transformScale(new Point(subject.getRenderWidth() * subject.getScale().x, subject.getRenderHeight()*subject.getScale().y));
    gl.uniform2f(scaleLocation, size.x, size.y);
    gl.drawArrays(TRIANGLES, 0, 6);
  }

}