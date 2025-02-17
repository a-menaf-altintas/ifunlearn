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
  late GlobalKey _canvasKey;

  @override
  void initState() {
    super.initState();
    _canvasKey = GlobalKey();
  }

  void _addDrawingPoint(Offset point) {
    final RenderBox box = _canvasKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = box.size;

    // Ensure drawing remains within bounds
    if (point.dx >= 0 && point.dx <= size.width && point.dy >= 0 && point.dy <= size.height) {
      setState(() {
        drawingPoints.add(point);
      });
    }
  }

  void _endDrawing() {
    setState(() {
      drawingPoints.add(null); // Add null to separate strokes
    });
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
      tutorMessage = "Great job! Based on your input, let's move to the next activity.";
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

          // **Fixed Interactive Drawing Area**
          Expanded(
            child: Center(
              child: Container(
                key: _canvasKey,
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  color: Colors.white,
                ),
                child: GestureDetector(
                  onPanStart: (details) {
                    RenderBox box = _canvasKey.currentContext!.findRenderObject() as RenderBox;
                    final localPosition = box.globalToLocal(details.globalPosition);
                    _addDrawingPoint(localPosition);
                  },
                  onPanUpdate: (details) {
                    RenderBox box = _canvasKey.currentContext!.findRenderObject() as RenderBox;
                    final localPosition = box.globalToLocal(details.globalPosition);
                    _addDrawingPoint(localPosition);
                  },
                  onPanEnd: (_) => _endDrawing(),
                  child: CustomPaint(
                    painter: DrawingPainter(drawingPoints),
                    child: Container(),
                  ),
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
