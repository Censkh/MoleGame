part of molegame;

class ChunkRenderer implements Renderer<Chunk> {

  World world;
  TilesRenderer tileRenderer;
  TileBordersRenderer tileBordersRenderer;

  ChunkRenderer(World world) {
    this.world = world;
    this.tileRenderer = new TilesRenderer(world);
    this.tileBordersRenderer = new TileBordersRenderer(world);
  }

  void setup(RenderingContext gl) {
    tileRenderer.setup(gl);
    tileBordersRenderer.setup(gl);
  }

  void render(RenderingContext gl, Chunk subject) {
    tileRenderer.render(gl,subject);
    tileBordersRenderer.render(gl,subject);
  }

}