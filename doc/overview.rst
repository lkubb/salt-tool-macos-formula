Overview
========

This formula consists of states that manage MacOS system settings as well as supporting execution and state modules. Most of the settings have been tested with macOS Monterey.

Settings
--------

The manageable settings are listed in ``pillar.example``. The supporting state files are organized in the same hierarchy as the pillar values. Most of them contain more detailed descriptions. I still need to find a way to parse those into this documentation.

* `animations <settings/animations.html>`_:
    Manages different animations and durations.
* `apps <settings/apps/index.html>`_:
    Currently manages Messages.app.
* `audio <settings/audio.html>`_:
    UI sound effects, sound devices
* `behavior <settings/behavior.html>`_:
    automatic behavior that might annoy you if it is not exactly as you like it
* `bluetooth <settings/bluetooth.html>`_:
    activation and ignored devices
* `display <settings/display.html>`_:
    antialiasing, True Tone, Night Shift
* `dock <settings/dock.html>`_:
    dock behavior, design, items
* `files <settings/files.html>`_:
    misc file handling, including screenshots
* `finder <settings/finder.html>`_:
    specific finder behaviors and view settings
* `keyboard <settings/keyboard.html>`_:
    settings that concern the hardware scope of keyboards
* `localization <settings/localization.html>`_:
    hostname, language and timezone settings
* `mail <settings/mail.html>`_:
    Manages Mail.app. **Needs Full Disk Access** for your terminal emulator.
* `menubar <settings/menubar.html>`_:
    icons in Menu Bar and Control Center applications
* `performance <settings/performance.html>`_:
    app nap etc.
* `power <settings/power.html>`_:
    pmset settings
* `privacy <settings/privacy.html>`_:
    Siri and other analytics
* `security <settings/security.html>`_:
    many different settings that might be seen as security-related like autoupdate, firewall, mdns
* `siri <settings/siri.html>`_:
    voice assistant settings
* `textinput <settings/textinput.html>`_:
    settings concerning the software side of text input
* `timemachine <settings/timemachine.html>`_:
    Time Machine settings. **Needs Full Disk Access** for your terminal emulator.
* `touch <settings/touch.html>`_:
    Trackpad gestures (touch gestures)
* `uix <settings/uix.html>`_:
    miscellaneous user interface / user experience settings like colors/theme, hot corners, and spotlight index items
