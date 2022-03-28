Textinput
=========

The following states are found in settings.textinput:


autocapitalization
------------------
Customizes autocapitalization system-wide.

Values:
    - bool [default: true]


autocorrection
--------------
Customizes global autocorrection configuration.

Values:
    - bool [default: true]


dictation
---------
Customizes status of dictation.

Values:
    - bool [default: false]

References:
    * https://github.com/joeyhoer/starter/blob/master/system/keyboard.sh


press_and_hold
--------------
Customizes activation of press-and-hold behavior for special keys.
Turn this off to enable faster key repeats.

.. note::

    You might need to reboot after applying.

Values:
    - bool [default: true]


repeat
------
Customizes delay and rate of key repeats.
To make this have an effect, turn press and hold off.

.. note::

    You might need to reboot after applying.

Values:
    - dict

        * rate: int [default: ?]
        * delay: int [default: ?]


slow_keys
---------
Customizes state of slow keys accessibility feature (delay before
accepting keypresses).

.. note::

    Needs Full Disk Access.

Values:
    - bool [default: false]


smart_dashes
------------
Customizes activation of smart dashes --.

Values:
    - bool [default: true]


smart_periods
-------------
Customizes activation of smart periods (2x space = .).

Values:
    - bool [default: true]


smart_quotes
------------
Customizes activation of smart quotes.

Values:
    - bool [default: true]


