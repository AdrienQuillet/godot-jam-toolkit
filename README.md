## AudioManager

The `HAudioManager` is an expertly crafted node designed for managing audio in Godot-powered games. This class provides a robust framework for not only playing back audio assets like sounds and music but also for intricate sound effects management. You can orchestrate audio on various buses and control playback with an incredible degree of precision through designated channels.

### Overview of Functionalities

The `HAudioManager` simplifies audio management, offering straightforward methods to control playback, adjust volumes, and handle audio devices with ease.

#### Playing Sounds

To play a sound, the `HAudioManager` utilizes the `play_audio` method. This method elegantly handles audio playback on specific buses, with optional parameters for fade-in effects and channel targeting, ensuring that your audio is not just heard, but felt. For instance, to play a sound on the `master` bus with a gentle fade-in, one would execute:

```gdscript
audio_manager.play_audio("master", my_audio_stream, 0.5)
```

This line of code effortlessly plays the `my_audio_stream` on the `master` bus, introducing the sound with a 0.5 seconds fade-in, adding a smooth entrance to your audio experience.

#### Adjusting Volume

Changing the volume of a bus is equally simple. The method `set_volume` offers you the capability to specify the volume as a percentage, which the system then converts into decibels:

```gdscript
audio_manager.set_volume("Main", 0.75)
```

This adjusts the `master` bus volume to 75% of its capacity, perfect for scenarios where audio needs to be dynamically controlled, perhaps during quieter in-game moments.

#### Managing Output Devices

The `HAudioManager` also provides functionality to interact with different audio output devices. Using `get_output_devices`, you can retrieve a list of all connected audio outputs, and with `set_output_device`, you can switch output devices on the fly:

```gdscript
var devices = audio_manager.get_output_devices()
audio_manager.set_output_device(devices[0])
```

This flexibility allows for seamless integration of audio across various hardware setups, ensuring your game sounds great, no matter the platform.

#### Muting and Playback Speed

Sometimes, you need to quickly mute certain sounds or even all audio to respond to user settings or gameplay changes. The AudioManager offers `mute` and `unmute` functionalities alongside `is_mute` to check the current state.

Furthermore, to adapt the audio playback to different game speeds, you can use `set_playback_speed_scale` to speed up or slow down all audio correspondingly:

```gdscript
audio_manager.set_playback_speed_scale(1.5)
```

This increases the playback speed by 50%, aligning the audio tempo with faster-paced gameplay scenarios.

Here's a more narrative and literary styled documentation for your HTween class in Godot, crafted to provide a comprehensive overview of its capabilities and how to utilize them creatively within your game projects.

---

## HTween

The `HTween` class stands as a cornerstone for developers looking to infuse life into their games through animation. Functioning as a node that can be seamlessly integrated and edited within the Godot Inspector, `HTween` offers a simple yet powerful approach to creating animations that are as basic or complex as your game demands.

### Capabilities and Configuration

#### Easy Start

`HTween` can be set to begin animations automatically upon being added to the SceneTree, thanks to the `autostart` property. This feature is invaluable for those who wish to have animations roll out without manual scripting, ensuring that your game's dynamic elements come alive the moment they appear on screen.

#### Flexible Animation Configurations

The tool is versatile, supporting both simple and advanced configurations:
- **Single Animation**: Ideal for straightforward, one-off animations. Configure this through the `animation` property where you define the animation specifics.
- **Advanced Animations**: For more layered, step-by-step animations where each step can be finely controlled and orchestrated to create complex sequences.

#### Looping and Playback

`HTween` excels in its ability to loop animations:
- **No Loop**: Plays once, suitable for fire-and-forget scenarios like explosions or quick visual feedback.
- **Loop**: For ongoing animations, such as background effects or character idles, this mode will keep the animation cycling.

### Practical Examples

#### Creating a Simple Fade-In

Imagine you want to fade in a UI element. With `HTween`, you can set this up with a few lines in the editor or script, selecting `EaseType.EASE_IN` for a smooth, accelerating transition.

#### Orchestrating Complex Sequences
For a more complex scenario, such as an interactive cutscene, `HTween` allows the combination of multiple animations through its advanced configuration mode. Each step can be timed and layered to work in harmony, providing a rich, cinematic experience.

