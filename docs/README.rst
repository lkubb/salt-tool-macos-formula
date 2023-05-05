.. _readme:

macOS Configuration Formula
===========================

Configures MacOS. This formula is a collection of knowledge I collected or discovered. It is intended as both documentation and to provide automation. Many of the options in MacOS are poorly documented and change frequently and without notice. This is my attempt to mitigate a small part of that (especially **for macOS Monterey**).

Please be aware that this formula reaches deeply into your system and is to be considered highly experimental. Use it as you see fit. Things are probably going to be fine, but there are no warranties.

.. contents:: **Table of Contents**
   :depth: 1

Usage
-----
Applying ``tool_macos`` will make sure MacOS is configured as specified.

To manage defaults for sandboxed applications (like Mail, Messages), your terminal emulator will need **Full Disk Access** (grant it in System Preferences -> Security & Privacy). This is also true for Time Machine configuration and some other protected files.

Execution and state module
~~~~~~~~~~~~~~~~~~~~~~~~~~
This formula provides several execution modules and states to manage ``defaults``, profiles and power management settings as well as default handlers for files and URL schemes. The functions are self-explanatory, please see the source code or the rendered docs at :ref:`execution_modules:` and :ref:`state_modules`.

Some of them are patched variants of modules written by other people, mostly `mosen <https://github.com/mosen/salt-osx>`_ in particular (``macprofile``, afaik he is also the original author of the official ``macdefaults`` modules). They were either not working on modern systems (profile installation cannot be done non-interactively without being enrolled in an MDM anymore) or lacking features I needed (e.g. ``defaults -currentHost``).

Configuration
-------------
The options described below are organized as I saw fit. If you don't understand something or want further information, look in ``docs/settings`` or the state source files. The state files that apply the settings are laid out exactly like the option dictionary.

Performance
~~~~~~~~~~~
This formula bends Salt quite a bit. It also features an exorbitant amount of atomic state files that are always rendered during every run. Since Salt currently `has some caching issues <https://github.com/saltstack/salt/issues/39017>`_ regarding Jinja variables, it was necessary to introduce a workaround to avoid excessive rendering times.

This workaround requires to have access to a pillar dictionary found at ``tool_macos``. It can be empty if you so desire, just has to be there. In case you do all your configuration in fileserver YAML files, make sure to **include** ``tool_macos: {}`` **in your pillar**, otherwise your system might go for an extended run on an imaginary hamster wheel while you are sitting there reconsidering your life choices.

This formula
~~~~~~~~~~~~
The general configuration structure is in line with all other formulae from the `tool` suite, for details see :ref:`toolsuite`. An example pillar is provided, see :ref:`pillar.example`. Note that you do not need to specify everything by pillar. Often, it's much easier and less resource-heavy to use the ``parameters/<grain>/<value>.yaml`` files for non-sensitive settings. The underlying logic is explained in :ref:`map.jinja`.

User-specific
^^^^^^^^^^^^^
The following shows an example of ``tool_macos`` per-user configuration. If provided by pillar, namespace it to ``tool_global:users`` and/or ``tool_macos:users``. For the ``parameters`` YAML file variant, it needs to be nested under a ``values`` parent key. The YAML files are expected to be found in

1. ``salt://tool_macos/parameters/<grain>/<value>.yaml`` or
2. ``salt://tool_global/parameters/<grain>/<value>.yaml``.

