import 'package:flame/particle.dart';
import 'package:flame/particles/accelerated_particle.dart';
import 'package:flame/particles/circle_particle.dart';
import 'package:flutter/painting.dart';
import 'package:monument_platformer/common.dart';

class GameParticle {
  GameParticle() {
    var a = Particle.generate(
      count: 10,
      generator: (i) {
        return AcceleratedParticle(
          acceleration: OffsetUtil.random(),
          child: CircleParticle(
            paint: Paint()
              ..color = Color(0xff3a3a3e)
              ..strokeWidth = 1
              ..style = PaintingStyle.fill,
            lifespan: 15,
          ),
        );
      },
    );
  }
}