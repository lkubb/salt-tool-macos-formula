Behavior
========

confirm_on_close
----------------
    Customizes behavior when closing a window with unconfirmed changes.

    Values:
        - bool [default: false = save silently and close]

crashreporter
-------------
    Customizes behavior when apps have crashed.

    Values:
        - bool [default: true = show Crash Reporter]

feedback_assistant_autogather
-----------------------------
    Customizes whether Feedback Assistant automatically gathers
    large files when submitting a report.

    Values:
        - bool [default: true]

    References:
        * https://macos-defaults.com/feedback-assistant/autogather.html

handoff_allow
-------------
    Customizes whether Handoff is allowed between Mac and other iCloud devices.

    Values:
        - bool [default: true]

help_window_floats
------------------
    Customizes Help viewer window floating status.

    Values:
        - bool [default: true]

media_inserted
--------------
    Customizes behavior when inserting a new CD/DVD.

    Possible values, global or per type:
        * ignore
        * ask
        * finder
        * itunes
        * disk_utility

    .. note::
        There is also the possibility to open an application, which
        is currently not implemented.
        For this, use -int 5. @TODO

    Values:
        - string [one value for all, see above]
        - or dict

            * blank_cd: string [see above]
            * blank_dvd: string [see above]
            * music: string [see above]
            * picture: string [see above]
            * video: string [see above]

    Example:

    .. code-block:: yaml

        media_inserted:
          blank_cd: disk_utility
          blank_dvd: ask
          music: itunes
          pictures: finder
          video: ask

    References:
        * https://github.com/joeyhoer/starter/blob/master/system/cds-dvds.sh

mission_control_grouping
------------------------
    Customizes Mission Control window grouping behavior.

    Values:
        - bool [default: true = group windows by application]

notification_display_time
-------------------------
    Customizes Notification Center notification display time.

    Values:
        - int [seconds, default: 5]

photos_hotplug
--------------
    Customizes Photos hotplug behavior (open Photos.app when media is inserted,
    might apply to plugging in iPhone as well).

    Values:
        - bool [default: true]

power_button_sleep
------------------
    Customizes behavior when pressing the power button.

    .. note:

        Might need a reboot to apply.

    Values:
        - bool [default: true]

            * true = put system to sleep
            * false = show prompt

print_panel_expanded
--------------------
    Customizes default state of print panel (expanded or collapsed).

    Values:
        - bool [default: false]

printqueue_autoquit
-------------------
    Customizes behavior of print queue when all print jobs are finished (quit or keep running).

    Values:
        - bool [default: false]

resume_app
----------
    Customizes default app resume behavior when reopening an app that was quit with open windows.

    Values:
      - bool [default: true]

save_panel_expanded
-------------------
    Customizes default state of save panel (expanded vs collapsed).

    Values:
        - bool [default: false]

spaces_rearrange_recent
-----------------------
    Customizes rearrangement of spaces based on recency.

    Values:
        - bool [default: true]

spaces_span_displays
--------------------
    Customizes spaces separation of different displays.

    .. note::

        Needs a logout to apply.

    Values:
        - bool [default: false]

spaces_switch_running
---------------------
    Customizes switching of spaces when clicking a running app icon in the Dock (switch vs new window).

    Values:
        - bool [default: true]

tab_preference
--------------
    Customizes global preference for tabs.

    Values:
        - string [default: fullscreen]

            * manual
            * fullscreen
            * always