.. code-block:: yaml

  user:

      # Persist environment variables used by this formula for this
      # user to this file (will be appended to a file relative to $HOME)
    persistenv: '.config/zsh/zshenv'

      # Add runcom hooks specific to this formula to this file
      # for this user (will be appended to a file relative to $HOME)
    rchook: '.config/zsh/zshrc'

      # This user's configuration for this formula. Will be overridden by
      # user-specific configuration in `tool_macos:users`.
      # Set this to `false` to disable configuration for this user.
    macos:
      animations:
          # False to disable, or dict: {on: float, off: float} for periods
        cursor_blinking:
          'off': 1.5
          'on': 1.5
          # Enable/disable app icons bouncing when needing attention.
        dock_bounce: true
        dock_launch: true
          # genie, scale, suck
        dock_minimize: genie
          # This mostly affects the `File Info` dialog.
        finder_windows: true
          # Focus ring blend-in animation.
        focus_ring: true
          # New window animations in MacOS.
        macos_windows: true
          # Mission Control animation time (float).
        mission_control: 0.5
          # `reduce motions` in `Accessibility`.
          # E.g. changes space swiping to fade.
        motion_reduced: false
        multidisplay_swoosh: true
        window_resize_time: 0.5
      apps:
        messages:
          read_receipts: true
      audio:
        charging_sound: true
          # Basso, Blow, Bottle, Frog, Funk, Glass, Hero, Morse, Ping,
          # Pop, Purr, Sosumi, Submarine, Tink
        sound_effect_alert: Tink
          # Sound effect volume in parts of current output volume. 0.5 = 50% etc.
        sound_effect_volume: 1
        sound_effect_volumechange: false
          # This only affects macOS, not apps.
        sound_effects_system: true
          # This is the global default for any app.
        sound_effects_ui: true
          # Spatial audio follows head movements.
        spatial_follow_head: true
        # Default "background/magic" behavior. Find UI/UX in uix.
      behavior:
          # Default behavior: silently save changes and exit.
          # Set to true to force prompts.
        confirm_on_close: false
        crashreporter: true
          # Controls whether `Feedback Assistant` autogathers large files.
        feedback_assistant_autogather: true
        handoff_allow: true
        help_window_floats: true
          # Controls what happens when media was inserted.
          # Can be str [ignore / ask / finder / itunes / disk_utility]
          # to control all or dict for specific types.
        media_inserted:
          blank_cd: ask
          blank_dvd: ask
          music: itunes
          picture: ask
          video: ask
          # `Mission Control groups windows by application`
        mission_control_grouping: true
          # Display time for notifications in seconds.
        notification_display_time: 5
          # Photos app is launched automatically when iPhone is plugged in.
        photos_hotplug: true
          # Controls the behavior when the power button is pressed.
          # true = power button induces sleep, false = prompt what to do
        power_button_sleep: true
          # Controls the default state of the print panel.
        print_panel_expanded: false
          # Automatically quit print app when all jobs are finished.
        printqueue_autoquit: false
          # By default, recreate previously open windows.
        resume_app: true
          # Controls the default state of the save panel.
        save_panel_expanded: false
          # `Automatically rearrange spaces based on recent usage`
        spaces_rearrange_recent: true
        spaces_span_displays: false
          # When clicking a running app in the Dock, switch to a containing workspace.
        spaces_switch_running: true
          # Generally prefer tabs to windows:
          #     manual, fullscreen or always
        tab_preference: fullscreen
      display:
          # false = disabled (default), true = enabled
        antialias_subpixel: false
          # Threshold for enabling antialiasing (font size in pixels).
        antialias_threshold: 4
          # disabled(0) / light(1) /medium(2) / heavy(3)
        font_smoothing: medium
        nightshift:
          enabled: true
          schedule:
            # 'HH:mm' or HH
            # Make sure to quote the former to stop YAML from doing weird stuff.
            # Why is 22:15 = 1335?
            end: '13:37'
            start: 3
            # 2700-6000
          temperature: 4100
        truetone: true
      dock:
        autohide:
          delay: 0.5
          enabled: false
          time: 0.5
        hint_hidden: false
        hint_running: true
        magnification:
          enabled: false
          size: 128
        minimize_to_icon: true
          # Persistent Dock tiles. `false` for running apps only.
        persistent_tiles: true
          # Dock position: bottom, left, right
        position: bottom
        recently_opened: true
        scroll_to_open: false
          # Single-app mode: Launching from dock hides all other apps.
        single_app: false
        size:
          immutable: false
          tiles: 48
        spring_loading: false
        stack_hover: false
        tiles:
          apps:
                # Paths can be specified, type will be autodetected.
            - /Applications/TextEdit.app
              # Empty items are small-spacer[s].
            -
              # This is the verbose variant for app definition.
                # The label will otherwise equal the app name without .app.
            - label: Sublime
              path: /Applications/Sublime Text.app
              type: file
                # Add different spacers with [small-/flex-]spacer.
            - small-spacer
            - label: FF
                # The type will be autodetected as above.
              path: /Applications/Firefox.app
          others:
                # Sort by: name / added / modified / created / kind
            - arrangement: added
                # View items as `stack` or `folder`.
              displayas: stack
                # The label would be set to `Downloads` otherwise.
              label: DL
              path: /Users/user/Downloads
                # Layout: auto / fan / grid / list.
              showas: grid
                # The type will be autodetected as well.
              type: directory
            - spacer
                # Defaults: sort by added, display as stack,
                #           layout auto. Label: Documents.
            - /Users/user/Documents
            - flex-spacer
                # URL can be added as well.
            - https://www.github.com
            # Don't append, make it exactly like specified.
            # Note: Currently forced to `true`.
          sync: true
      files:
        default_handlers:
            # File extensions will be automatically resolved to all associated UTI.
            # Handlers can be specified by name, bundle ID or absolute path.
          extensions:
            csv: Sublime Text
            html: Firefox
          schemes:
              # This will set https as well, a user prompt is shown for confirmation.
            http: org.mozilla.Firefox
            ipfs: /Applications/Brave Browser.app
            torrent: Transmission
          utis:
            public.plain-text: TextEdit
          # Avoid cluttering usb / network / all [= both types] / none
          # mounts with .DS_Store files.
        dsstore_avoid: all
          # Default location of "Save as...". iCloud vs local.
        save_icloud: true
        screenshots:
          basename: custom_prefix
            # Image format: png / bmp / gif / jp(e)g / pdf / tiff
          format: png
            # Whether to show the cursor in screenshots.
          include_cursor: false
            # Whether to include date in the filename.
          include_date: true
            # Default: ~/Desktop. Needs absolute path!
          location: /Users/h4xx0r/screenshots
            # Actually called `dropshadow`.
          shadow: true
            # Show floating thumbnail.
          thumbnail: true
      finder:
          # Enable AirDrop over Ethernet and on unsupported Macs.
        airdrop_extended: false
        desktop_icons:
            # Arrange icons automatically by:
            #   none, grid, name, kind, last_opened, added,
            #   modified, created, size, tags
          arrange: grid
          info: false
          info_bottom: true
          show: true
          size: 64
          spacing: 54
          text_size: 12
        dmg_verify: true
        fileinfo_popup:
          comments: false
          metadata: true
          name: false
          openwith: true
          privileges: true
        folders_on_top: false
          # New finder windows open at:
          #   computer / volume / home / desktop / documents / </my/custom/path>
        home: recent
          # Open a new window on mount of volume of type.
        new_window_on_mount:
          - ro
          - rw
          - disk
        pathbar_home_is_root: false
        prefer_tabs: true
          # Finder can be quit => no desktop icons shown.
        quittable: false
          # Finder searches by default relative to
          #   mac, current, previous
        search_scope_default: mac
          # Show external HDD on the desktop.
        show_ext_hdd: true
        show_extensions: false
          # Show hidden files.
        show_hidden: false
          # Show internal HDD on the desktop.
        show_int_hdd: false
        show_library: false
          # Show mounted NAS drives on the desktop.
        show_nas: true
        show_pathbar: false
          # Open folder when dragging file on top.
        spring_loading:
          delay: 0.5
          enabled: true
          # Delay on hover for proxy icons to show up.
        title_hover_delay: 0.5
          # Show full POSIX path in window title.
        title_path: false
          # Remove items older than 30 days automatically from trash.
        trash_old_auto: true
        view:
          column:
              # By default, sort items by
              #   none, name, kind, last_opened, added, modified, created, size, tags
            arrange: name
            col_width: 245
            folder_arrow: true
            icons: true
            preview: true
            preview_disclosure: true
            shared_arrange: kind
            text_size: 13
            thumbnails: true
          gallery:
              # By default, sort items by
              #   none, name, kind, last_opened, added, modified, created, size, tags
            arrange: name
            icon_size: 48
            preview: true
            preview_pane: true
            titles: false
          icon:
              # By default, sort items by
              #   none, name, grid, kind, last_opened, added,
              #   modified, created, size, tags
            arrange: grid
            info: false
            info_bottom: true
            size: 64
            spacing: 54
            text_size: 12
          list:
            calc_all_sizes: false
            icon_size: 16
            preview: true
            relative_dates: true
              # By default, sort rows by
              #   name, kind, last_opened, added, modified, created, size, tags
            sort_col: name
            text_size: 13
          preferred:
              # By default, automatically group by:
              #   name, app, kind, last_opened, added, modified, created, size, tags
            groupby: none
              # By default, open Finder folders with layout set as
              #   icon / list / gallery / column [coverflow deprecated]
            style: icon
          # Show warning when changing a file extension.
        warn_on_extchange: true
          # Show warning when removing files from iCloud Drive.
        warn_on_icloud_remove: true
          # Show warning when emptying the trash.
        warn_on_trash: true
      keyboard:
          # Fn triggers:
          #   none, dictation, emoji, input_source
        fn_action: none
          # Use function keys as standard function keys instead of system keys
          # by default. Press Fn + F1-12 to trigger system actions.
        function_keys_standard: false
      localization:
          # `12h` or `24h`. This forces the format, regardless of locale.
        force_124h: 24h
          # List of active system languages. `name-country` separated by dash.
        languages:
          - en-US
          - en-NZ
          # Show measurements in
          #   metric, US, UK
        measurements: metric
        # Customize Mail.app. Note that your terminal application
        # needs Full Disk Access for this to work.
      mail:
          # Those accounts will be installed interactively (as profile).
        accounts:
          - address: elliotalderson@protonmail.ch
              # Account description. Default: <address>
            description: dox
              # Name shown as sender. Default: <username portion of address>
            name: Elliot
              # Incoming mailserver settings.
            server_in:
                # IMAP/POP authentication type is
                #   none, password, crammd5, ntlm, httpmd5
              auth: password
              domain: 127.0.0.1
                # IMAP/POP port on the server. Default: 993
              port: 1143
              ssl: true
                # Username for IMAP/POP auth. Default: <address>
              username: elliotalderson@protonmail.ch
            server_out:
                # SMTP authentication type is
                #   none, password, crammd5, ntlm, httpmd5
              auth: password
              domain: 127.0.0.1
                # Use the same password as for IMAP/POP and SMTP.
              password_sameas_in: true
                # SMTP port on the server. Default: 465
              port: 1025
              ssl: true
                # Username for SMTP auth. Default: <address>
              username: elliotalderson@protonmail.ch
              # The protocol used by the MUA for this account:
              #   imap, pop
            type: imap
          # Whether to animate sending replies.
        animation_reply: true
          # Whether to animate sending messages.
        animation_sent: true
          # Whether to show attachments inline.
        attachments_inline: true
          # Suppress warning on fail, silently try later again.
        auto_resend_later: true
          # Whether to mark all messages as read when viewing conversation.
        conv_mark_all_read: true
          # Whether to display the latest message on top (sort asc/desc).
        conv_most_recent_top: true
          # Unread count in dock depends on
          #   inbox / all
        dock_unread_count: inbox
          # Delete unedited attachments on: never, app_quit, message_deleted
        downloads_remove: when_deleted
          # Automatically match format when replying (HTML vs plaintext)
        format_match_reply: true
          # Prefer sending messages in
          #   rich / plain
        format_preferred: rich
          # Highlight conversations with color when not grouped.
        highlight_related: true
          # Whether to include names when copying mail addresses.
        include_names_oncopy: true
          # Include related messages.
        include_related: true
          # Show notification when a new message is received in / from:
          #   inbox, vips, contacts, all
        new_message_notifications: inbox
          # '' to disable, else see `audio.sound_effect_alert`.
        new_message_sound: New Mail
          # Poll for new mesages:
          #   auto, manual or int [minutes between polls]
        poll: auto
          # Whether to load remote content in mails automatically.
        remote_content: true
        respond_with_quote: true
          # Set custom shortcut to send message. E.g., this is Cmd + Enter.
        shortcut_send: '@\U21a9'
          # Show unread messages in bold font.
        unread_bold: false
          # This is different from highlight_related.
        view_conversations_highlight: true
        view_date_time: false
          # Preview messages in split view when in fullscreen mode.
        view_fullscreen_split: true
          # Display message sizes in overview.
        view_message_size: false
        view_threaded: true
      menubar:
        accessibility:
          control: false
          menu: false
        airdrop: false
        autohide_desktop: false
        autohide_fullscreen: true
        battery:
          control: false
          menu: true
          percentage: false
        bluetooth: false
        clock:
          analog: false
          flash_seconds: false
          format: EEE HH:mm
        display: when_active
        focus: when_active
        keyboard_brightness: false
        now_playing: when_active
        screen_mirroring: when_active
        siri: true
          # Show sound icon: true, false, when_active
        sound: when_active
        spotlight: false
        timemachine: false
        userswitcher:
          control: false
          menu: false
            # Userswitcher shows:
            #   icon, username, fullname
          menu_show: icon
        wifi: true
      performance:
        app_nap: true
        auto_termination: true
        screensaver:
            # Seconds of inactivity until screensaver starts. 0 to disable.
          after: 300
            # Show clock with screensaver.
          clock: false
      privacy:
        allow_targeted_ads: true
        siri_share_recordings: false
      security:
        airdrop: true
          # Require password after sleep.
          # This is sadly deprecated and would
          # need to install a profile to be supported still.
        password_after_sleep:
          delay: 0
          require: true
        password_hint_after: 3
          # Fun fact: MacOS keeps a log of all downloaded files ever.
        quarantine_logs:
            # Enable this to clear logs during the salt run.
          clear: false
            # Disable this to prevent keeping logs at all.
          enabled: true
          # Allows to hide this user from login window
          # and public share points as well as his home dir from Finder.
        user_hidden: false
          # Remove this user from FileVault. Cannot be added back automatically.
        user_no_filevault: false
        # User-specific services management.
        # (system-wide is available in formula config)
      services:
          # List of Login Items to disable.
        unwanted:
          - com.spotify.client.startuphelper
          # List of Login Items to enable.
        wanted:
          - com.raycast.macos.RaycastLauncher
      siri:
          # Mind that toggling this setting via System Preferences does much more.
        enabled: false
          # Trigger siri with
          #   default (=off/hold microphone key), cmd_space, opt_space, fn_space
        keyboard_shortcut: default
          # Locale as shown.
        language: en-US
        voice_feedback: true
        voice_variety:
            # Accent
          language: en-AU
            # The speaker's name.
          speaker: gordon
      textinput:
        autocapitalization: true
        autocorrection: true
        dictation: false
          # Trigger alternative chars when long-pressing keys.
          # Disable this for faster key repeats.
        press_and_hold: true
        repeat:
          delay: 10
          rate: 1
        slow_keys: false
        smart_dashes: true
        smart_periods: true
        smart_quotes: true
        # Touch gesture configuration is a bit weird regarding three finger gestures.
        # [three finger] drag and swipe_pages, when set to three [fingers] or
        # both [two and three], need both axes, so app_expose_mission_control and
        # swipe_fullscreen need to be four [fingers] or disabled.
        # You will be warned about misconfiguration, but that might result in an unknown state.
        # Also note that currently, these settings will only be applied after a
        # reboot. I'm working on an execution module to be able to set those on the fly.
      touch:
          # Enable/disable App Exposé gesture.
        app_expose: true
          # App Expose and Mission Control gestures use
          # `three` [fingers], `four` or false (disabled)
        app_expose_mission_control: three
        drag: false
        force_click: true
        haptic_feedback_click: true
          # low (=light) / medium / high (=firm)
        haptic_resistance_click: medium
          # Enable/disable Launchpad pinch gesture.
        launchpad: true
          # Trigger lookup:
          #   true [force click] / three [finger tap] / false
        lookup: true
          # Enable/disable Mission Control gesture.
        mission_control: true
        natural_scrolling: true
        notification_center: true
        rotate: true
          # Enable secondary click with
          #   false, two [fingers], corner-right [bottom], corner-left [bottom] click
        secondary_click: two
          # Enable/disable Show Desktop pinch gesture.
        show_desktop: true
        smart_zoom: true
          # Swiping fullscreen apps/workspaces requires
          # three [fingers] / four / false
        swipe_fullscreen: three
          # Swiping pages requires
          #   two [finger scroll], three, both or false
        swipe_pages: two
        tap_to_click: false
          # Trackpad acceleration: 0-3 [float]
        tracking_speed: 1
        zoom: true
        # UI / UX with user input. Default background behaviors in behavior.
      uix:
        colors:
            # MacOS accent color:
            #   multi, blue, purple, pink, red, orange, yellow, green, graphite
          accent: multi
            # MacOS highlight color:
            #   accent_color, blue, purple, pink, red, orange,
            #   yellow, green, graphite
          highlight: accent_color
            # Action triggered when doubleclicking a window title:
            #   `maximize` / `'none'` (f yaml), `minimize`
        doubleclick_title: maximize
          # Hot corner configuration. If no modifier, can be just a string per corner.
        hot_corners:
          bottom_left:
              # Action can be 'none', mission-control, app-windows, desktop,
              # screensaver, stop-screensaver, displaysleep, launchpad,
              # notification-center, lock-screen, quick-note
            action: screensaver
              # Modifier can be 'none', shift, ctrl, opt, cmd.
            modifier: none
          bottom_right:
            action: stop-screensaver
            modifier: shift
          top_left: none
          top_right: notification-center
        live_text: true
          # Locate the pointer by shaking it.
        locate_pointer: false
          # true: Jump to spot that was clicked. false: Go to next page.
        scrollbar_jump_click: false
          # Show scroll bars
          #   always, automatic, when_scrolling
        scrollbars_visibility: automatic
          # Sidebar icon size: small, medium, large
        sidebar_iconsize: medium
          # List of items to enable in the Spotlight index. The rest is disabled.
        spotlight_index:
          - applications
          - bookmarks-history
          - calculator
          - contacts
          - conversion
          - definition
          - developer
          - documents
          - events-reminders
          - folders
          - fonts
          - images
          - mail-messages
          - movies
          - music
          - other
          - pdf
          - presentations
          - siri
          - spreadsheets
          - system-preferences
          # Use tab to cycle through UI elements (~ full keyboard access).
        tab_ui_elements: false
          # System theme: auto, dark, light
        theme: light
          # Show outlines around toolbar buttons (from Accessibility).
        toolbar_button_shapes: false
        transparency_reduced: false
          # Windows are tinted in the wallpaper median color.
        wallpaper_tinting: true
          # Customize UI zooming (from Accessibility).
          # If you want to leave defaults, can be boolean instead of mapping.
        zoom_scroll_ui:
            # Enable/disable zoom UI by scrolling with modifier feature.
          enabled: false
            # Follow keyboard focus:
            #   never, always, when_typing
          follow_keyboard_focus: never
            # Modifier to trigger this behavior: ctrl, opt, cmd
          modifier: ctrl
            # Zoom: full, split, in_picture
          zoom_mode: full