#### Responsive Control
Control is at your fingertips; you can pause, play, or stop animations as needed through simple method calls. This can be tied to game events or player interactions, giving you the flexibility to adapt the game's flow in real time.

### Technical Considerations

#### Tween Management
Internally, `HTween` manages a series of tweens—whether property tweens for animating properties over time, method tweens for calling methods, or even custom callback tweens for specific needs.

#### Signals and Events

- **finished**: Triggered when all animations complete, if not looping.
- **loop_finished**: Notifies at the end of each loop, useful for triggering events after a certain number of cycles.

Absolutely! Here is a literary and detailed documentation for the `HTweenBuilder` classes and associated classes, which implement a Builder pattern to facilitate the creation and management of `HTween` animations in Godot.

---

### Building Complex Animations with `HTweenBuilder`

The `HTweenBuilder` suite offers a sophisticated set of tools for building and managing animations in Godot using the `HTween` system. Designed for both simplicity and flexibility, these builder classes allow developers to programmatically configure and control animations with precision, offering a fluent interface that enhances readability and ease of use.

#### HTweenBuilder: The Core of Your Animation

`HTweenBuilder` serves as the central class for constructing `HTween` objects. It provides methods to set up animation loops, start conditions, easing, transitions, and more. Each method call typically returns the builder itself, allowing for method chaining—a fluent style that makes the code intuitive and concise.

#### Usage Example

Here's a quick example to illustrate how you might use `HTweenBuilder` to create an animation:

```gdscript
var tween:HTween = HTweenBuilder.build_tween(my_node)
    .loop_count(5)
    .autostart()
    .default_ease(HTween.EaseType.EASE_IN_OUT)
    .new_step()
        .tween_property(sprite, "modulate", Color.RED, 1.0)
    .build()
```

This snippet creates an `HTween` that loops five times, starts automatically, and uses an "ease in out" easing type for transitions.

#### Advanced Configurations with HTweenStepBuilder

For more complex animations that require multiple steps or parallel animations, `HTweenStepBuilder` comes into play. This class allows you to define discrete animation steps within an `HTween`.

##### Crafting a Multi-Step Animation

You might use `HTweenStepBuilder` to create a sequence where several properties are animated one after another:

```gdscript
var tween:HTween = HTweenBuilder.build_tween(my_node)
    .new_step()
        .tween_property(sprite, "modulate", Color.RED, 1.0)
    .new_step(true) # Parallel mode for animations in this step
        .tween_property(sprite, "position", Vector2(100, 200), 1.0)
        .tween_property(sprite, "modulate", Color.GREEN, 1.0)
    .autostart()
    .build()
```

Each call to `new_step()` creates a new animation step, allowing for sequential or parallel animations based on your design needs.

#### Granular Control with HTweenAnimationBuilder

For the finest level of control over individual animations, the `HTweenAnimationBuilder` and its subclasses (`HTweenAnimationCallableBuilder`, `HTweenAnimationIntervalBuilder`, etc.) provide specialized methods to configure each animation precisely. These classes are typically accessed via the `HTweenStepBuilder`, chaining into the creation of specific animations.

##### Example: Method Animation

Here's how you might animate a method call with specific parameters:

```gdscript
var tween = HTweenBuilder.build_tween(my_node)
    .new_step()
        .tween_method(my_object, "set_opacity", 0, 100, 2.0)
        .build()
    .build()
```

This constructs an animation step that gradually changes the opacity of `my_object` from 0 to 100 over 2 seconds.

#### Building and Integrating

Once an `HTween` is fully configured, calling `build()` on the `HTweenBuilder` or any sub-builder finalizes the structure and integrates the tween into your node hierarchy, ready to be played according to its configuration.

Here's an enriched and detailed documentation suitable for an online repository, providing an insightful guide on using the `SceneLoader` class designed for asynchronous scene management in Godot.

---

## HSceneLoader


The `HSceneLoader` is a powerful node utility designed to enhance game performance and responsiveness by loading and instantiating scenes asynchronously in Godot. This utility is especially useful in large projects where managing scene loading times is crucial for maintaining a smooth user experience.

