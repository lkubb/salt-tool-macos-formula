Display
=======

The following states are found in settings.display:


antialias_subpixel
------------------
Customizes subpixel antialiasing behavior.

Values:
    - bool [default: false since MacOS Mojave 10.11]

References:
    * https://apple.stackexchange.com/questions/382818/what-do-setting-cgfontrenderingfontsmoothingdisabled-from-defaults-actually-do
    * https://apple.stackexchange.com/questions/337870/how-to-turn-subpixel-antialiasing-on-in-macos-10-14


antialias_threshold
-------------------
Sets global antialiasing threshold font size.

Values:
    - int [font size in pixels, default: 4]

.. note::

    Needs reboot (probably).

References:
    * https://github.com/kevinSuttle/macOS-Defaults/issues/17


font_smoothing
--------------
Sets global font smoothing behavior.

Values:
    - string [default: medium since 10.11/El Capitan, before heavy]

        * disabled
        * light
        * medium
        * heavy

    - or int [0-3]

.. note::

    Needs reboot (probably).

References:
    * https://tonsky.me/blog/monitors/#turn-off-font-smoothing
    * https://github.com/bouncetechnologies/Font-Smoothing-Adjuster
    * https://github.com/kevinSuttle/macOS-Defaults/issues/17


nightshift
----------
Customizes NightShift behavior.

Values:
    - dict

        * enabled: bool [default: true]
        * temperature: float [2700-6000, default: 4100]
        * schedule: dict
            - start: HH:mm or HH [default: 22:00]
            - end:   HH:mm or HH [default: 07:00]

.. note::

    When specifying in HH:mm format, remember quote it, otherwise
    yaml might incite chaos.

Example:

.. code-block:: yaml

    nightshift:
      enabled: true
      temperature: 4500
      schedule:
        start: '05:17'
        end:   '13:37'

References:
    * https://web.archive.org/web/20200316123016/https://github.com/aethys256/notes/blob/master/macOS_defaults.md
    * https://www.reddit.com/r/osx/comments/6334ac/toggling_night_shift_from_script/
    * https://github.com/LukeChannings/dotfiles/blob/main/install.macos#L418-L438


truetone
--------
Customizes TrueTone behavior.

Values:
    - bool [default: true]


