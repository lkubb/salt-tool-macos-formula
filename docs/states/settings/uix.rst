Uix
===

The following states are found in settings.uix:

.. contents::
   :local:


colors
------
Customizes default system colors for accents and highlights.

.. note::

    This currently does not support custom highlight colors (not allowed for accent colors).

Values:
    - dict

      * accent: string [default: multi]
        - multi
        - blue
        - purple
        - pink
        - red
        - orange
        - yellow
        - green
        - graphite

      * highlight: string [default: accent_color]
        - accent_color
        - blue
        - purple
        - pink
        - red
        - orange
        - yellow
        - green
        - graphite


doubleclick_title
-----------------
Customizes action when doubleclicking a window's title.

Values:
    - str [default: maximize]

      * none
      * minimize
      * maximize


hot_corners
-----------
Customizes hot corner settings.

Values:
    - dict ``<corner>: {action: string, modifier: string}``

      * action:

        - none
        - mission-control
        - app-windows
        - desktop
        - screensaver
        - stop-screensaver
        - displaysleep
        - launchpad
        - notification-center
        - lock-screen
        - quick-note

      * modifier: string

        - none
        - shift
        - ctrl
        - opt
        - cmd

    - corners:

      * top-left
      * top-right
      * bottom-left
      * bottom-right

Example:

.. code-block:: yaml

    hot_corners:
      top-left:
        action: displaysleep
        modifier: none
      top-right:
        action: launchpad
        modifier: cmd
      bottom-left:
        action: desktop
        modifier: shift
      bottom-right:
        action: lock-screen
        modifier: opt


live_text
---------
Customizes availability of Live Text (select text in pictures).

Values:
    - bool [default: true]


locate_pointer
--------------
Customizes pointer locating by shaking setting.

Values:
    - bool [default: false]


login_window_input_menu
-----------------------
Customizes visibility of language picker in boot screen.

Values:
    - bool [default: false]


scrollbar_jump_click
--------------------
Customizes global default action when clicking scrollbar.

Values:
    - bool [default: false]


scrollbars_visibility
---------------------
Customizes when scrollbars are visible.

Values:
    - str [default: automatic]]

      * always
      * automatic
      * when_scrolling


sidebar_iconsize
----------------
Customizes global prefered sidebar icon size.

Values:
    - str [default: medium]

      * small
      * medium
      * large


spotlight_index
---------------
Customizes Spotlight index items.

Values:
    - array [of items to enable]

      * applications
      * bookmarks-history
      * calculator
      * contacts
      * conversion
      * definition
      * developer
      * documents
      * events-reminders
      * folders
      * fonts
      * images
      * mail-messages
      * movies
      * music
      * other
      * pdf
      * presentations
      * siri
      * spreadsheets
      * system-preferences


tab_ui_elements
---------------
Customizes tab keypress action in modal dialogs etc.
When enabled, switches to next UI element.
"Full Keyboard Access" light.

Values:
    - bool [default: false]


theme
-----
Customizes system theme.

.. note::

    Currently needs a logout to apply.

Values:
    - string [default: light]

      * dark
      * light
      * auto


toolbar_button_shapes
---------------------
Customizes global toolbar button shape visibility.

Values:
    - bool [default: false]


transparency_reduced
--------------------
Customizes transparency in menus and windows setting.

Values:
    - bool [default: false]


wallpaper_tinting
-----------------
Customizes wallpaper tinting of windows behavior.

Values:
    - bool [default: true]


zoom_scroll_ui
--------------
Customizes activation status of UI zoom by modifier + scrolling feature.

.. note::

    Mind that setting this needs Full Disk Access on your terminal emulator application.

Values:
    - bool [default: false]
    - or mapping

      * enabled: bool [default: false]

      * follow_keyboard_focus: string [default: never]
        - always
        - never
        - when_typing

      * zoom_mode: string [default: full]

        - full
        - split
        - in_picture

      * modifier: string [default: ctrl]

        - ctrl
        - opt
        - cmd


