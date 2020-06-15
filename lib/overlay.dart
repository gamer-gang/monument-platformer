import 'package:flutter/material.dart';
// import 'package:flame/flame.dart';

import 'common.dart';
// import 'data/savedata.dart';
import 'data/store.dart';
import 'game.dart';

final Color _btnColor = darkBlue;
    // _btnColorPressed = Color.fromARGB(255, 85, 109, 135);
final double _btnSize = 64, _iconSize = 40, _btnMargin = 20, _btnSpacing = 32;

class GamePage extends StatefulWidget {
  final SaveFile file;

  GamePage({this.file});

  @override
  _GamePageState createState() => _GamePageState(file);
}

class _GamePageState extends State<GamePage> {
  final SaveFile file;

  _GamePageState(this.file);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: setupGame(file),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GameManager(game: snapshot.data);
            } else {
              return loadingScreen();
            }
          }),
    );
  }
}

class GameManager extends StatefulWidget {
  final MonumentPlatformer game;

  const GameManager({Key key, @required this.game}) : super(key: key);

  @override
  _GameManagerState createState() => _GameManagerState(game);
}

bool reloadPressed = false;

class ColorManager {
  Color left;
  Color right;
  Color dash;
  Color jump;
  ColorManager({this.left, this.right, this.dash, this.jump});
}

class _GameManagerState extends State<GameManager> {
  ColorManager colors = ColorManager(
    left: _btnColor,
    right: _btnColor,
    jump: _btnColor,
    dash: _btnColor,
  );

  MonumentPlatformer game;

  _GameManagerState(this.game);

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(child: game.widget),
      Positioned(
        top: 0,
        left: 0,
        child: Row(children: [
          overlayButton(
            game: game,
            color: Colors.transparent,
            iconColor: Colors.black,            
            key: GamepadButton.restart,
            icon: Icons.refresh,
          ),
        ]),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: Row(children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.pause,
              color: Colors.black,
            ),
          ),
        ]),
      ),
      Positioned(
        bottom: _btnMargin,
        left: _btnMargin,
        child: Container(
          width: _btnSize * 2 + _btnSpacing,
          child: Row(children: [
            overlayButton(
              game: game,
              color: colors.left,
              key: GamepadButton.left,
              icon: Icons.arrow_left,
              update: (newColor) => setState(() => colors.left = newColor),
            ),
            Spacer(),
            overlayButton(
              game: game,
              color: colors.right,
              key: GamepadButton.right,
              icon: Icons.arrow_right,
              update: (newColor) => setState(() => colors.right = newColor),
            ),
          ]),
        ),
      ),
      Positioned(
        bottom: _btnMargin,
        right: _btnMargin,
        child: Container(
          width: _btnSize * 2 + _btnSpacing,
          child: Row(children: [
            overlayButton(
              game: game,
              color: colors.dash,
              key: GamepadButton.dash,
              icon: Icons.fast_forward,
              update: (newColor) => setState(() => colors.dash = newColor),
            ),
            Spacer(),
            overlayButton(
              game: game,
              color: colors.jump,
              key: GamepadButton.jump,
              icon: Icons.arrow_drop_up,
              update: (newColor) => setState(() => colors.jump = newColor),
            ),
          ]),
        ),
      ),
    ]);
  }
}

Widget overlayButton({
  MonumentPlatformer game,
  Color color,
  Color iconColor = Colors.white,
  Function(Color) update,
  GamepadButton key,
  IconData icon,
}) {
  // var releaseColor = Color(color != null ? color.value : _btnColor.value);
  // var pressColor =
  // Color(pressedColor != null ? pressedColor.value : _btnColorPressed.value);
  return Listener(
    onPointerDown: (pointerDownEvent) {
      // update(pressColor);
      game.press(key, pointerDownEvent);
    },
    onPointerUp: (pointerUpEvent) {
      // update(releaseColor);
      game.release(key, pointerUpEvent);
    },
    child: AnimatedContainer(
      curve: Curves.easeOut,
      duration: Duration(milliseconds: 75),
      width: _btnSize,
      height: _btnSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          color: iconColor,
          size: _iconSize,
        ),
      ),
    ),
  );
}
