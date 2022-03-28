Siri
====

The following states are found in settings.siri:


enabled
-------
Customizes Siri activation status.

.. note::

    Note that System Preferences does much more when toggling
    the option. This might be very incomplete.

Values:
    - bool [default: false]


keyboard_shortcut
-----------------
Customizes Siri keyboard shortcut.

.. note::

    Note that custom keyboard shortcuts are currently not supported here.
    Needs a logout to apply.

Values:
    - bool [default: false]

References:
    * https://github.com/joeyhoer/starter/blob/master/system/siri.sh


language
--------
Customizes Siri language.

Values:
    - string [default: maybe depending on system locale? otherwise en-US]


voice_feedback
--------------
Customizes Siri voice feedback.

Values:
    - bool [default: true]


voice_variety
-------------
Customizes Siri voice variety.

Values:
    - dict

        * language: string [e.g. en-AU]
        * speaker: string [e.g. gordon]


