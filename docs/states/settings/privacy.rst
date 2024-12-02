Privacy
=======

The following states are found in settings.privacy:

.. contents::
   :local:


allow_targeted_ads
------------------
Customizes state of targeted ads.

This probably superseded com.apple.AdLib forceLimitAdTracking (on Monterey?).

.. note::

    There is still allowIdentifierForAdvertising to be found, but I could not
    find a GUI to set this value.

Values:
    - bool [default: true - wtf]


crashreporter_allow
-------------------
Customizes state of sending analytics and crash reports.

Values:
    - string

      * none
      * apple
      * third_party


searches_share
--------------
Customizes whether search queries from Safari, Siri, Spotlight, Lookup
and others are sent to Apple to be stored.

Values:
    - bool [default: true]


siri_share_recordings
---------------------
Customizes Siri recording sharing status.

Values:
    - bool [default: none]


