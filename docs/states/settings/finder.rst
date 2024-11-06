Finder
======

The following states are found in settings.finder:

.. contents::
   :local:


airdrop_extended
----------------
Customizes AirDrop over Ethernet (and on unsupported old Macs).

Values:
    - bool [default: false]


desktop_icons
-------------
Customizes desktop icons.

Values:
    - dict

      * show: bool [default: true]
      * arrange: string [default: none]
        - none
        - grid
        - name
        - kind
        - last_opened
        - added
        - modified
        - created
        - size
        - tags
      * size: float [default: 64.0]
      * spacing: float [default: 54.0]
      * info: bool [default: false]
      * info_bottom: bool [default: true]
      * text_size: float [default: 12]

Example:

.. code-block:: yaml

  desktop_icons:
    show: true
    arrange: grid
    size: 54
    spacing: 40
    text_size: 11

References:
    * https://github.com/joeyhoer/starter/blob/master/apps/finder.sh


dmg_verify
----------
Customizes disk image integrity verification behavior.

Values:
    - bool [default: true]


fileinfo_popup
--------------
Customizes file info popup expanded panes.

Values:
    - dict

      * comments: bool [default: false]
      * metadata: bool [default: true]
      * name: bool [default: false]
      * openwith: bool [default: true]
      * privileges: bool [default: true]

Example:

.. code-block:: yaml

    fileinfo_popup:
      comments: true
      metadata: false
      name: false
      openwith: true
      privileges: true


folders_on_top
--------------
Customizes Finder sorting behavior regarding folders
(separate on top ~ Windows Explorer vs in line with files).

Values:
    - bool [default: false]


home
----
Customizes new Finder window default path.

Values:
    - string [default: recent]

      * computer
      * volume
      * home
      * desktop
      * documents
      * recent
      * </my/custom/path>

References:
    * https://github.com/joeyhoer/starter/blob/master/apps/finder.sh


new_window_on_mount
-------------------
Customizes Finder behavior when a new volume/disk is mounted.

Values:
    - list [default: all]

      * ro
      * rw
      * disk

Example:

.. code-block:: yaml

    new_window_on_mount: [] # never open a new window


pathbar_home_is_root
--------------------
Customizes Finder Pathbar root directory (disk vs $HOME).

Values:
    - bool [default: false]


prefer_tabs
-----------
Customizes Finder preference for tabs instead of windows.

Values:
    - bool [default: true]


quittable
---------
Customizes Finder quittable status (Quit menu item and Cmd + q).

Values:
    - bool [default: false]


search_scope_default
--------------------
Customizes default search scope.

Values:
    - string [default: mac]

      * mac
      * current
      * previous

References:
    * https://github.com/joeyhoer/starter/blob/master/apps/finder.sh


show_ext_hdd
------------
Customizes display status of external HDD on desktop.

Values:
    - bool [default: true]


show_extensions
---------------
Customizes display status of file extensions.

Values:
    - bool [default: false]


show_hidden
-----------
Customizes display status of hidden files.

Values:
    - bool [default: false]


show_int_hdd
------------
Customizes display status of internal HDD on desktop.

Values:
    - bool [default: false]


show_library
------------
Customizes display status of ~/Library folder.

Values:
    - bool [default: false]


show_nas
--------
Customizes display status of mounted network drives on desktop.

Values:
    - bool [default: true]


show_pathbar
------------
Customizes Finder Path Bar visibility.

Values:
    - bool [default: false]


show_statusbar
--------------
Customizes Finder Status Bar visibility.

Values:
    - bool [default: false]


show_volumes
------------
Customizes display status of /Volumes folder.

Values:
    - bool [default: false]


spring_loading
--------------
Customizes Finder spring loading behavior (open folder on drag).

Values:
    - dict

      * enabled: bool (default: true)
      * delay: float (default: 0.5)

Example:

.. code-block:: yaml

    spring_loading:
      enabled: true
      delay: 0.1


title_hover_delay
-----------------
Customizes hover delay of proxy icons (that can be dragged) in title.

Values:
    - float [default: 0.5]

