
## AudioManager

The `HAudioManager` is an expertly crafted autoload class designed for managing audio in Godot-powered games. This class provides a robust framework for not only playing back audio assets like sounds and music but also for intricate sound effects management. You can orchestrate audio on various buses and control playback with an incredible degree of precision through designated channels.

### Overview of Functionalities

The `HAudioManager` simplifies audio management, offering straightforward methods to control playback, adjust volumes, and handle audio devices with ease.

#### Playing Sounds

To play a sound, the `HAudioManager` utilizes the `play_audio` method. This method elegantly handles audio playback on specific buses, with optional parameters for fade-in effects and channel targeting, ensuring that your audio is not just heard, but felt. For instance, to play a sound on the `master` bus with a gentle fade-in, one would execute:

```gdscript
HAudioManager.play_audio("master", my_audio_stream, fade_in=0.5)
```

This line of code effortlessly plays the `my_audio_stream` on the `master` bus, introducing the sound with a 0.5 seconds fade-in, adding a smooth entrance to your audio experience.

#### Adjusting Volume

Changing the volume of a bus is equally simple. The method `set_volume` offers you the capability to specify the volume as a percentage, which the system then converts into decibels:

```gdscript
HAudioManager.set_volume("Main", 0.75)
```

This adjusts the `master` bus volume to 75% of its capacity, perfect for scenarios where audio needs to be dynamically controlled, perhaps during quieter in-game moments.

#### Managing Output Devices

The `HAudioManager` also provides functionality to interact with different audio output devices. Using `get_output_devices`, you can retrieve a list of all connected audio outputs, and with `set_output_device`, you can switch output devices on the fly:

```gdscript
var devices = HAudioManager.get_output_devices()
HAudioManager.set_output_device(devices[0])
```

This flexibility allows for seamless integration of audio across various hardware setups, ensuring your game sounds great, no matter the platform.

#### Muting and Playback Speed

Sometimes, you need to quickly mute certain sounds or even all audio to respond to user settings or gameplay changes. The AudioManager offers `mute` and `unmute` functionalities alongside `is_mute` to check the current state.

Furthermore, to adapt the audio playback to different game speeds, you can use `set_playback_speed_scale` to speed up or slow down all audio correspondingly:

```gdscript
HAudioManager.set_playback_speed_scale(1.5)
```

This increases the playback speed by 50%, aligning the audio tempo with faster-paced gameplay scenarios.
