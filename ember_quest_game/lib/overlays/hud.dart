import 'package:ember_quest_game/ember_quest.dart';
import 'package:ember_quest_game/overlays/heart.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Hud extends PositionComponent with HasGameReference<EmberQuestGame> {
  Hud({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  });

  late TextComponent _scoreTextComponent;
  double yPosition = 70;
  double heartYPosition = 55;

  @override
  Future<void> onLoad() async {
    _scoreTextComponent = TextComponent(
      text: '${game.starsCollected}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(10, 10, 10, 1),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x - 100, yPosition),
    );
    add(_scoreTextComponent);

    final starSprite = await game.loadSprite('star.png');
    add(
      SpriteComponent(
        sprite: starSprite,
        position: Vector2(game.size.x - 60, yPosition-2),
        size: Vector2.all(32),
        anchor: Anchor.center,
      ),
    );

    for (var i = 1; i <= game.health; i++) {
      final positionX = 40 * i;
      await add(
        HeartHealthComponent(
          heartNumber: i,
          position: Vector2(positionX.toDouble(), heartYPosition),
          size: Vector2.all(32),
        ),
      );
    }
  }

  @override
  void update(double dt) {
    _scoreTextComponent.text = '${game.starsCollected}';
  }
}
