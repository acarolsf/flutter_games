import 'package:flutter/material.dart';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'package:ember_quest_game/managers/segment_manager.dart';

import 'package:ember_quest_game/overlays/hud.dart';

import 'package:ember_quest_game/objects/ground_block.dart';
import 'package:ember_quest_game/objects/platform_block.dart';
import 'package:ember_quest_game/objects/star.dart';

import 'package:ember_quest_game/actors/water_enemy.dart';
import 'package:ember_quest_game/actors/player.dart';

class EmberQuestGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  EmberQuestGame();
  late EmberPlayer _player;

  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;

  double cloudSpeed = 0.0;
  double objectSpeed = 0.0;
  int starsCollected = 0;
  int health = 3;

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);  
  }

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'block.png',
      'ember.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
    ]);

    // The position of the `CameraComponet`s viewfinder is in the top left corner
    camera.viewfinder.anchor = Anchor.topLeft;
    initializeGame(loadHud: true);
  }

  @override
  void update(double dt) {
    if (health <= 0) {
      overlays.add('GameOver');
    }
    super.update(dt);
  }

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    for (final block in segments[segmentIndex]) {
      final component = switch (block.blockType) {
      
      const (GroundBlock) => GroundBlock(gridPosition: block.gridPosition, xOffset: xPositionOffset),

      const (PlatformBlock) => PlatformBlock(gridPosition: block.gridPosition, xOffset: xPositionOffset),
      
      const (Star) => Star(gridPosition: block.gridPosition, xOffset: xPositionOffset),

      const (WaterEnemy) => WaterEnemy(gridPosition: block.gridPosition, xOffset: xPositionOffset),

      _ => throw UnimplementedError(),
      };

      world.add(component);
    }
  }

  void initializeGame({required bool loadHud}) {
    final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i <= segmentsToLoad; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }

    // Setting player
    
    _player = EmberPlayer(position: Vector2(128, canvasSize.y - 128));

    // Adding player to the world
    world.add(_player);

    if (loadHud) {
      camera.viewport.add(Hud());
    }
  }

  void reset() {
    starsCollected = 0;
    health = 3;
    initializeGame(loadHud: false);
  }
}
