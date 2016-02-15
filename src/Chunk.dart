part of molegame;

class Chunk {

  static final num width = 8;
  static final num height = 8;
  static final num tileSize = 64;

  World _world;
  int _x;
  int _y;
  List<Uint8List> _tiles;
  ChunkTilesRenderData tilesRenderData;
  ChunkTileBordersRenderData tileBordersRenderData;
  bool _loaded;

  Chunk(World world, int x, int y) {
    _world = world;
    _x = x;
    _y = y;
    _tiles = new List(width);
    tilesRenderData = new ChunkTilesRenderData();
    tileBordersRenderData = new ChunkTileBordersRenderData();
  }

  void load() {
    loadFromType(ChunkType.LEVEL_0_AA);
    _loaded = true;
  }

  void loadFromType(ChunkType type) {
    Sprite sprite = new Sprite(Game.instance.gl);
    sprite.load(type.getPath());
    sprite.onLoaded.add((){
      loadFromSprite(sprite);
      sprite.dispose();
    });
  }

  void loadFromSprite(Sprite sprite) {
    List<int> data = sprite.getImageData().data;
    for (int x = 0; x < width; x++) {
      for (int y= 0; y < height; y++) {
        int i = (x+(y*width))*4;
        int r = data[i];
        int g = data[i+1];
        int b = data[i+2];
        if (r>250) {
          setTile(1,x,height-y-1);
        }
      }
    }
  }

  void loadFromData(List<List<num>> data) {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        setTile(data[y][x],x,y);
      }
    }
  }

  bool isLoaded() {
    return _loaded;
  }

  Uint8List getTilesYList(int x) {
    Uint8List byteList = _tiles[x];
    if (byteList == null) {
      _tiles[x] = byteList = new Uint8List(height);
    }
    return byteList;
  }

  num getTile(int x, int y) {
    if (!isTileValid(x, y)) {
      int cx = (x.toDouble() / Chunk.width.toDouble()).floor();
      int cy = (y.toDouble() / Chunk.height.toDouble()).floor();
      Chunk chunk = getWorld().getChunk(getX() + cx, getY() + cy);
      if (chunk != null)
        return chunk.getTile(
            x > 0 ? x % Chunk.width : Chunk.width - (x.abs() % Chunk.width),
            y > 0 ? y % Chunk.height : Chunk.height - (y.abs() % Chunk.height)
        );
      else return 0;
    }
    return getTilesYList(x)[y];
  }

  void setTile(num id, int x, int y) {
    if (!isTileValid(x, y)) return;
    Uint8List list = getTilesYList(x);
    if (list[y] != id) {
      list[y] = id;
      tilesRenderData.dirty = tileBordersRenderData.dirty = true;
    }
  }

  bool isTileValid(int x, int y) {
    return !(x >= width || x < 0 || y >= height || y < 0);
  }

  World getWorld() {
    return _world;
  }

  int getX() {
    return _x;
  }

  int getY() {
    return _y;
  }

}