Formula-specific
^^^^^^^^^^^^^^^^
These are macOS system-wide preferences that need to run as root.

.. code-block:: yaml

  tool_macos:

    audio:
      boot_sound: false
      devices:
        device.AppleUSBAudioEngine:Native Instruments:Komplete Audio 6 MK2:ABCD1EF2:1,2:
          output.stereo.left: 5
          output.stereo.right: 6
    bluetooth:
      enabled: true
      enabled_airplane: true
      ignored:
        devices:
          - <MAC 1>
          - <MAC 2>
        sync: false
    finder:
        # Show/hide `/Volumes` folder.
      show_volumes: false
    keyboard:
      brightness_adjustment:
          # Dim keyboard brightness after x seconds of inactivity (0=disable).
        after: 0
          # Adjust keyboard brightness in low light.
        low_light: true
    localization:
        # This will be set as computer name, hostname, NetBIOS name.
      hostname: localmac
      timezone: GMT
      # Power settings for pmset per scope. Valid scopes: all, ac, battery, ups.
    power:
      all:
          # Wake when plugging in AC adapter.
        acwake: 0
          # Enable automatic poweroff (mostly the same as standby).
        autopoweroff: 0
          # Trigger autopoweroff after x seconds of inactivity.
        autopoweroffdelay: 0
          # Sleep the display after x minutes of inactivity.
        disksleep: 10
        displaysleep: 2
          # Dim the display instead of powering it off when display-sleeping.
        halfdim: 1
          # Which mode to use for hibernation:
          #   0   /     3      /      25
          # sleep / safe sleep / true hibernation for standby
        hibernatemode: 3
        highpowermode: 0
          # Threshold in percent for toggling standbydelayhigh/-low.
        highstandbythreshold: 50
          # Whether display max brightness is reduced. Works for `battery` scope.
        lessbright: 0
          # Whether to wake when opening the laptop lid.
        lidwake: 1
        lowpowermode: 0
        powermode: 0
        powernap: 1
        proximitywake: 0
        sleep: 1
          # Enable automatic sleep -> standby
        standby: 1
        standbydelayhigh: 86400
        standbydelaylow: 10800
        tcpkeepalive: 0
          # Prevent sleep when there is an active tty connection, even if it's remote.
        ttyskeepawake: 0
          # Wake on receiving an ethernet magic packet.
        womp: 0
      battery:
        lessbright: 1
    privacy:
        # Allow Crash Reporter to send reports to
        #   none, apple, third_party
      crashreporter_allow: apple
    security:
        # Automatically login a user after booting.
        #   false to disable, otherwise username
      autologin: false
      autoupdate:
          # Enable automatic updates.
        check: true
          # Automatically download updates.
        download: true
          # Automatically install App Store app updates.
        install_app: true
          # Automatically install (critical) config updates.
          # System Preferences combines this with critical.
        install_config: true
          # Automatically install critical system updates.
          # System Preferences combines this with config.
        install_critical: true
          # Automatically install MacOS updates.
        install_system: true
          # Check every i day(s) for updates. (might be deprecated)
        schedule: 1
        # List of custom CA root certificates (PEM) to install on the system
      ca_root: []
      captive_portal_detection: true
        # Load/unload cupsd service.
      cupsd: true
        # Automatically log in a user after authenticating with FileVault.
      filevault_autologin: true
      filevault_evict_keys_standby: false
      firewall:
          # Automatically allow incoming connections for Apple-signed binaries.
        apple_signed_ok: true
          # Automatically allow incoming connections for downloaded signed binaries.
        download_signed_ok: false
        enabled: true
          # Block all incoming connections.
        incoming_block: false
        logging: true
          # Ignore incoming ICMP + TCP/UDP packets to closed ports.
        stealth: false
      gatekeeper: true
      guest_account: false
      internet_sharing: false
        # Sets ipv6 automatic/off on all network interfaces. Debatable if sensible.
      ipv6: true
        # Send multicast DNS advertisements.
      mdns: true
      ntp:
          # Sync the system time using ntp.
        enabled: true
          # Specify ntp server to use.
        server: time.apple.com
      printer_sharing: false
      remote_apple_events: false
        # This setting only works to disable remote desktop connections.
      remote_desktop_disabled: true
        # State of SSH server.
      remote_login: false
      require_admin_for_system_settings: true
        # Disable/enable check if root user account is disabled.
        # Cannot modify the state.
      root_disabled_check: false
      sudo_touchid:
        enabled: false
          # pam_reattach might be required to make this work
          # with tmux and iTerm saved sessions
        pam_reattach: false
        # Wake on receiving magic ethernet package.
        # Enabled by default for AC actually.
        # More finegrained control: `womp` in power settings (`macos.power`).
        # This is mostly for disabling the feature.
      wake_on_lan: false
      # Global services management.
      # (user-specific available in user config)
    services:
        # List of Launch Items to disable.
      unwanted:
        - org.cups.cupsd
        # List of Launch Items to enable.
      wanted:
        - org.pqrs.karabiner.karabiner_observer
      # Time Machine configuration
      # needs Full Disk Access for your terminal emulator.
    timemachine:
      backup_on_battery: false
        # Disable this to suppress a TimeMachine popup
        # offering an unknown disk as backup target on mount.
      offer_new_disks: true
    uix:
        # Show language selection menu in login window.
      login_window_input_menu: true

      # Default formula configuration for all users.
    defaults:
      animations: default value for all users


