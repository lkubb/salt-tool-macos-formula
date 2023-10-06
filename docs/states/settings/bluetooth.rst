Bluetooth
=========

The following states are found in settings.bluetooth:


enabled
-------
Customizes power state of Bluetooth.

Values:
    - bool [default: true]

.. note::

    Needs to run as root.


enabled_airplane
----------------
Customizes power state of Bluetooth in Airplane Mode.

Values:
    - bool [default: true]

.. note::

    Needs to run as root.


ignored
-------
Adds/syncs bluetooth device MAC (to) ignore list.

.. warning::

    Note that this might be dysfunctional in Monterey.

Values:
  - dict:

    * devices: list (default: [])
    * sync: bool (default: false)

Example:

.. code-block:: yaml

    ignored:
      devices:
        - <MAC1>
        - <MAC2>
      # syncs ignored devices with above list
      sync: true
      # false would make sure they are added to the list

.. hint::

    Needs to run as root.


