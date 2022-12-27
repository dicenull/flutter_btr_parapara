import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// ref: https://bocchi.rocks/
const hitoriColor = Color(0xffff2291);
const ikuyoColor = Color(0xffff4637);
const nijikaColor = Color(0xffffb400);
const ryoColor = Color(0xff02d1e0);

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: _Body(),
      ),
    );
  }
}

class _Body extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size.width / 10;

    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(size / 2, 0),
              child: _KessokuBand(hitoriColor, size),
            ),
            Transform.translate(
              offset: Offset(size / 6, 0),
              child: _KessokuBand(nijikaColor, size),
            ),
            Transform.translate(
              offset: Offset(-size / 6, 0),
              child: _KessokuBand(ryoColor, size),
            ),
            Transform.translate(
              offset: Offset(-size / 2, 0),
              child: _KessokuBand(ikuyoColor, size),
            ),
          ],
        ),
        // 下半分を逆順に描画することで重なりを表現
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(-size * (5 / 2.0), 0),
              child: ClipRect(
                clipper: _BottomHalfClipper(),
                child: _KessokuBand(hitoriColor, size),
              ),
            ),
            Transform.translate(
              offset: Offset(-size * (5 / 6.0), 0),
              child: ClipRect(
                clipper: _BottomHalfClipper(),
                child: _KessokuBand(nijikaColor, size),
              ),
            ),
            Transform.translate(
              offset: Offset(size * (5 / 6.0), 0),
              child: ClipRect(
                clipper: _BottomHalfClipper(),
                child: _KessokuBand(ryoColor, size),
              ),
            ),
            Transform.translate(
              offset: Offset(size * (5 / 2.0), 0),
              child: ClipRect(
                clipper: _BottomHalfClipper(),
                child: _KessokuBand(ikuyoColor, size),
              ),
            ),
          ].reversed.toList(),
        ),
      ],
    );
  }
}

class _BottomHalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, size.height / 2, size.width, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}

class _KessokuBand extends StatelessWidget {
  final Color color;
  final double size;
  const _KessokuBand(this.color, this.size);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: size / 8),
      ),
    );
  }
}