Development
-----------

General Remarks
~~~~~~~~~~~~~~~
If you want to see for yourself which incantation results in your preferred changes, consider using `prefsniff <https://github.com/zcutlip/prefsniff>`_. It can run on a whole directory to see which files are changed (not recursive) and run on a specific file to generate the corresponding `defaults write` command. The usual suspect directories are:

- ``~/Library/Preferences``
- ``~/Library/Preferences/ByHost``
- ``/Library/Preferences``
- ``/var/root/Library/Preferences``

If you can't find the file, you might be dealing with a sandboxed application (look in ``~/Library/Containers``), it might persist the settings in another way (KMB) or use a Saved Application State (?). Running ``sudo fs_usage -f filesys <pid>`` might give another clue.

Contributing to this repo
~~~~~~~~~~~~~~~~~~~~~~~~~

Commit messages
^^^^^^^^^^^^^^^

Commit message formatting is significant.

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``.

.. code-block:: console

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

State documentation
~~~~~~~~~~~~~~~~~~~
There is a script that semi-autodocuments available states: ``bin/slsdoc``.

If a ``.sls`` file begins with a Jinja comment, it will dump that into the docs. It can be configured differently depending on the formula. See the script source code for details currently.

This means if you feel a state should be documented, make sure to write a comment explaining it.

