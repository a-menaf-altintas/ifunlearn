// FILE: lib/tutor_interactive_screen.dart

import 'package:flutter/material.dart';

class TutorInteractiveScreen extends StatefulWidget {
  final Map<String, dynamic> profile;

  const TutorInteractiveScreen({Key? key, required this.profile})
      : super(key: key);

  @override
  _TutorInteractiveScreenState createState() => _TutorInteractiveScreenState();
}

class _TutorInteractiveScreenState extends State<TutorInteractiveScreen> {
  // Initial tutor message; in a real scenario, set by a decision engine.
  String tutorMessage =
      "Hello, let's start your session! Draw something or say something to begin.";

  // Variables to hold user inputs
  String userVoiceInput = "";
  List<Offset?> drawingPoints = [];

  // A placeholder "decision engine" that updates the tutor message based on interaction.
  void _processUserInteraction() {
    setState(() {
      tutorMessage =
          "Great job! Based on your input, let's move to the next activity.";
      // Clear the inputs (if needed) after processing.
      userVoiceInput = "";
      drawingPoints = [];
    });
  }

  // Called as the user draws on the canvas
  void _addDrawingPoint(Offset point) {
    setState(() {
      drawingPoints.add(point);
    });
  }

  // Called when the drawing gesture ends
  void _endDrawing() {
    // Process the drawing input
    _processUserInteraction();
  }

  // Simulated voice input handler; in a real app, integrate a speech-to-text package
  void _simulateVoiceInput(String input) {
    setState(() {
      userVoiceInput = input;
    });
    _processUserInteraction();
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
            // Drawing canvas for free-hand input
            Expanded(
              child: GestureDetector(
                onPanUpdate: (details) {
                  RenderBox? box = context.findRenderObject() as RenderBox?;
                  if (box != null) {
                    Offset localPosition =
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
            // Voice input area (simulated via TextField)
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

    // Draw continuous lines between consecutive points
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
