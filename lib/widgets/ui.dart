import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GothicCard extends StatelessWidget {
  const GothicCard({super.key, required this.child, this.padding = const EdgeInsets.all(18), this.background = Palette.panel, this.onTap});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color background;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Palette.border),
      boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 17, offset: Offset(0, 7))],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(padding: padding, child: child),
      ),
    ),
  );
}

class GothicHeading extends StatelessWidget {
  const GothicHeading({super.key, required this.kicker, required this.title, required this.subtitle});
  final String kicker;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('✦  ${kicker.toUpperCase()}  ✦', style: const TextStyle(color: Palette.gold, fontSize: 10, letterSpacing: 2.0, fontWeight: FontWeight.w700, fontFamily: 'Roboto')),
    const SizedBox(height: 11),
    Text(title, style: Theme.of(context).textTheme.headlineMedium),
    const SizedBox(height: 10),
    Text(subtitle, style: const TextStyle(color: Palette.muted, fontSize: 13, height: 1.55, fontFamily: 'Roboto')),
  ]);
}

class GothicSection extends StatelessWidget {
  const GothicSection(this.title, {super.key});
  final String title;
  @override
  Widget build(BuildContext context) => Row(children: [
    const Icon(Icons.auto_awesome, color: Palette.gold, size: 15),
    const SizedBox(width: 9),
    Expanded(child: Text(title, style: const TextStyle(fontSize: 19, color: Palette.parchment, fontWeight: FontWeight.w700))),
    const SizedBox(width: 10),
    Container(width: 26, height: 1, color: Palette.gold),
  ]);
}

class GothicSymbol extends StatelessWidget {
  const GothicSymbol(this.icon, {super.key, this.size = 48, this.color = Palette.gold});
  final IconData icon;
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    height: size, width: size,
    decoration: BoxDecoration(color: Palette.raised, borderRadius: BorderRadius.circular(13), border: Border.all(color: Palette.border)),
    child: Icon(icon, color: color, size: size * .48),
  );
}

class CoffinIcon extends StatelessWidget {
  const CoffinIcon({super.key, this.closed = false, this.size = 44});
  final bool closed;
  final double size;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size, height: size * 1.35,
    child: CustomPaint(painter: _CoffinPainter(closed: closed)),
  );
}

class _CoffinPainter extends CustomPainter {
  _CoffinPainter({required this.closed});
  final bool closed;
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final shape = Path()
      ..moveTo(w * .50, 0)
      ..lineTo(w * .94, h * .18)
      ..lineTo(w * .84, h * .69)
      ..lineTo(w * .50, h)
      ..lineTo(w * .16, h * .69)
      ..lineTo(w * .06, h * .18)
      ..close();
    canvas.drawPath(shape, Paint()..color = closed ? Palette.wine : Palette.raised);
    canvas.drawPath(shape, Paint()..style = PaintingStyle.stroke..strokeWidth = 2..color = Palette.gold);
    final inner = Path()
      ..moveTo(w * .50, h * .08)
      ..lineTo(w * .84, h * .22)
      ..lineTo(w * .75, h * .65)
      ..lineTo(w * .50, h * .88)
      ..lineTo(w * .25, h * .65)
      ..lineTo(w * .16, h * .22)
      ..close();
    canvas.drawPath(inner, Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = Palette.gold.withValues(alpha: .45));
    final cross = Paint()..color = Palette.parchment..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w*.50, h*.32), Offset(w*.50, h*.65), cross);
    canvas.drawLine(Offset(w*.37, h*.44), Offset(w*.63, h*.44), cross);
  }
  @override
  bool shouldRepaint(covariant _CoffinPainter oldDelegate) => oldDelegate.closed != closed;
}

class CastleIllustration extends StatelessWidget {
  const CastleIllustration({super.key});
  @override
  Widget build(BuildContext context) => SizedBox(height: 183, width: double.infinity, child: CustomPaint(painter: _CastlePainter()));
}

class _CastlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width, h = s.height;
    canvas.drawCircle(Offset(w*.75, h*.28), h*.22, Paint()..color = const Color(0xFFEAD9CF));
    canvas.drawCircle(Offset(w*.78, h*.25), h*.21, Paint()..color = const Color(0xFFF8E9DC).withValues(alpha: .24));
    final mountains = Path()..moveTo(0,h*.85)..lineTo(w*.16,h*.72)..lineTo(w*.31,h*.80)..lineTo(w*.56,h*.63)..lineTo(w,h*.88)..lineTo(w,h)..lineTo(0,h)..close();
    canvas.drawPath(mountains, Paint()..color = const Color(0xFF2B2638));
    final dark = Paint()..color = const Color(0xFF14121F);
    final towers = <Rect>[Rect.fromLTWH(w*.16,h*.34,w*.13,h*.62),Rect.fromLTWH(w*.67,h*.28,w*.14,h*.68),Rect.fromLTWH(w*.36,h*.40,w*.34,h*.58)];
    for (final r in towers) { canvas.drawRect(r,dark); canvas.drawPath(Path()..moveTo(r.left-7,r.top)..lineTo(r.center.dx,r.top-h*.20)..lineTo(r.right+7,r.top)..close(),dark); }
    final gate = Path()..moveTo(w*.47,h)..lineTo(w*.47,h*.76)..quadraticBezierTo(w*.53,h*.64,w*.59,h*.76)..lineTo(w*.59,h)..close();
    canvas.drawPath(gate, Paint()..color = const Color(0xFF70273F));
    for (final x in [w*.205,w*.74,w*.42,w*.62]) {
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x,h*.58,5,17), const Radius.circular(4)), Paint()..color = Palette.gold);
    }
    final ground = Path()..moveTo(0,h*.91)..quadraticBezierTo(w*.50,h*.86,w,h*.94)..lineTo(w,h)..lineTo(0,h)..close();
    canvas.drawPath(ground,dark);
    final bat = Paint()..color = Palette.background..strokeWidth = 2..style = PaintingStyle.stroke;
    for (final x in [w*.19,w*.31,w*.46]) {
      final y = h*.19 + (x%18);
      canvas.drawPath(Path()..moveTo(x-9,y)..quadraticBezierTo(x-5,y-7,x,y)..quadraticBezierTo(x+5,y-7,x+9,y),bat);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