### Features

- **Asynchronous Scene Loading**: Load scenes without blocking the main game thread, allowing for complex scenes to be loaded in the background.
- **Progress Tracking**: Monitor the progress of scene loading with detailed progress updates.
- **Event-Driven Notifications**: Utilize signals to respond to various stages of the loading process, such as when loading starts, progresses, completes, or fails.

### Signals

- `on_scene_load_started(scene_path: String)`: Emitted when a scene starts loading asynchronously.
- `on_scene_load_progress(scene_path: String, progress: float)`: Emitted periodically to update on the loading progress.
- `on_scene_load_finished(scene_path: String, scene: PackedScene)`: Emitted when a scene has fully loaded.
- `on_scene_load_failed(scene_path: String)`: Emitted if the scene fails to load.
- `on_scene_instantiation_finished(scene_path: String, scene_instance: Node)`: Emitted when a scene instance has been created asynchronously.
- `on_scene_instantiation_failed(scene_path: String)`: Emitted if there is a failure in creating a scene instance asynchronously.

### Usage

#### Immediate Loading

For scenarios where blocking is acceptable, such as during a loading screen:

```gdscript
var scene = scene_loader.immediate_load_scene("res://path/to/scene.tscn")
```

This method blocks the current thread until the scene is fully loaded.

#### Asynchronous Loading

To load a scene without blocking, allowing gameplay or animations to continue uninterrupted:

```gdscript
var promise:HPromise = scene_loader.async_load_scene("res://path/to/scene.tscn")
promise.resolved.connect(_on_scene_loaded)
```

This approach utilizes a promise pattern, where `resolved` and `rejected` signals can be connected to callback methods handling the loaded scene or an error.

#### Asynchronous Instantiation

To asynchronously instantiate a scene after loading:

```gdscript
var promise:HPromise = scene_loader.async_scene_instantiate("res://path/to/scene.tscn")
promise.resolved.connect(_on_scene_instance_ready)
```

This method first loads the scene and then instantiates it, all without blocking the main game thread.

### Implementation Details

The class leverages Godot's threading and resource loading capabilities to manage scene loading operations efficiently. A thread pool is utilized to handle multiple load operations concurrently, and the loading state of each scene is tracked using a dictionary. Progress updates and completion are managed via signals, ensuring that the main game logic remains responsive and performant during heavy load operations.

#### Thread Safety

Scene loading and instantiation tasks are managed within a controlled thread pool environment, ensuring that operations are thread-safe and do not conflict with the main game operations.

Here's a narrative and comprehensive documentation for the `SceneChanger` class, detailing its functionalities and use in Godot for creating dynamic scene transitions with visual effects.

---

## HSceneChanger

`HSceneChanger` is a node utility designed for Godot, which facilitates smooth and visually appealing transitions between scenes. It leverages a variety of animation textures and effects to enhance the user experience during scene changes, making transitions seamless and engaging.

### Key Features

- **Variety of Transition Effects**: Includes numerous built-in textures like burst, cloud, and rain, allowing for diverse visual styles during transitions.
- **Customizable Transition Modes**: Supports different modes such as fade-in, fade-out, and blending with flexible control over the duration and colors.
- **Asynchronous Loading**: Integrates with asynchronous scene loading to ensure transitions do not hinder game performance.

### Transition Modes

`HSceneChanger` supports several modes to cater to different aesthetic needs and functional requirements:

- **Fade In**: Gradually introduces a new scene from a specified color.
- **Fade Out**: Fades out the current scene to a specified color before transitioning.
- **Fade Out In**: Combines fade-out and fade-in for a complete transition effect.
- **Blend**: Uses a texture to transition between scenes, offering unique effects like swirls or pixelation.

Each mode can be customized with parameters such as duration and color to match the game's theme and pacing.

### Usage

Here are a few examples of how to use the `HSceneChanger` to transition between scenes:

#### Fade Out Transition

To change from the current scene to a new scene with a fade-out effect:

```gdscript
scene_changer.fade_out("res://new_scene.tscn")
```

#### Custom Blend Transition

