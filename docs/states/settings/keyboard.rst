Keyboard
========

The following states are found in settings.keyboard:

.. contents::
   :local:


brightness_adjustment
---------------------
Customizes keyboard brightness adjustment behavior.

Values:
    - dict

      * low_light: bool [default: true]
      * after: int [seconds of inactivity, default: 0 = disabled]

Example:

.. code-block:: yaml

    brightness_adjustment:
      low_light: true # adjust in low light
      after: 30       # adjust after x seconds of inactivity


fn_action
---------
Customizes action when pressing Fn key.

.. note::
    You might need to reboot after applying.

Values:
    - string [default: input_source ?]

      * none
      * dictation
      * emoji
      * input_source


function_keys_standard
----------------------
Customizes default state of function keys. Enabling this will
make F1 to F12 behave like standard F1 to F12, not as system function keys.

.. note::

    You might need to reboot after applying.

Values:
    - bool [default: false]


