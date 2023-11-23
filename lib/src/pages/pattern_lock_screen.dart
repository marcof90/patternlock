import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

// Importamos el tema para acceder a los colores personalizados
import 'package:flutter_application/src/theme/theme.dart';

class PasswordPattern extends StatefulWidget {
  final Function(String) onFinish;

  const PasswordPattern({Key? key, required this.onFinish}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PasswordPatternState createState() => _PasswordPatternState();
}

class _PasswordPatternState extends State<PasswordPattern> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.transparent,
      ),
      margin: const EdgeInsets.only(top: 40.0),
      child: Grid(
        onFinish: widget.onFinish,
      ),
    );
  }
}

class Grid extends StatefulWidget {
  final Function onFinish;
  const Grid({Key? key, required this.onFinish}) : super(key: key);
  @override
  GridState createState() {
    return GridState();
  }
}

class GridState extends State<Grid> {
  final Set<int> selectedIndexes = <int>{};
  final List<Offset> points = [];
  final key = GlobalKey();
  final Set<_Foo> _trackTaped = <_Foo>{};

  // Método para detectar el toque inicial
  _detectTapedDownItem(PointerEvent event) {
    final size = MediaQuery.of(context).size;
    double sizeMin = size.width * 0.6;
    if (size.height < size.width) {
      sizeMin = size.height * 0.4;
    }
    final desface = sizeMin * 0.1;
    final RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        final target = hit.target;
        if (target is _Foo && !_trackTaped.contains(target)) {
          _trackTaped.add(target);
          _selectIndex(target.index);
          Offset position = Offset((hit.transform!.row0[3] * -1) + desface,
              (hit.transform!.row1[3] * -1) + desface);
          _selectPoints(position);
        }
      }
    }
    _selectPoints(local);
  }

  // Método para detectar el movimiento del toque
  _detectTapedItem(PointerEvent event) {
    final size = MediaQuery.of(context).size;
    double sizeMin = size.width * 0.6;
    if (size.height < size.width) {
      sizeMin = size.height * 0.4;
    }
    final desface = sizeMin * 0.1;
    final RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        final target = hit.target;
        if (target is _Foo && !_trackTaped.contains(target)) {
          _trackTaped.add(target);
          _selectIndex(target.index);
          points.removeLast();
          Offset position = Offset((hit.transform!.row0[3] * -1) + desface,
              (hit.transform!.row1[3] * -1) + desface);
          _selectPoints(position);
          _selectPoints(local);
        }
      }
    }
    points[points.length - 1] = local;
    setState(() {});
  }

  // Método para seleccionar un índice
  _selectIndex(int index) {
    setState(() {
      selectedIndexes.add(index);
    });
  }

  // Método para seleccionar un punto
  _selectPoints(Offset position) {
    setState(() {
      points.add(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double sizeMin = size.width * 0.6;
    if (size.height < size.width) {
      sizeMin = size.height * 0.45;
    }
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: sizeMin, maxWidth: sizeMin),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: sizeMin * 0.04, left: sizeMin * 0.04),
            child: CustomPaint(
              painter: MyPainter(points: points),
            ),
          ),
          Listener(
            onPointerDown: _detectTapedDownItem,
            onPointerMove: _detectTapedItem,
            onPointerUp: _clearSelection,
            child: GridView.builder(
              padding: const EdgeInsets.all(0.0),
              key: key,
              itemCount: 9,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: sizeMin * 0.15,
                mainAxisSpacing: sizeMin * 0.15,
              ),
              itemBuilder: (context, index) {
                return Foo(
                  index: index,
                  child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: darkPrimaryColor, width: 0.5),
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.transparent),
                      child: Padding(
                        padding: EdgeInsets.all(sizeMin * 0.06),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: darkPrimaryColor)),
                      )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Método para limpiar la selección cuando se levanta el dedo
  void _clearSelection(PointerUpEvent event) {
    String password = "";
    for (int item in selectedIndexes) {
      password += "$item";
    }
    widget.onFinish(password);
    _trackTaped.clear();
    setState(() {
      selectedIndexes.clear();
      points.clear();
    });
  }
}

// Clase para dibujar el trazo del patrón
class MyPainter extends CustomPainter {
  List<Offset> points;
  MyPainter({required this.points});
  @override
  void paint(Canvas canvas, Size size) {
    const pointMode = ui.PointMode.polygon;
    final paint = Paint()
      ..color = darkPrimaryColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// Widget para representar cada ítem en el patrón
class Foo extends SingleChildRenderObjectWidget {
  final int index;

  const Foo({required Widget child, required this.index, Key? key})
      : super(child: child, key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Foo createRenderObject(BuildContext context) {
    return _Foo()..index = index;
  }

  @override
  // ignore: library_private_types_in_public_api
  void updateRenderObject(BuildContext context, _Foo renderObject) {
    renderObject.index = index;
  }
}

// RenderObject para representar cada ítem en el patrón
class _Foo extends RenderProxyBox {
  late int index;
}
