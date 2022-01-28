Touch
=====

app_expose
----------
    Customizes App Exposé touch gesture.

    Values:
        - bool [default: true]

    .. note::

        Select the number of fingers for vertical swipes by setting
        app_expose_mission_control = three / four. Take care with
        three finger settings, they can conflict easily. This formula
        will try to automatically fall back to sensible values.

drag
----
    Customizes three finger drag touch gesture activation status.

    Values:
        - bool [default: false]

    .. note::

        Tap to click needs to be active as well for this to be active.

force_click
-----------
    Customizes Force Click activation status.

    Values:
        - bool [default: true]

haptic_feedback_click
---------------------
    Customizes click feedback (seen in "Silent clicking").

    Values:
        - bool [default: true]

    References:
        * https://github.com/joeyhoer/starter/blob/master/system/trackpad.sh

haptic_resistance_click
-----------------------
    Customizes resistance and haptic feedback strength for clicks.

    Values:
        - string [default: medium]

            * low
            * medium
            * high

launchpad
---------
    Customizes Launchpad touch gesture activation status.

    Values:
        - bool [default: true]

    .. note::

        Pinch gestures need to be active for Launchpad or Show Desktop actions.

lookup
------
    Customizes lookup touch gesture.

    Values:
        - bool [default: true = force click]
        - or string

            * three
            * four

mission_control
---------------
    Customizes Mission Control touch gesture.

    Values:
        - bool [default: true]

    .. note::

        Select the number of fingers for vertical swipes by setting
        app_expose_mission_control = three / four. Take care with
        three finger settings, they can conflict easily. This formula
        will try to automatically fall back to sensible values.

natural_scrolling
-----------------
    Customizes scrolling direction (natural/analog).

    .. note::

        Until I get to finalize macsettings, all of the touch
        settings need a restart. @TODO

    Values:
        - bool [default: true]

notification_center
-------------------
    Customizes Notification Center touch gesture activation status.

    Values:
        - bool [default: true]

rotate
------
    Customizes Rotate touch gesture activation status.

    Values:
        - bool [default: true]

secondary_click
---------------
    Customizes secondary click touch gesture activation status.

    Values:
        - string [default: two]

            * two [fingers]
            * corner-right [bottom]
            * corner-left [bottom]

        - or false

show_desktop
------------
    Customizes Show Desktop touch gesture activation status.

    Values:
        - bool [default: true]

    .. note::

        Pinch gestures need to be active for Launchpad or Show Desktop actions.

smart_zoom
----------
    Customizes Smart Zoom touch gesture activation status.

    Values:
        - bool [default: true]

swipe_fullscreen
----------------
    Customizes swipe fullscreen apps touch gesture activation status.

    Values:
        - string [default: three]

            * three
            * four

        - or false

swipe_pages
-----------
    Customizes swipe pages touch gesture activation status.

    Values:
        - string [default: two]

            * two
            * three
            * both

        - or false

tap_to_click
------------
    Customizes tap-to-click activation status.

    Values:
        - bool [default: false]

    .. note::

        Note that this has to be active when you enable three finger drag.

tracking_speed
--------------
    Customizes tracking speed.

    Values:
        - float [0-3, default: 1?]

    .. note::

        In System Preferences, the discrete values are:
        0 - 0.125 - 0.5 - 0.685 - 0.875 - 1 - 1.5 - 2 - 2.5 - 3

zoom
----
    Customizes zoom gesture activation status.

    Values:
        - bool [default: true]
