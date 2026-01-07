# Godot FPS Controller

A fully-featured first-person controller for Godot 4.5+ with smooth movement mechanics and visual effects.

## Features

### Movement
- Walking, running, jumping, and crouching with state machine
- Smooth acceleration/deceleration for realistic physics
- Proper slope handling and anti-slide mechanics
- Configurable movement speeds and acceleration values

### Camera Effects
- Head bobbing with state-dependent intensity
- Dynamic FOV when running
- Landing nudge effect based on fall velocity
- Mouse look with smoothing

### Customization
All parameters are exposed via `@export` variables for easy tweaking in the editor.

## Controls

| Key | Action |
|-----|--------|
| W/A/S/D | Movement |
| Space | Jump |
| Shift | Run |
| C | Crouch |
| ` | Toggle mouse capture |

## Installation

Copy the `player/` folder into your Godot project and add the player scene to your level.

## License

See [LICENSE](LICENSE) for details.

