import 'package:flutter/material.dart';

class TutorInteractiveScreen extends StatefulWidget {
  final Map<String, dynamic> profile;

  const TutorInteractiveScreen({Key? key, required this.profile})
      : super(key: key);

  @override
  _TutorInteractiveScreenState createState() => _TutorInteractiveScreenState();
}

class _TutorInteractiveScreenState extends State<TutorInteractiveScreen> {
  String tutorMessage =
      "Hello, let's start your session! Draw something or say something to begin.";

  String userVoiceInput = "";
  List<Offset?> drawingPoints = [];

  void _addDrawingPoint(Offset point) {
    setState(() {
      drawingPoints.add(point);
    });
  }

  void _endDrawing() {
    _processUserInteraction();
  }

  void _simulateVoiceInput(String input) {
    setState(() {
      userVoiceInput = input;
    });
    _processUserInteraction();
  }

  void _processUserInteraction() {
    setState(() {
      tutorMessage =
          "Great job! Based on your input, let's move to the next activity.";
      userVoiceInput = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor Session for ${widget.profile['name']}'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue.shade100,
            child: Text(
              tutorMessage,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 10),

          // Corrected Drawing Area
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                RenderBox box = context.findRenderObject() as RenderBox;
                final localPosition = box.globalToLocal(details.globalPosition);
                _addDrawingPoint(localPosition);
              },
              onPanEnd: (_) => _endDrawing(),
              child: Container(
                color: Colors.white,
                child: CustomPaint(
                  painter: DrawingPainter(drawingPoints),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Clear Button
          ElevatedButton(
            onPressed: () {
              setState(() {
                drawingPoints.clear();
              });
            },
            child: const Text('Clear Canvas'),
          ),
          const SizedBox(height: 10),

          // Voice Input
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
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => oldDelegate.points != points;
}
