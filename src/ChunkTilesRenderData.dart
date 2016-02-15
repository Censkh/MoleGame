part of molegame;

class ChunkTilesRenderData {

  Buffer vertBuffer;
  Buffer uvBuffer;
  UniformLocation offsetLocation;
  UniformLocation textureLocation;
  UniformLocation scaleLocation;
  int vertAttrib;
  int uvAttrib;
  bool dirty = true;
  bool initalized = false;
  int vertCount;
  List<List<Point>> tileUvs;

}