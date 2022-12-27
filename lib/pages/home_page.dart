import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
  final pattern = [-1, -2, -4, -6, -10, 10000, 2];
  final bocchiPattern = [-1, -1, -1, -2, -4, -6, 2];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size.width / 10;
    final count = useState(0);
    final outerPos = pattern[count.value];
    final innerPos = outerPos * 3;
    final bocchiPos = bocchiPattern[count.value];

    useEffect(() {
      final timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
        count.value = (count.value + 1) % pattern.length;
      });

      return timer.cancel;
    }, const []);

    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(size / bocchiPos, 0),
              child: _KessokuBand(hitoriColor, size),
            ),
            Transform.translate(
              offset: Offset(size / innerPos, 0),
              child: _KessokuBand(nijikaColor, size),
            ),
            Transform.translate(
              offset: Offset(-size / innerPos, 0),
              child: _KessokuBand(ryoColor, size),
            ),
            Transform.translate(
              offset: Offset(-size / outerPos, 0),
              child: _KessokuBand(ikuyoColor, size),
            ),
          ],
        ),
        // 下半分を逆順に描画することで重なりを表現
        // 場所は決め打ち
        if (count.value == pattern.length - 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(-size * (5 / outerPos), 0),
                child: ClipRect(
                  clipper: _BottomHalfClipper(),
                  child: _KessokuBand(hitoriColor, size),
                ),
              ),
              Transform.translate(
                offset: Offset(-size * (5 / innerPos), 0),
                child: ClipRect(
                  clipper: _BottomHalfClipper(),
                  child: _KessokuBand(nijikaColor, size),
                ),
              ),
              Transform.translate(
                offset: Offset(size * (5 / innerPos), 0),
                child: ClipRect(
                  clipper: _BottomHalfClipper(),
                  child: _KessokuBand(ryoColor, size),
                ),
              ),
              Transform.translate(
                offset: Offset(size * (5 / outerPos), 0),
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
