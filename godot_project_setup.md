# Godot 4.3 Tower Defense - Setup Instructions

## Project Structure

```
your_project/
├── project.godot
├── scripts/
│   ├── core/
│   │   ├── enums.gd
│   │   ├── stats.gd
│   │   ├── item.gd
│   │   ├── weapon.gd
│   │   ├── armor.gd
│   │   ├── inventory.gd
│   │   ├── blueprint_slot.gd
│   │   └── blueprint.gd
│   ├── entities/
│   │   ├── entity.gd
│   │   ├── entity_node.gd
│   │   ├── player_character.gd
│   │   ├── enemy_character.gd
│   │   └── home_castle.gd
│   ├── systems/
│   │   └── spawn_point.gd
│   └── game_manager.gd
└── scenes/
    ├── main.tscn
    ├── player_character.tscn
    ├── enemy_character.tscn
    ├── home_castle.tscn
    └── spawn_point.tscn
```

## Setup Steps

### 1. Create New Godot 4.3 Project
- Open Godot 4.3
- Create new project
- Set to "Mobile" renderer (for phone compatibility)

### 2. Create Script Files
Copy all the script files from the artifacts into the correct folders as shown above.

### 3. Create Scenes

#### **Main Scene (main.tscn)**
1. Root: Node2D (attach `game_manager.gd`)
2. Add Camera2D as child (set as current camera)
3. Add HomeCastle node (instance of `home_castle.tscn`)
   - Position at (500, 300)
4. Add Player node (instance of `player_character.tscn`)
   - Position at (100, 300)
5. Add SpawnPoint node (instance of `spawn_point.tscn`)
   - Position at (900, 300)

#### **Player Character Scene (player_character.tscn)**
1. Root: CharacterBody2D (type: PlayerCharacter script)
   - Collision Layer: 1
   - Collision Mask: 2
2. Children:
   - ColorRect (name: Sprite)
     - Size: (30, 30)
     - Position: (-15, -15)
     - Color: Blue (#0000FF)
   - CollisionShape2D
     - Shape: RectangleShape2D (30x30)
   - ProgressBar (name: HealthBar)
     - Position: (-20, -30)
     - Size: (40, 5)
     - Max Value: 100
     - Show Percentage: false
   - Area2D (name: DetectionArea)
     - CollisionShape2D
       - Shape: CircleShape2D (radius: 150)
     - Connect signals to PlayerCharacter:
       - body_entered → _on_detection_area_body_entered
       - body_exited → _on_detection_area_body_exited

#### **Enemy Character Scene (enemy_character.tscn)**
1. Root: CharacterBody2D (type: EnemyCharacter script)
   - Collision Layer: 2
   - Collision Mask: 1
2. Children:
   - ColorRect (name: Sprite)
     - Size: (25, 25)
     - Position: (-12.5, -12.5)
     - Color: Red (#FF0000)
   - CollisionShape2D
     - Shape: RectangleShape2D (25x25)
   - ProgressBar (name: HealthBar)
     - Position: (-15, -25)
     - Size: (30, 4)
     - Max Value: 100
     - Show Percentage: false

#### **Home Castle Scene (home_castle.tscn)**
1. Root: CharacterBody2D (type: HomeCastle script)
   - Collision Layer: 1
   - Collision Mask: 2
2. Children:
   - ColorRect (name: Sprite)
     - Size: (80, 80)
     - Position: (-40, -40)
     - Color: Green (#00FF00)
   - CollisionShape2D
     - Shape: RectangleShape2D (80x80)
   - ProgressBar (name: HealthBar)
     - Position: (-50, -60)
     - Size: (100, 8)
     - Max Value: 100
     - Show Percentage: false

#### **Spawn Point Scene (spawn_point.tscn)**
1. Root: Node2D (attach `spawn_point.gd`)
2. Children:
   - ColorRect (visual marker)
     - Size: (20, 20)
     - Position: (-10, -10)
     - Color: Yellow (#FFFF00)
     - Modulate Alpha: 0.5

### 4. Project Settings

**Display Settings:**
- Project → Project Settings → Display → Window
  - Width: 1080
  - Height: 720
  - Mode: Windowed (for testing), Fullscreen for mobile
  - Stretch Mode: canvas_items
  - Stretch Aspect: expand

**Input Settings (for desktop testing):**
- Project → Project Settings → Input Map
  - Add action: "click"
  - Map to Mouse Button Left

**Physics Layers:**
- Layer 1: Player/Castle
- Layer 2: Enemies

### 5. Export Settings for Mobile

**Android:**
1. Editor → Manage Export Templates → Download and Install
2. Project → Export → Add → Android
3. Configure:
   - Min SDK: 21
   - Target SDK: 33
   - Enable "Use Custom Build": On
   - Screen Orientation: Landscape
4. Export APK

**iOS:**
1. Similar process, requires Mac + Xcode
2. Project → Export → Add → iOS

## Testing

### Desktop Testing:
- Press F5 or click Play
- Left-click to move player
- Enemies spawn every 3 seconds and attack castle
- Player auto-attacks nearby enemies
- Game resets if player or castle dies

### Mobile Testing:
- Export to APK
- Install on Android device
- Touch screen to move player
- Same gameplay mechanics

## Next Steps / Easy Extensions

1. **Add more enemy types** - Duplicate enemy scene, adjust stats
2. **Add visual effects** - Particle systems for attacks
3. **Better graphics** - Replace ColorRects with sprites
4. **Towers** - Create tower placement system
5. **More weapons** - Add to inventory, weapon switching
6. **Minimap** - Show full battlefield
7. **Wave system** - Configure spawn queues with different enemy types
8. **Save/Load** - Implement checkpoint system

## Architecture Notes

✅ **Clean Separation Achieved:**
- All game logic in pure GDScript classes (Stats, Entity, Inventory, etc.)
- Visual representation in scene files
- Easy to swap out graphics without touching logic
- Entity system supports both Characters and Towers
- Blueprint system ready for expansion

✅ **Mobile Ready:**
- Touch input handled
- Proper collision layers
- Optimized for mobile renderer
- Scalable display settings

✅ **Buildable Foundation:**
- Clear class hierarchy
- Easy to add new item types
- Blueprint system extensible
- Spawn system supports queues (just need to implement)
- All systems modular and decoupled
