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
  final bocchiPattern = [-1, -1.1, -1.2, -2, -4, -6, 2];

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

    final positions = [
      Offset(size / bocchiPos, 0),
      Offset(size / innerPos, 0),
      Offset(-size / innerPos, 0),
      Offset(-size / outerPos, 0),
    ];
    final bandMembers = [
      _KessokuBand(hitoriColor, size),
      _KessokuBand(nijikaColor, size),
      _KessokuBand(ryoColor, size),
      _KessokuBand(ikuyoColor, size),
    ];

    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: bandMembers
              .asMap()
              .entries
              .map((e) => Transform.translate(
                    offset: positions[e.key],
                    child: e.value,
                  ))
              .toList(),
        ),
        // 手前に来る部分を上書きで描画することで交差しているように見せる
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: bandMembers
              .asMap()
              .entries
              .map((e) => Transform.translate(
                    offset: positions[e.key],
                    child: ClipRect(
                      clipper: _BottomRightClipper(),
                      child: e.value,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _BottomRightClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(
      size.width / 2,
      size.height / 2,
      size.width,
      size.height,
    );
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
