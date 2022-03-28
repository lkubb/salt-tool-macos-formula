Animation Settings
==================

Manage activation status and duration of animations system-wide.


cursor_blinking
---------------
Customizes cursor blinking on/off periods. False to disable. Else specify on/off periods.

Values:
    - false to disable
    - or dict

        * on: float [default: ?]
        * off: float [default: ?]

Example:

.. code-block:: yaml

    cursor_blinking:
      on: 2.5
      off: .5


dock_bounce
-----------
Customizes bounce animation in dock (alert on changes/needs attention).

Values:
    - bool [default: true]


dock_launch
-----------
Customizes app startup animation in dock.

Values:
    - bool [default: true]


dock_minimize
-------------
Customizes window minimize animation to dock.

Values:
  - string [default: genie]

    * genie
    * scale
    * suck

References:
    * https://macos-defaults.com/dock/mineffect.html


finder_windows
--------------
Customizes Finder window animation activation status.
This mostly affects the File Info dialog.

Values:
    - bool [default: true]


focus_ring
----------
Customizes global focus ring blend-in animation activation status.

Values:
    - bool [default: true]


macos_windows
-------------
Customizes MacOS window animation activation status.

.. note::

    This might need a reboot to apply.

Values:
    - bool [default: true]


mission_control
---------------
Customizes Mission Control animation duration.

Values:
    - float [default: 0.5?]


motion_reduced
--------------
Customizes motion reducing mode.
This e.g. changes the animation when swiping between spaces to fade/blend.

Values:
    - bool [default: false]


multidisplay_swoosh
-------------------
Customizes multidisplay swoosh animation activation status.

Values:
    - bool [default: true]


window_resize_time
------------------
Customizes MacOS window resize time.

.. note::

    Might take a reboot to apply.

Values:
    - float [default: 0.5?]


