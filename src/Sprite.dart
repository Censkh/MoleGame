part of molegame;

class Sprite {

  bool _textureLoaded = false;
  RenderingContext _gl;
  Texture _texture;
  Point _tiledSize = new Point(0, 0);
  Point _currentTile = new Point(0, 0);
  ImageElement _element;
  List<Function> onLoaded = new List();

  Sprite(RenderingContext gl) {
    _gl = gl;
  }

  Texture load(String res) {
    RenderingContext gl = _gl;
    Texture texture;
    if (texture != null) gl.deleteTexture(getTexture());
    texture = gl.createTexture();
    gl.bindTexture(TEXTURE_2D, texture);
    _element = new ImageElement();

    void onLoad(Event e) {
      gl.bindTexture(TEXTURE_2D, texture);
      gl.pixelStorei(UNPACK_FLIP_Y_WEBGL, 1);
      gl.texImage2DImage(TEXTURE_2D, 0, RGBA, RGBA, UNSIGNED_BYTE, _element);
      gl.texParameteri(TEXTURE_2D, TEXTURE_MAG_FILTER, LINEAR);
      gl.texParameteri(TEXTURE_2D, TEXTURE_MIN_FILTER, LINEAR);
      gl.texParameteri(TEXTURE_2D, TEXTURE_WRAP_S, CLAMP_TO_EDGE);
      gl.texParameteri(TEXTURE_2D, TEXTURE_WRAP_T, CLAMP_TO_EDGE);
      gl.generateMipmap(TEXTURE_2D);
      _textureLoaded = true;
      gl.bindTexture(TEXTURE_2D, null);
      for (int i = 0; i < onLoaded.length;i++) {
        onLoaded[i]();
      }
    }
    _element.onLoad.listen(onLoad);
    _element.src = res;
    return _texture = texture;
  }

  Texture getTexture() {
    return _texture;
  }

  bool isTextureLoaded() {
    return _textureLoaded;
  }

  void setTileSize(Point size) {
    _tiledSize = size;
  }

  ImageElement getImageElement() {
    return _element;
  }

  ImageData getImageData() {
    var canvas = new CanvasElement(width: getImageElement().width, height: getImageElement().height);
    CanvasRenderingContext2D context = canvas.getContext('2d');
    context.drawImage(getImageElement(), 0, 0);
    return context.getImageData(0, 0, canvas.width, canvas.height);
  }

  Point getTiledSize() {
    return _tiledSize;
  }

  Point getCurrentTile() {
    return _currentTile;
  }

  void setCurrentTile(Point current) {
    _currentTile = current;
  }

  void dispose() {
    RenderingContext gl = Game.instance.gl;
    gl.deleteTexture(_texture);
    _textureLoaded = false;
    _element = null;
  }

}