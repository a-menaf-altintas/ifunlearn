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
    _processDrawing();
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
    _updateTutorMessage("Canvas cleared. Try drawing a shape!");
  }

  void _simulateVoiceInput(String input) {
    setState(() {
      userVoiceInput = input;
    });
    _processVoiceInput(input);
  }

  // **Tutor Logic: Process Voice Input**
  void _processVoiceInput(String input) {
    if (input.toLowerCase().contains("circle")) {
      _updateTutorMessage("Great! A circle is round. Want to draw one?");
    } else if (input.toLowerCase().contains("square")) {
      _updateTutorMessage("Squares have four equal sides. Try drawing one!");
    } else {
      _updateTutorMessage("I heard: \"$input\". Let's explore that in our lesson!");
    }
  }

  // **Tutor Logic: Process Drawing**
  void _processDrawing() {
    String detectedShape = _recognizeShape(); // Placeholder function

    if (detectedShape == "circle") {
      _updateTutorMessage("Nice attempt! Try making the circle smoother.");
    } else if (detectedShape == "square") {
      _updateTutorMessage("That looks like a square! Well done.");
    } else if (detectedShape == "unknown") {
      _updateTutorMessage("Hmm, I can't recognize that shape. Try again!");
    } else {
      _updateTutorMessage("Interesting! Want to try another drawing?");
    }
  }

  // **Basic Shape Recognition Placeholder**
  String _recognizeShape() {
    if (strokes.isEmpty) return "unknown";

    // Placeholder logic: real detection will use ML/OpenCV later
    int pointCount = strokes.fold(0, (sum, stroke) => sum + stroke.points.length);
    
    if (pointCount > 50) return "circle"; // Example: More points -> Assume a circle
    if (pointCount > 20) return "square"; // Example: Fewer points -> Assume a square
    
    return "unknown";
  }

  // **Update Tutor Message**
  void _updateTutorMessage(String message) {
    setState(() {
      tutorMessage = message;
    });
  }

  // **Fix: Correctly Define These Methods**
  void changePenColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  void changePenThickness(double thickness) {
    setState(() {
      penThickness = thickness;
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
              onSubmitted: _simulateVoiceInput,
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
        if (color != null) changePenColor(color);
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
        if (thickness != null) changePenThickness(thickness);
      },
    );
  }
}

// **Stroke Class**
class Stroke {
  final Color color;
  final double thickness;
  final List<Offset> points = [];
  bool isComplete = false;

  Stroke(this.color, this.thickness);
}

// **Custom Painter**
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