To use a custom texture for a visually striking transition:

```gdscript
scene_changer.blend("res://new_scene.tscn", preload("res://textures/custom_transition.png"))
```

#### Asynchronous Scene Loading

`HSceneChanger` can handle scene transitions asynchronously to avoid gameplay interruptions:

```gdscript
scene_changer.fade_in("res://new_scene.tscn")
```

This method will preload the new scene in the background before executing the transition.

### Built-In Textures

`HSceneChanger` includes a variety of preloaded textures that can be used for transitions. These are easily accessed by name, such as `burst`, `cloud`, or `mandelbrot`. Each texture offers a unique visual style, allowing developers to choose the best fit for their scene transitions.

#### Example Using a Built-In Texture

To transition to a new scene using the `rain` texture:

```gdscript
scene_changer.rain("res://next_scene.tscn")
```

Here is a comprehensive and detailed Markdown documentation for the `HGuiAnimator` class, a Godot utility designed to animate GUI elements in sophisticated and visually appealing ways.

---

## `HGuiAnimator`

`HGuiAnimator` is a utility node for Godot designed to synchronize and animate multiple control nodes simultaneously, providing a rich set of animations for showing and hiding UI elements. This tool is ideal for creating dynamic menus, pop-up dialogs, and interactive UI elements that require smooth and engaging transitions.

### Features

- **Multiple Animation Types**: Supports various animations such as fading, scaling, and sliding from different directions.
- **Customizable Animation Parameters**: Offers detailed control over animation duration, delay, easing, and transition effects.
- **Sequential Animation Execution**: Animations can be executed in sequence with a specified delay between each, enhancing the visual appeal.
- **Event-Driven**: Provides signals that notify when animations start and end, both for showing and hiding.

### Animation Types

`HGuiAnimator` supports a variety of animations for both showing and hiding GUI elements:

- **Fade**: Change the alpha channel to create a fade-in or fade-out effect.
- **Scale**: Uniform scaling or along specific axes.
- **Slide**: Move elements from off-screen edges (top, bottom, left, right, or corners).
- Each animation type can be customized for appearance (show) or disappearance (hide) actions.

### Properties

- `auto_start`: Automatically starts the show animation when ready.
- `show_animation`, `hide_animation`: Determines the type of animation used for showing or hiding the GUI controls.
- `delay_between_animations`: Sets the delay between start times of animations for individual controls.
- `animation_duration`: Duration of each control’s animation.
- `transition_type`: Type of interpolation used for the animations.
- `ease_type`: Specifies the easing function to smooth out the animation.
- `controls`: Array of Control nodes to be animated. The order in the array implies the order of animation.
- `override_pivot_offset`: When set, automatically adjusts each control’s pivot to its center, necessary for certain types of animations like scale.

### Usage

#### Basic Setup

1. **Add Controls**: Populate the `controls` array with the GUI elements you want to animate.
2. **Configure Animations**: Set `show_animation` and `hide_animation` to your desired types.
3. **Adjust Timing**: Set `animation_duration` and `delay_between_animations` as needed.

#### Example

Here’s a simple example to fade in a series of menu buttons:

```gdscript
var gui_animator = HGuiAnimator.new()
gui_animator.controls = [button1, button2, button3]
gui_animator.show_animation = HGuiAnimator.AnimationType.FADE
gui_animator.animation_duration = 0.5
gui_animator.delay_between_animations = 0.2
add_child(gui_animator)
gui_animator.show()
```

#### Advanced Usage

Combine different animation types for show and hide actions to create engaging UI interactions:

```gdscript
gui_animator.show_animation = HGuiAnimator.AnimationType.SLIDE_TOP
gui_animator.hide_animation = HGuiAnimator.AnimationType.FADE
gui_animator.ease_type = HGuiAnimator.EaseType.EASE_OUT_IN
gui_animator.transition_type = HGuiAnimator.TransitionType.TRANS_QUAD
```

### Signals

- `show_started`: Emitted when the show animation starts.
- `show_finished`: Emitted when all show animations have completed.
- `hide_started`: Emitted when the hide animation starts.
- `hide_finished`: Emitted when all hide animations have completed.
