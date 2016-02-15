part of molegame;

class Keyboard {

  HashSet<int> _keys = new HashSet();
  List<Function> pressListeners = new List();

  Keyboard() {
    window.onKeyDown.listen((Event e) {
      KeyboardEvent keyEvent = e as KeyboardEvent;
      int keyCode = keyEvent.keyCode;
      _keys.add(keyCode);
      for (int i = 0; i < pressListeners.length; i++) {
        pressListeners[i](keyEvent);
      }
    });
    window.onKeyUp.listen((Event e) {
      KeyboardEvent keyEvent = e as KeyboardEvent;
      int keyCode = keyEvent.keyCode;
      _keys.remove(keyCode);
    });
    window.onBlur.listen((Event e) {
      _keys.clear();
    });
  }

  bool isKeyPressed(int keyCode) {
    return _keys.contains(keyCode);
  }

  void addPressListener(void onPress(KeyboardEvent e)) {
    pressListeners.add(onPress);
  }

}