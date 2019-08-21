import 'package:flutter/material.dart';

class CurlyLine extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CurlyLinePainter(dimension: MediaQuery.of(context).size));
  }
}

class CurlyLinePainter extends CustomPainter{
  final Paint painter = Paint();
  final Path path = Path();

  final Size dimension;
  
  CurlyLinePainter({this.dimension});

  @override
  void paint(Canvas canvas, Size size) {   
    painter.color = Colors.black54;
    painter.strokeWidth = 2;
    painter.style = PaintingStyle.stroke;

    path.moveTo(-dimension.width/16, dimension.height/60);
    path.quadraticBezierTo(-dimension.width/3.5, dimension.height/3.5, dimension.width/2.5, dimension.height/2.4);
    path.lineTo(dimension.width/2.5-10, dimension.height/2.4+5);
    path.moveTo(dimension.width/2.5-8, dimension.height/2.4-10);
    path.lineTo(dimension.width/2.5, dimension.height/2.4);

    // path.moveTo(-50, 20);
    // path.quadraticBezierTo(-150, 400, 300, 510);
    // path.lineTo(290, 515);
    // path.moveTo(292, 500);
    // path.lineTo(300, 510);
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}