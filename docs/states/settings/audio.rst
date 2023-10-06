Audio
=====

The following states are found in settings.audio:


boot_sound
----------
Customizes boot sound (chime) behavior.

Values:
    - bool [default: false since 2016 models]

.. hint::

    Earlier, this could be set with `nvram SystemAudioVolume=" " / =%80.`

References:
    * https://apple.stackexchange.com/questions/168092/disable-os-x-startup-sound
    * https://apple.stackexchange.com/questions/409521/how-to-stop-startup-chime-on-boot-up
    * https://git.herrbischoff.com/awesome-macos-command-line/about/


charging_sound
--------------
Customizes charging sound (chime) behavior.

Values:
    - bool [default: true since 10.13/High Sierra]

.. hint::

    Up until Sierra, this was turned of by default and could be enabled with ChimeOnAllHardware.

References:
    * https://git.herrbischoff.com/awesome-macos-command-line/about/


devices
-------
Customizes audio device settings. Currently only adds
default settings for specific devices. @TODO preferred_devices
management.

Values:
    - list of dicts:

        [ {device_uid: { setting: value } } ]

Example:

.. code-block:: yaml

    - "device.AppleUSBAudioEngine:Native Instruments:Komplete Audio 6 MK2:ABCD1EF2:1,2":
        output.stereo.left: 5
        output.stereo.right: 6


sound_effect_alert
------------------
Customizes alert sound.

Values:
    - string [default: Tink = Boop in System Preferences]

      * Basso
      * Blow
      * Bottle
      * Frog
      * Funk
      * Glass
      * Hero
      * Morse,
      * Ping
      * Pop
      * Purr
      * Sosumi
      * Submarine
      * Tink

.. hint::

    Find available ones in ``/System/Library/Sounds/*.aiff``.
    Listen to them via ``afplay /System/Library/Sounds/<name>.aiff``.

References:
    * https://github.com/joeyhoer/starter/blob/master/system/sound.sh


sound_effect_volume
-------------------
Customizes sound effect volume (in parts of current output volume).

Values:
    - float [default: 1]

References:
    * https://github.com/joeyhoer/starter/blob/master/system/sound.sh


sound_effect_volumechange
-------------------------
Customizes volume change feedback sound effect behavior.

Values:
    - bool [default: false]


sound_effects_system
--------------------
Customizes system UI sound effect behavior.

Values:
    - bool [default: true]

.. hint::

    This manages system UI sound effects. For all apps, see sound_effects_ui.

References:
    * https://github.com/joeyhoer/starter/blob/master/system/sound.sh
    * https://discussions.apple.com/thread/253125795


sound_effects_ui
----------------
Customizes global UI sound effect behavior.

Values:
    - bool [default: true]

.. hint::

    This manages global UI sound effects. For macOS system only, see sound_effects_system.

References:
    * https://superuser.com/questions/278537/disable-sounds-in-10-5-and-10-6
    * https://github.com/joeyhoer/starter/blob/master/system/sound.sh
    * https://discussions.apple.com/thread/253125795


spatial_follow_head
-------------------
Customizes "spatial audio follows head movements" setting.

Values:
    - bool [default: true]


