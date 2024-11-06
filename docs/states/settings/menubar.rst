Menubar
=======

The following states are found in settings.menubar:

.. contents::
   :local:


accessibility
-------------
Customizes display status of Accesibility Shortcuts widget in Menu Bar and Control Center.

Values:
    - dict

      * menu: bool [default: false]
      * control: bool [default: false]


airdrop
-------
Customizes display status of Airdorp widget in Menu Bar.

Values:
    - bool [default: false]


autohide_desktop
----------------
Customizes autohide behavior of MacOS Menu Bar (top bar) on Desktop.

Values:
    - bool [default: false]


autohide_fullscreen
-------------------
Customizes autohide behavior of MacOS Menu Bar (top bar) in fullscreen mode.

Values:
    - bool [default: true]


battery
-------
Customizes display behavior of Battery widget in Menu Bar and Control Center.

Values:
    - dict

      * menu: bool [default: true]
      * control: bool [default: false]
      * percent: bool [default: false]


bluetooth
---------
Customizes display status of Bluetooth widget in Menu Bar.

Values:
    - bool [default: false]


clock
-----
Customizes display behavior of Clock widget in Menu Bar.

Values:
    - dict

      * analog: bool [default: false]
      * flash_seconds: bool [default: false]
      * format: string [default: ``EEE HH:mm`` for EU]

.. note::

    This force-sets the format string. It will work, but applying something
    in System Preferences will reset everything. @TODO parse format string


display
-------
Customizes display status of Display widget in Menu Bar.

Values:
    - when_active [default: when_active]
    - or bool


focus
-----
Customizes display status of Focus widget in Menu Bar.

Values:
    - when_active [default: when_active]
    - or bool


keyboard_brightness
-------------------
Customizes display status of Keyboard Brightness widget in Menu Bar.

Values:
    - bool [default: false]


now_playing
-----------
Customizes display status of Now Playing widget in Menu Bar.

Values:
    - when_active [default: when_active]
    - or bool


screen_mirroring
----------------
Customizes display status of Screen Mirroring widget in Menu Bar.

Values:
    - when_active [default: when_active]
    - or bool


siri
----
Customizes display status of Siri widget in Menu Bar.

Values:
    - bool [default: false]


sound
-----
Customizes display status of Sound widget in Menu Bar.

Values:
    - when_active [default: when_active]
    - or bool


spotlight
---------
Customizes display status of Spotlight widget in Menu Bar.

Values:
    - bool [default: false]


timemachine
-----------
Customizes display status of Time Machine widget in Menu Bar.

Values:
    - bool [default: false]


userswitcher
------------
Customizes display status of User Switcher widget in Menu Bar and Control Center.

Values:
    - dict

      * menu: bool [default: false]
      * control: bool [default: false]
      * menu_show: string [default: icon]
        - icon
        - username
        - fullname

References:
    * https://github.com/joeyhoer/starter/blob/master/system/users-groups.sh


wifi
----
Customizes display status of Wifi status widget in Menu Bar.

Values:
    - bool [default: true]


