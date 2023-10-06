Files
=====

The following states are found in settings.files:


default_handlers
----------------
Customizes the default handler for file types and URL schemes.

Values:
    - dict

      * extensions: dict

        ``extension: handler``

      * schemes: dict

        ``scheme: handler``

      * utis: dict

        ``uti: handler``

.. note::

    The handler has to be installed at the point where this state
    is run, otherwise it will fail. It can be specified by name,
    bundle ID or absolute file path.

Example:

.. code-block:: yaml

    default_handlers:
      extensions:  # extensions will be automatically resolved to all associated UTI
        csv: Sublime Text
        html: Firefox
      schemes:
        http: org.mozilla.Firefox # this will set https as well, user prompt is shown
        ipfs: /Applications/Brave Browser.app
        torrent: Transmission
      utis:
        public.plain-text: TextEdit


dsstore_avoid
-------------
Customizes creation of .DS_Store files on network shares and USB devices.

Values:
    - string [default: none = dump everywhere]
      * none
      * network
      * usb
      * all


save_icloud
-----------
Customizes default "Save as" location of save panel (iCloud vs local).

Values:
    - bool [default: true = iCloud]


screenshots
-----------
Customizes screenshot creation settings.

Values:
    - dict

      * basename: string [default: Screenshot]
      * format: string [default: png]
        - png
        - bmp
        - gif
        - jp(e)g
        - pdf
        - tiff
      * include_date: bool [default: true]
      * include_cursor: bool [default: false?]
      * location: string [default: $HOME/Desktop]
      * shadow: bool [default: true]
      * thumbnail: bool [default: true?]

Example:

.. code-block:: yaml

    screenshots:
      basename: s1(k
      format: bmp
      include_date: true
      include_cursor: false
      location: /Users/h4xx0r/screenshots
      shadow: false
      thumbnail: true

References:
    * https://ss64.com/osx/screencapture.html
    * https://github.com/joeyhoer/starter/blob/master/apps/screenshot.sh