Testing
~~~~~~~

Linux testing is done with ``kitchen-salt``. It follows follows there is none currently and anyone running this formula is a substitute for the missing tests.

Todo
----
- finish macsettings execution module to change difficult settings on the fly (esp. changing scrolling direction)
- incorporate some important settings, maybe in the form of a profile (screensaver config!)
- install arbitrary profiles
- finish adding all options from previous iteration
- add following system preferences settings:

  + Notifications & Focus (file: ``~/Library/Preferences/com.apple.ncprefs.plist``), example:

  .. code-block:: yaml

    - bundle-id: com.apple.iCal
      content_visibility: 0
      flags: 578822166
      grouping: 0
      path: /System/Applications/Calendar.app
      src:
        - flags: 6
              # the following is <data></data>, base64 encoded
              # 00000000: fade 0c00 0000 0034 0000 0001 0000 0006  .......4........
              # 00000010: 0000 0002 0000 0017 636f 6d2e 6170 706c  ........com.appl
              # 00000020: 652e 4361 6c65 6e64 6172 4167 656e 7400  e.CalendarAgent.
              # 00000030: 0000 0003
          req: +t4MAAAAADQAAAABAAAABgAAAAIAAAAXY29tLmFwcGxlLkNhbGVuZGFyQWdlbnQAAAAAAw==
          uuid: C99C2315-ACDB-4ABB-AE7F-0C81E7EE3DD9
        - flags: 6
              # 00000000: fade 0c00 0000 0048 0000 0001 0000 0006  .......H........
              # 00000010: 0000 0002 0000 002b 636f 6d2e 6170 706c  .......+com.appl
              # 00000020: 652e 4361 6c65 6e64 6172 4e6f 7469 6669  e.CalendarNotifi
              # 00000030: 6361 7469 6f6e 2e43 616c 4e43 5365 7276  cation.CalNCServ
              # 00000040: 6963 6500 0000 0003                      ice.....
          req: +t4MAAAAAEgAAAABAAAABgAAAAIAAAArY29tLmFwcGxlLkNhbGVuZGFyTm90aWZpY2F0aW9uLkNhbE5DU2VydmljZQAAAAAD
          uuid: A4C40B21-EA4B-42F0-B5E7-400EE0A78DCB

  + Login Items for users?
  + more from Accessibility (eg doubleclick speed)
  + Screen Time? probably not possible with plists at least
  + Share Menu (file: ``~/Library/Preferences/com.apple.preferences.extensions.ShareMenu.plist`` for displayOrder, a bunch of ``com.apple.preferences.extensions.*.plist`` for active/inactive)
  + Finder Extensions (file: ``~/Library/Preferences/pbs.plist`` FinderActive / FinderOrdering)
  + Keyboard shortcuts

References
----------
- https://shadowfile.inode.link/blog/2018/06/advanced-defaults1-usage/
- https://shadowfile.inode.link/blog/2018/08/defaults-non-obvious-locations/
- https://shadowfile.inode.link/blog/2018/08/autogenerating-defaults1-commands/
- https://github.com/joeyhoer/starter
- https://github.com/mathiasbynens/dotfiles/
- https://git.herrbischoff.com/awesome-macos-command-line/about/
- https://github.com/zcutlip/prefsniff
- https://github.com/mosen/salt-osx
- specific ones found in some of the state files

Interesting links
-----------------
- https://managingosx.wordpress.com/2015/02/05/accessing-more-frameworks-with-python-2/
- https://gist.github.com/pudquick/1362a8908be01e23041d
- https://github.com/robperc/FinderSidebarEditor
- https://michaellynn.github.io/2015/08/08/learn-you-a-better-pyobjc-bridgesupport-signature/
- https://github.com/colin-stubbs/salt-formula-macos
