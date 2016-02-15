part of molegame;

class GameTimer {

  num lastTime = -1;
  List<num> deltas = new List();

  num calculateDeltaFromLastTime(num time) {
    num delta = calculateDelta(time, lastTime);
    lastTime = time;
    return delta;
  }

  num calculateDelta(num time, num lastTime) {
    if (time > 0) {
      return time - lastTime;
    }
    return -1;
  }

  num getAverageDelta() {
    num totalDelta = 0;
    for (num i = 0; i < deltas.length;i++) {
      totalDelta += deltas[i];
    }
    totalDelta /= deltas.length;
    return totalDelta;
  }

  void recordDelta(num delta) {
    deltas.add(delta);
    if (deltas.length > 10) deltas.removeAt(0);
  }

  void updateFpsElement() {
    document.getElementById("fps").innerHtml = (1000 / getAverageDelta()).ceil().toString();
  }

}