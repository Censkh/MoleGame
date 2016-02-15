part of molegame;

class TilesRenderer implements Renderer<Chunk> {

  Sprite _sprite;
  World world;

  TilesRenderer(World world) {
    this.world = world;
  }

  void setup(RenderingContext gl) {
    _sprite = new Sprite(gl);
    _sprite.load("res/tiles.png");
  }

  void render(RenderingContext gl, Chunk subject) {
    if (!_sprite.isTextureLoaded()) return;
    ChunkTilesRenderData data = subject.tilesRenderData;
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

  void bakeTilesUvs(RenderingContext gl, Chunk chunk) {
    ChunkTilesRenderData data = chunk.tilesRenderData;

    Random random = new Random();

    data.tileUvs = new List(Chunk.width + 1);
    for (int x = 0; x < data.tileUvs.length;x++) {
      data.tileUvs[x] = new List(Chunk.height + 1);
    }
    for (int x = 0; x < Chunk.width; x++) {
      for (int y = 0; y < Chunk.height;y++) {
        Point current = data.tileUvs[x][y];
        if (current == null) {
          if (chunk.getTile(x, y) > 0) {
            num x1 = chunk.getTile(x + 1, y);
            num y1 = chunk.getTile(x, y + 1);
            num xy1 = chunk.getTile(x + 1, y + 1);
            if (x1 > 0 && y1 > 0 && xy1 > 0 && data.tileUvs[x + 1][y] == null && data.tileUvs[x + 1][y + 1] == null && data.tileUvs[x][y + 1] == null&&random.nextBool()) {
              num xo = random.nextInt(2);
              num yo = random.nextInt(2);
              for (int tx = x; tx < x + 2; tx++) {
                for (int ty = y; ty < y + 2; ty++) {
                  num u = (tx - x) + (xo * 2);
                  num v = (ty - y) + (yo * 2);
                  data.tileUvs[tx][ty] = new Point(u, v);
                }
              }
              continue;
            } else if (x1 > 0 && y1 <= 0 && data.tileUvs[x + 1][y] == null&&random.nextBool()) {
              num xo = random.nextInt(2);
              for (int tx = x; tx < x + 2;tx++) {
                num u = (tx - x) + (xo * 2);
                num v = 4;
                data.tileUvs[tx][y] = new Point(u, v);
              }
              continue;
            } else if (y1 > 0 && x1 <= 0 && data.tileUvs[x][y + 1] == null&&random.nextBool()) {
              num xo = random.nextInt(2);
              for (int ty = y; ty < y + 2;ty++) {
                num u = 2 + xo;
                num v = 5 + (ty - y);
                data.tileUvs[x][ty] = new Point(u, v);
              }
              continue;
            }
          }
          num u = random.nextInt(2);
          num v = 6.0 - random.nextInt(2);
          data.tileUvs[x][y] = new Point(u, v);
        }
      }
    }
  }

  void bakeBuffers(RenderingContext gl, Chunk chunk) {
    ChunkTilesRenderData data = chunk.tilesRenderData;

    if (!data.initalized) {
      data.offsetLocation = gl.getUniformLocation(Game.instance.program, "uOffset");
      data.textureLocation = gl.getUniformLocation(Game.instance.program, "uTexture");
      data.scaleLocation = gl.getUniformLocation(Game.instance.program, "uScale");
      data.vertAttrib = gl.getAttribLocation(Game.instance.program, "aPosition");
      data.uvAttrib = gl.getAttribLocation(Game.instance.program, "aUv");

      bakeTilesUvs(gl, chunk);
    }

    num uw = 4.0;
    num uh = 7.0;
    List<num> verts = new List();
    List<num> uvs = new List();
    data.vertCount = 0;
    for (int x = 0; x < Chunk.width;x++) {
      for (int y = 0;y < Chunk.height;y++) {
        Point uv = data.tileUvs[x][y];
        num tile = chunk.getTile(x, y);
        if (tile > 0) {
          verts.addAll([
            x.toDouble(), y.toDouble(),
            x.toDouble(), y + 1.0,
            x + 1.0, y + 1.0,

            x + 1.0, y + 1.0,
            x + 1.0, y.toDouble(),
            x.toDouble(), y.toDouble()]);
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
    }

    if (data.vertBuffer == null) data.vertBuffer = gl.createBuffer();
    gl.bindBuffer(ARRAY_BUFFER, data.vertBuffer);
    gl.bufferData(ARRAY_BUFFER, new Float32List.fromList(verts), STATIC_DRAW);

    if (data.uvBuffer == null) data.uvBuffer = gl.createBuffer();
    gl.bindBuffer(ARRAY_BUFFER, data.uvBuffer);

    gl.bufferData(ARRAY_BUFFER, new Float32List.fromList(uvs), STATIC_DRAW);

    data.dirty = false;
  }


}