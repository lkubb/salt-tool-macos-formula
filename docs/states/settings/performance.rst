Performance
===========

The following states are found in settings.performance:


app_nap
-------
Customizes global app nap behavior.

.. warning::

    This can be set per application (better).
    It is included for documentary purposes primarily.

.. note::

    You might need to reboot to apply the settings.

Values:
    - bool [default: true]


auto_termination
----------------
Customizes global automatic termination of inactive apps behavior.

.. warning::

    This can be set per application (better).
    It is included for documentary purposes primarily.

.. note::

    You might need to reboot to apply the settings.

Values:
    - bool [default: true]


screensaver
-----------
Customizes screensaver behavior.

Values:
    - dict

        * after: int [active after x seconds. default: 1200 / 20min. 0 to disable]
        * clock: bool [default: false]