.. note::

    Note: Before MacOS 11 (Big Sur), there was no delay on hover.

References:
    * https://macos-defaults.com/finder/nstoolbartitleviewrolloverdelay.html


title_path
----------
Customizes presence of full POSIX path to current working directory
in Finder window title.

Values:
    - bool [default: false]


trash_old_auto
--------------
Customizes automatic emptying of Trash after 30 days.

Values:
    - bool [default: true]


view_column
-----------
Customizes default Finder Column View settings for all folders.

Values:
    - dict

      * arrange: string [default: name]
        - none
        - name
        - kind
        - last_opened
        - added
        - modified
        - created
        - size
        - tags
      * col_width: int [default: 245]
      * folder_arrow: bool [default: true]
      * icons: bool [default: true]
      * preview: bool [default: true]
      * preview_disclosure: bool [default: true]
      * shared_arrange: string [default: none]
        - none
        - name
        - kind
        - last_opened
        - added
        - modified
        - created
        - size
        - tags
      * text_size: int [default: 13]
      * thumbnails: bool [default: true]

Example:

.. code-block:: yaml

    view_column:
      arrange: added
      col_width: 200
      icons: false
      shared_arrange: last_opened

References:
    * https://github.com/joeyhoer/starter/blob/master/apps/finder.sh


view_gallery
------------
Customizes default Finder Gallery View settings for all folders.

Values:
    - dict

      * arrange: string [default: name]

        - none
        - name
        - kind
        - last_opened
        - added
        - modified
        - created
        - size
        - tags

      * icon_size: float [default: 48]
      * preview: bool [default: true]
      * preview_pane: bool [default: true]
      * titles: bool [default: false]

Example:

.. code-block:: yaml

    view_gallery:
      arrange: kind
      icon_size: 32
      titles: true


view_icon
---------
Customizes default Finder Icon View settings for all folders (except Desktop).

Values:
    - dict

      * arrange: string [default: none]
        - none
        - grid
        - name
        - kind
        - last_opened
        - added
        - modified
        - created
        - size
        - tags
      * size: float [default: 64]
      * spacing: float [default: 54]
      * info: bool [default: false]
      * info_bottom: bool [default: true]
      * text_size: float [default: 12]

Example:

.. code-block:: yaml

    view_icon:
      arrange: grid
      size: 54
      spacing: 48
      info: true
      info_bottom: false
      text_size: 11

References:
    * https://github.com/joeyhoer/starter/blob/master/apps/finder.sh


view_list
---------
Customizes default Finder List View settings for all folders.

Values:
    - dict

      * calc_all_sizes: bool [default: false]
      * icon_size: float [default: 16]
      * preview: bool [default: true]
      * sort_col: string [default: name]
      * text_size: float [default: 13]
      * relative_dates: bool [default: true]

.. warning::

    This was not tested at all. Proceed with care.


view_preferred
--------------
Customizes preferred Finder view settings.

Values:
    - dict

      * groupby: string [default: none]
        - none
        - name
        - app
        - kind
        - last_opened
        - added
        - modified
        - created
        - size
        - tags
      * style: string [default: icon]
        - icon
        - list
        - gallery [coverflow deprecated?]
        - column

.. note::

    Those values are set when selecting from View menu.

    They are different from ``[FK\_][Standard,Default]ViewSettings.``

.. note::

    Currently, already customized folder views will not be synchronized.
    This would need to delete per-folder settings to apply to all directories:

    .. code-block: bash

        find $HOME -name ".DS_Store" --delete

Example:

.. code-block:: yaml

    view_preferred:
      groupby: none
      style: list

References:
    * https://github.com/joeyhoer/starter/blob/master/apps/finder.sh


warn_on_extchange
-----------------
Customizes Finder warning when changing file extensions.

Values:
    - bool [default: true]


warn_on_icloud_remove
---------------------
Customizes warning when removing files from iCloud Drive.

Values:
    - bool [default: true]


warn_on_trash
-------------
Customizes Finder warning when emptying trash.

Values:
    - bool [default: true]


