part of molegame;

class World {

  static final int width = 8;
  static final int height = 6;

  ActorRenderer actorRenderer;
  ChunkRenderer chunkRenderer;
  List<Actor> actors;
  List<List<Chunk>> chunks;

  World() {
    actorRenderer = new ActorRenderer(this);
    chunkRenderer = new ChunkRenderer(this);
    actors = new List();
    chunks = new List(width);
  }

  void setup(RenderingContext gl) {
    actorRenderer.setup(gl);
    chunkRenderer.setup(gl);
  }

  void dispose(RenderingContext gl) {
    //gl.deleteBuffer(vertBuffer);
  }

  void update(num delta) {
    Point playerLocation = Game.instance.player.getLocation();
    Point chunkLocation = new Point((playerLocation.x / Chunk.tileSize / Chunk.width).floor(), (playerLocation.y / Chunk.tileSize / Chunk.height).floor());

    for (int cx = chunkLocation.x - 1; cx < chunkLocation.x + 2; cx++) {
      for (int cy = chunkLocation.y - 1; cy < chunkLocation.y + 2; cy++) {
        Chunk chunk = getChunk(cx, cy);
        if (chunk!=null && !chunk.isLoaded())
          chunk.load();
      }
    }

    for (int i = 0; i < actors.length;i++) {
      updateActor(delta, actors[i]);
    }
  }

  void updateActor(num delta, Actor actor) {
    actor.update(delta);
  }

  void render(RenderingContext gl) {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height;y++) {
        renderChunk(gl, getChunk(x, y));
      }
    }
    for (int i = 0; i < actors.length;i++) {
      renderActor(gl, actors[i]);
    }
  }

  void renderActor(RenderingContext gl, Actor actor) {
    actorRenderer.render(gl, actor);
  }

  void renderChunk(RenderingContext gl, Chunk chunk) {
    chunkRenderer.render(gl, chunk);
  }

  List<Chunk> getChunkList(int x) {
    List<Chunk> chunkList = chunks[x];
    if (chunkList == null) {
      chunkList = new List<Chunk>(height);
      chunks[x] = chunkList;
    }
    return chunkList;
  }

  Chunk getChunk(int x, int y) {
    if (!isChunkValid(x, y)) return null;
    List<Chunk> chunks = getChunkList(x);
    Chunk chunk = chunks[y];
    if (chunk==-1 || chunk == null) {
      chunk = new Chunk(this, x, y);
      chunks[y] = chunk;
      setChunk(chunk, x, y);
    }
    return chunk;
  }

  void setChunk(Chunk chunk, int x, int y) {
    if (!isChunkValid(x, y)) return;
    getChunkList(x)[y] = chunk;
  }

  bool isChunkValid(int x, int y) {
    return !(x >= width || x < 0 || y >= height || y < 0);
  }

  void setTile(num id, int x, int y) {
    int cx = (x.toDouble() / Chunk.width.toDouble()).floor();
    int cy = (y.toDouble() / Chunk.height.toDouble()).floor();
    Chunk chunk = getChunk(cx, cy);
    if (chunk == -1 || chunk == null) return;
    chunk.setTile(id, (x % Chunk.width).toInt(), (y % Chunk.height).toInt());
  }

  num getTile(int x, int y) {
    int cx = (x.toDouble() / Chunk.width.toDouble()).floor();
    int cy = (y.toDouble() / Chunk.height.toDouble()).floor();
    Chunk chunk = getChunk(cx, cy);
    if (chunk == -1 || chunk == null) return -1;
    return chunk.getTile((x % Chunk.width).toInt(), (y % Chunk.height).toInt());
  }

  void addActor(Actor actor) {
    actor.setWorld(this);
    actors.add(actor);
    actor.setupSprite(Game.instance.gl);
  }

  void removeActor(Actor actor) {
    actor.setWorld(null);
    actors.remove(actor);
  }

  Chunk getChunkFromWorldPos(num x, num y) {
    int cx = (x.toDouble() / Chunk.tileSize / Chunk.width.toDouble()).floor();
    int cy = (y.toDouble() / Chunk.tileSize / Chunk.height.toDouble()).floor();
    return getChunk(cx, cy);
  }

  bool isCollidingWithTilesAtLocation(Actor actor, num x, num y) {
    int tx = (x.toDouble() / Chunk.tileSize.toDouble()).floor();
    int ty = (y.toDouble() / Chunk.tileSize.toDouble()).floor();
    int tw = (actor.getRenderWidth().toDouble() / Chunk.tileSize.toDouble()).ceil() + 1;
    int th = (actor.getRenderHeight().toDouble() / Chunk.tileSize.toDouble()).ceil() + 1;
    Rectangle actorBox = new Rectangle(x.toDouble() + actor.getHitbox().left, y.toDouble() + actor.getHitbox().top, actor.getHitbox().width, actor.getHitbox().height);
    for (int cx = 0;cx < tw; cx++) {
      for (int cy = 0; cy < th;cy++) {
        if (getTile(tx + cx, ty + cy) != 0 && new Rectangle((tx + cx).toDouble() * Chunk.tileSize, (ty + cy).toDouble() * Chunk.tileSize, Chunk.tileSize.toDouble(), Chunk.tileSize.toDouble()).intersects(actorBox)) {
          return true;
        }
      }
    }
    return false;
  }

  bool isCollidingWithTiles(Actor actor) {
    return isCollidingWithTilesAtLocation(actor, actor.getX(), actor.getY());
  }

}