part of molegame;

class TileBordersRenderer implements Renderer<Chunk> {

  List<List<Point>> borders = [
    [new Point(0, 0.75), new Point(0.25, 0.75), new Point(0.5, 0.75)],
    [new Point(0, 0.5), new Point(0.25, 0.5)],
    [new Point(0.5, 0.5)],
    [new Point(0.5, 0.25)],
  ];
  Sprite _sprite;
  World world;

  TileBordersRenderer(World world) {
    this.world = world;
  }

  void setup(RenderingContext gl) {
    _sprite = new Sprite(gl);
    _sprite.load("res/borders.png");
  }

  void render(RenderingContext gl, Chunk subject) {
    if (!_sprite.isTextureLoaded()) return;
    ChunkTileBordersRenderData data = subject.tileBordersRenderData;
    if (data.dirty) {
      bakeBuffers(gl, subject);
    }

    gl.bindTexture(TEXTURE_2D, _sprite.getTexture());

    gl.bindBuffer(ARRAY_BUFFER, data.vertBuffer);
    gl.enableVertexAttribArray(data.vertAttrib);
    gl.vertexAttribPointer(data.vertAttrib, 2, RenderingContext.FLOAT, false, 0, 0);

    gl.bindBuffer(ARRAY_BUFFER, data.uvBuffer);
    gl.enableVertexAttribArray(data.uvAttrib);
    gl.vertexAttribPointer(data.uvAttrib, 2, RenderingContext.FLOAT, false, 0, 0);
    Point size = Camera.main.transformScale(new Point(Chunk.tileSize, Chunk.tileSize));
    gl.uniform2f(data.scaleLocation, size.x, size.y);
    Point offset = Camera.main.transform(new Point(subject.getX() * Chunk.width * Chunk.tileSize, subject.getY() * Chunk.height * Chunk.tileSize));
    gl.uniform2f(data.offsetLocation, offset.x, offset.y);
    gl.drawArrays(TRIANGLES, 0, data.vertCount);
  }

  void bakeBuffers(RenderingContext gl, Chunk chunk) {
    ChunkTileBordersRenderData data = chunk.tileBordersRenderData;

    if (!data.initalized) {
      data.offsetLocation = gl.getUniformLocation(Game.instance.program, "uOffset");
      data.textureLocation = gl.getUniformLocation(Game.instance.program, "uTexture");
      data.scaleLocation = gl.getUniformLocation(Game.instance.program, "uScale");
      data.vertAttrib = gl.getAttribLocation(Game.instance.program, "aPosition");
      data.uvAttrib = gl.getAttribLocation(Game.instance.program, "aUv");
    }

    Random random = new Random();

    num uw = 4;
    num uh = 4;
    List<num> verts = new List();
    List<num> uvs = new List();
    data.vertCount = 0;
    for (int x = 0; x < Chunk.width;x++) {
      for (int y = 0;y < Chunk.height;y++) {
        Point uv = new Point(0, 3);
        num tile = chunk.getTile(x, y);
        if (tile > 0) {
          if (chunk.getTile(x, y + 1) == 0) {
            _addBorder(chunk, verts, uvs, x, y, uw, uh, new Point(0, 3), new Point(0, 0.5));
          }
          if (chunk.getTile(x, y - 1) == 0) {
            _addBorder(chunk, verts, uvs, x, y, uw, uh, new Point(0, 2), new Point(0, -0.5));
          }
          if (chunk.getTile(x + 1, y) == 0) {
            _addBorder(chunk, verts, uvs, x, y, uw, uh, new Point(2, 2), new Point(0.5, 0));
          }
          if (chunk.getTile(x - 1, y) == 0) {
            _addBorder(chunk, verts, uvs, x, y, uw, uh, new Point(2, 1), new Point(-0.5, 0));
          }
        }
      }
    }

    if (data.vertBuffer == null) data.vertBuffer = gl.createBuffer();
    gl.bindBuffer(ARRAY_BUFFER, data.vertBuffer);
    gl.bufferData(ARRAY_BUFFER, new Float32List.fromList(verts), STATIC_DRAW);

    if (data.uvBuffer == null) data.uvBuffer = gl.createBuffer();
    gl.bindBuffer(ARRAY_BUFFER, data.uvBuffer);

    gl.bufferData(ARRAY_BUFFER, new Float32List.fromList(uvs), STATIC_DRAW);

    data.dirty = false;
  }

  void _addBorder(Chunk chunk, List<num> verts, List<num> uvs, num x, num y, num uw, num uh, Point uv, Point offset) {
    ChunkTileBordersRenderData data = chunk.tileBordersRenderData;
    verts.addAll([
      x.toDouble() + offset.x, y.toDouble() + offset.y,
      x.toDouble() + offset.x, y + 1.0 + offset.y,
      x + 1.0 + offset.x, y + 1.0 + offset.y,

      x + 1.0 + offset.x, y + 1.0 + offset.y,
      x + 1.0 + offset.x, y.toDouble() + offset.y,
      x.toDouble() + offset.x, y.toDouble() + offset.y]);
    uvs.addAll([
      uv.x / uw, uv.y / uh,
      uv.x / uw, (uv.y + 1) / uh,
      (uv.x + 1) / uw, (uv.y + 1) / uh,

      (uv.x + 1) / uw, (uv.y + 1) / uh,
      (uv.x + 1) / uw, uv.y / uh,
      uv.x / uw, uv.y / uh]);
    data.vertCount += 6;
  }


}