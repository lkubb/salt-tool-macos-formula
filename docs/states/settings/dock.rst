Dock
====

The following states are found in settings.dock:


autohide
--------
Customizes dock autohide behavior.

Values:
    - dict

        * enabled: bool [default: false]
        * time: float [default: 0.5]
        * delay: float [default: 0.5]

Example:

.. code-block:: yaml

    autohide:
      enabled: true
      time: 0.01
      delay: 0.01

References:
    * https://macos-defaults.com/dock/autohide.html
    * https://macos-defaults.com/dock/autohide-time-modifier.html
    * https://macos-defaults.com/dock/autohide-delay.html


hint_hidden
-----------
Customizes dock hints regarding hidden apps (Cmd + h => translucent dock icon).

Values:
    - bool [default: false]


hint_running
------------
Customizes dock hints regarding running apps (dot below).

Values:
    - bool [default: true]


magnification
-------------
Customizes dock behavior on hover (magnification).

Values:
    - dict

        * enabled: bool [default: false]
        * size: int [default: 128]

Example:

.. code-block:: yaml

    magnification:
      enabled: true
      size: 64


minimize_to_icon
----------------
Customizes window minimization behavior (to application icon or separate dock tile).

Values:
    - bool [default: false = minimize to separate dock tile]


persistent_tiles
----------------
Customizes availability of persistent dock tiles.

Values:
    - bool [default: true]


position
--------
Customizes dock position.

Values:
    - string [default: bottom]

        * bottom
        * left
        * right

References:
    * https://macos-defaults.com/dock/orientation.html


recently_opened
---------------
Customizes dock behavior regarding showing recently opened apps.

Values:
    - bool [default: true]


scroll_to_open
--------------
Customizes dock behavior regarding scrolling over tiles (open app vs do nothing).

Values:
    - bool [default: false]


single_app
----------
Customizes behavior when selecting an app from the dock.

.. hint:

    When enabled, when launching an app from the dock, all other apps will be hidden. (single application mode)

Values:
    - bool [default: false]


size
----
Customizes dock tile (icon) size and mutability.

Values:
    - dict

        * immutable: bool [default: false]
        * tiles: int [default: 48]

References:
    * https://macos-defaults.com/dock/tilesize.html


spring_loading
--------------
Customizes drag hover behavior of all dock tiles (spring loading).

Values:
    - bool [default: false]

References:
    https://macos-defaults.com/misc/enable-spring-load-actions-on-all-items.html


stack_hover
-----------
Customizes highlight on hover behavior of stack tiles (items).

Values:
    - bool [default: false]

References:
    * https://macos-defaults.com/misc/enable-spring-load-actions-on-all-items.html


tiles
-----
Customizes dock tiles (items).

.. warning::

    This currently only supports syncing, not appending.
    Applying this state will delete the previous configuration.

Values:
    - dict

        * apps: list of items
        * others: list of items
        * sync: true [appending is currently very broken]

Single item possible values:
    - type: [possibly autodetected if unspecified]

        * app
        * folder
        * url
        * spacer
        * small-spacer
        * flex-spacer

    - label: string [will be automapped if unspecified]
    - path: string [required]

        * /some/absolute/path
        * some://url

    - displayas: string [directories only, default: stack]

        * folder
        * stack

    - showas: string [directories only, default: auto]

        * auto
        * fan
        * grid
        * list

    - arrangeby: string [directories only, default: added]

        * name
        * added
        * modified
        * created
        * kind

Example:

.. code-block:: yaml

    tiles:
      sync: true # don't append, make it exactly like specified
      apps:
        - /Applications/TextEdit.app  # paths can be specified, type will be autodetected
        -                             # empty items are small spacers
        - type: file                  # this is the verbose variant for app definition
          path: /Applications/Sublime Text.app
          label: Sublime              # the label will otherwise equal app name without .app
        - small-spacer                # add different spacers with [small-/flex-]spacer
        - path: /Applications/Firefox.app
          label: FF                   # type will be autodetected as above
      others:
        - path: /Users/user/Downloads
          displayas: stack            # stack / folder
          showas: grid                # auto / fan / grid / list
          arrangement: added          # name / added / modified / created / kind
          label: DL                   # the label would be set to Downloads otherwise
          type: directory             # will be autodetected as well
        - spacer
        - /Users/user/Documents       # defaults: stack + auto + added. label: Documents.
        - flex-spacer
        - https://www.github.com      # urls can be added as well


