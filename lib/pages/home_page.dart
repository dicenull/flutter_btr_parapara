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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _KessokuBand(hitoriColor, size),
        _KessokuBand(nijikaColor, size),
        _KessokuBand(ryoColor, size),
        _KessokuBand(ikuyoColor, size),
      ],
    );
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
