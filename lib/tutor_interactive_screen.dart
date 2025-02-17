import 'package:flutter/material.dart';

class TutorInteractiveScreen extends StatefulWidget {
  final Map<String, dynamic> profile;

  const TutorInteractiveScreen({Key? key, required this.profile}) : super(key: key);

  @override
  _TutorInteractiveScreenState createState() => _TutorInteractiveScreenState();
}

class _TutorInteractiveScreenState extends State<TutorInteractiveScreen> {
  String tutorMessage = "Hello, let's start your session! Draw something or say something to begin.";
  String userVoiceInput = "";
  List<Stroke> strokes = [];
  Color selectedColor = Colors.black;
  double penThickness = 3.0;

  void _addDrawingPoint(Offset point) {
    if (strokes.isEmpty || strokes.last.isComplete) {
      strokes.add(Stroke(selectedColor, penThickness)); // Start new stroke
    }
    setState(() {
      strokes.last.points.add(point);
    });
  }

  void _endDrawing() {
    setState(() {
      if (strokes.isNotEmpty) {
        strokes.last.isComplete = true;
      }
    });
  }

  void _undoLastStroke() {
    if (strokes.isNotEmpty) {
      setState(() {
        strokes.removeLast();
      });
    }
  }

  void _clearCanvas() {
    setState(() {
      strokes.clear();
    });
  }

  void _changePenThickness(double thickness) {
    setState(() {
      penThickness = thickness;
    });
  }

  void _changePenColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tutor Session for ${widget.profile['name']}')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue.shade100,
            child: Text(tutorMessage, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 10),

          // **Drawing Canvas**
          Expanded(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  color: Colors.white,
                ),
                child: GestureDetector(
                  onPanStart: (details) => _addDrawingPoint(details.localPosition),
                  onPanUpdate: (details) => _addDrawingPoint(details.localPosition),
                  onPanEnd: (_) => _endDrawing(),
                  child: CustomPaint(
                    painter: DrawingPainter(strokes),
                    child: Container(),
                  ),
                ),
              ),
            ),
          ),

          // **Control Buttons**
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.undo), onPressed: _undoLastStroke),
              IconButton(icon: const Icon(Icons.clear), onPressed: _clearCanvas),
              _buildColorPicker(),
              _buildThicknessSelector(),
            ],
          ),

          const SizedBox(height: 10),

          // **Voice Input**
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (input) {
                setState(() {
                  userVoiceInput = input;
                  tutorMessage = "Great job! Based on your input, let's move to the next activity.";
                });
              },
              decoration: const InputDecoration(
                labelText: 'Talk to your tutor (simulate speech input)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    return DropdownButton<Color>(
      value: selectedColor,
      items: [Colors.black, Colors.red, Colors.blue, Colors.green]
          .map((color) => DropdownMenuItem(
                value: color,
                child: Container(width: 20, height: 20, color: color),
              ))
          .toList(),
      onChanged: (color) {
        if (color != null) _changePenColor(color);
      },
    );
  }

  Widget _buildThicknessSelector() {
    return DropdownButton<double>(
      value: [2.0, 4.0, 6.0, 8.0].contains(penThickness) ? penThickness : 2.0, 
      items: [2.0, 4.0, 6.0, 8.0]
          .map((thickness) => DropdownMenuItem(
                value: thickness,
                child: Text('${thickness.toInt()}px'),
              ))
          .toList(),
      onChanged: (thickness) {
        if (thickness != null) _changePenThickness(thickness);
      },
    );
  }
}

// **Stroke Class (Moved Outside the State Class)**
class Stroke {
  final Color color;
  final double thickness;
  final List<Offset> points = [];
  bool isComplete = false;

  Stroke(this.color, this.thickness);
}

// **Custom Painter (Moved Outside the State Class)**
class DrawingPainter extends CustomPainter {
  final List<Stroke> strokes;

  DrawingPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.thickness
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < stroke.points.length - 1; i++) {
        canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
