part of molegame;

class Game {

  static Game instance;
  RenderingContext gl;
  GameTimer timer;
  CanvasElement canvas;
  World world;
  Keyboard keyboard;
  Player player;

  Program program;
  Shader fragShader, vertShader;

  num fpsTimer = 0;

  Game() {
    instance = this;
    timer = new GameTimer();
    world = new World();
    keyboard = new Keyboard();
    canvas = document.getElementById("mgcanvas") as CanvasElement;
    gl = canvas.getContext3d(alpha:false);
    setupGL();
    Camera.main = new Camera();
    Camera.main.addTo(world);
    world.setup(gl);
    player = new Player();
    player.addTo(world);
    player.move(640, 480);

    window.animationFrame.then(gameLoop);
  }

  void setupGL() {
    program = gl.createProgram();
    fragShader = createShader(FRAGMENT_SHADER, "res/shader.frag");
    vertShader = createShader(VERTEX_SHADER, "res/shader.vert");
    gl.linkProgram(program);
    gl.viewport(0, 0, (canvas.clientWidth).toInt(), (canvas.clientHeight).toInt());

    gl.enable(BLEND);
    gl.disable(DEPTH_TEST);
    gl.blendFunc(SRC_ALPHA, ONE_MINUS_SRC_ALPHA);
    gl.clearColor(0.5,0.5,0.5,1.0);
    gl.useProgram(program);
    gl.depthFunc(LESS);
  }

  Shader createShader(int type, String res) {
    Shader shader = gl.createShader(type);
    gl.shaderSource(shader, readURL(res));
    gl.compileShader(shader);
    checkLog(gl, shader);
    gl.attachShader(program, shader);
    return shader;
  }

  bool checkLog(RenderingContext gl, Shader shader) {
    String log = gl.getShaderInfoLog(shader);
    if (log == null || log.length == 0) return true;
    print(log);
    return false;
  }

  String readURL(String url) {
    HttpRequest request = new HttpRequest();
    request.open("GET", url, async:false);
    request.send();
    return request.responseText;
  }

  void gameLoop(num time) {
    if (time>0) {
      num delta = timer.calculateDeltaFromLastTime(time);
      timer.recordDelta(delta);
      fpsTimer += delta;
      if (fpsTimer > 200) {
        fpsTimer = 0;
        timer.updateFpsElement();
      }

      world.update(delta);

      gl.clear(DEPTH_BUFFER_BIT | COLOR_BUFFER_BIT);
      world.render(gl);
    }
    window.animationFrame.then(gameLoop);
  }

}

void main() {
  new Game();
}