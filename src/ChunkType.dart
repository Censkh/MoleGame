part of molegame;

class ChunkType {

  static ChunkType LEVEL_0_AA = new ChunkType("res/levels/level0.png",0);

  String _path;
  int _type;

  ChunkType(String path, int type) {
    _path = path;
    _type = type;
  }

  String getPath() {
    return _path;
  }

  int getType() {
    return _type;
  }

}