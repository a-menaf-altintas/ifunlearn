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
    // If you want the drawing to remain, do not clear drawingPoints here.
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
      // If you *don't* want to clear the canvas automatically, leave this out:
      // drawingPoints.clear();
      userVoiceInput = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor Session for ${widget.profile['name']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Tutor's message area
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

            // Drawing area
            Expanded(
              child: GestureDetector(
                onPanUpdate: (details) {
                  RenderBox? box = context.findRenderObject() as RenderBox?;
                  if (box != null) {
                    final localPosition =
                        box.globalToLocal(details.globalPosition);
                    _addDrawingPoint(localPosition);
                  }
                },
                onPanEnd: (details) {
                  _endDrawing();
                },
                child: CustomPaint(
                  painter: DrawingPainter(drawingPoints: drawingPoints),
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // <-- ADD YOUR CLEAR BUTTON HERE
            ElevatedButton(
              onPressed: () {
                setState(() {
                  drawingPoints.clear();
                });
              },
              child: const Text('Clear Canvas'),
            ),
            const SizedBox(height: 10),

            // Voice input text field
            TextField(
              onSubmitted: _simulateVoiceInput,
              decoration: const InputDecoration(
                labelText: 'Talk to your tutor (simulate speech input)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> drawingPoints;

  DrawingPainter({required this.drawingPoints});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        canvas.drawLine(drawingPoints[i]!, drawingPoints[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) =>
      oldDelegate.drawingPoints != drawingPoints;
}
