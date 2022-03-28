Localization
============

The following states are found in settings.localization:


force_124h
----------
Customizes forcing of 12h / 24h format.

Values:
    - string [default: none]

         * 12h
         * 24h


hostname
--------
Customizes hostname.

Values:
    - string


languages
---------
Customizes available system languages.

Values:
    - list of strings (name and country are separated by a dash))

Example:

.. code-block:: yaml

    languages:
      - en-US
      - en-AU


measurements
------------
Customizes measurement units.

Values:
    - string

        * metric
        * US
        * UK


timezone
--------
Customizes timezone.

Values:
    - string

Example:

.. code-block:: yaml

    timezone: Europe/Paris


