# MacOS Configuration Formula
Configures MacOS. This formula is a collection of knowledge I collected or discovered. It is intended as both documentation and to provide automation. Many of the options in MacOS are poorly documented and change frequently and without notice. This is my attempt to mitigate a small part of that **for macOS Monterey**.

## Usage
Applying `tool-macos` will make sure MacOS is configured as specified.

To manage defaults for sandboxed applications (like Mail, Messages), your terminal emulator will need `Full Disk Access` (grant it in System Preferences -> Security & Privacy). This is also true for Time Machine configuration and some other protected files.

## Execution modules and states
This formula provides several execution modules and states to manage `defaults`, profiles and power management settings as well as default handlers for files and URL schemes.

## Docs
Documentation is currently found in doc/\_build/html.

## Configuration
### General Remarks
The options described below are organized as I saw fit. If you don't understand something or want to see further information, look inside the settings directory. The state files that apply the settings are laid out exactly like the option dictionary.

### Pillar
#### General `tool` architecture
Since installing user environments is not the primary use case for saltstack, the architecture is currently a bit awkward. All `tool` formulas assume running as root. There are three scopes of configuration:
1. per-user `tool`-specific [**irrelevant for this formula**]
  > e.g. generally force usage of XDG dirs in `tool` formulas for this user
2. per-user formula-specific [**user preferences**]
  > e.g. setup this tool with the following configuration values for this user
3. global formula-specific [**host-specific macOS preferences, ran as root**]. (All formulas will accept `defaults` for `users:username:formula` default values in this scope as well.)
  > e.g. setup system-wide configuration files like this

**3** goes into `tool:formula` (e.g. `tool:git`). Both user scopes (**1**+**2**) are mixed per user in `users`. `users` can be defined in `tool:users` and/or `tool:formula:users`, the latter taking precedence. (**1**) is namespaced directly under `username`, (**2**) is namespaced under `username: {formula: {}}`.

```yaml
tool:
######### user-scope 1+2 #########
  users:                         #
    username:                    #
      xdg: true                  #
      dotconfig: true            #
      formula:                   #
        config: value            #
####### user-scope 1+2 end #######
  formula:
    formulaspecificstuff:
      conf: val
    defaults:
      yetanotherconfig: somevalue
######### user-scope 1+2 #########
    users:                       #
      username:                  #
        xdg: false               #
        formula:                 #
          otherconfig: otherval  #
####### user-scope 1+2 end #######
```

#### User-specific
The following shows an example of `tool-macos` pillar configuration. Namespace it to `tool:users` and/or `tool:macos:users`.
```yaml
user:
  macos:
    animations:
      # cursor_blinking:            # false to disable, or dict: {on: float, off: float} for periods
      #   on: 1.5
      #   off: 1.5
      dock_bounce: true             # enable/disable app icons bouncing when needing attention
      dock_launch: true
      dock_minimize: genie          # or scale, suck
      finder_windows: true          # this mostly affects the File Info dialog.
      focus_ring: true              # focus ring blend-in animation
      macos_windows: true           # new window animations in MacOS
      mission_control: 0.5          # animation time (float)
      motion_reduced: false         # "reduce motions" in Accessibility. eg changes space swiping to fade
      multidisplay_swoosh: true
      window_resize_time: 0.5
    apps:
      messages:
        read_receipts: true
    audio:
      charging_sound: true
      sound_effects_system: true    # this only affects macOS
      sound_effects_ui: true        # this is global default for any app
      sound_effect_alert: Tink      # Basso, Blow, Bottle, Frog, Funk, Glass, Hero, Morse, Ping, Pop, Purr, Sosumi, Submarine, Tink
      sound_effect_volume: 1        # in parts of output volume. 0.5 = 50% etc
      sound_effect_volumechange: false
      spatial_follow_head: true     # spatial audio follows head movements
    behavior: # default "background" behavior. UI/UX in uix
      confirm_on_close: false       # default behavior: silently save changes and exit. true to prompt
      crashreporter: true
      feedback_assistant_autogather: true # whether Feedback Assistant autogathers large files
      handoff_allow: true
      help_window_floats: true
      media_inserted:               # str [ignore / ask / finder / itunes / disk_utility] or dict for specific
        blank_cd: ask
        blank_dvd: ask
        music: itunes
        picture: ask
        video: ask
      mission_control_grouping: true  # Mission Control groups windows by application
      notification_display_time: 5  # seconds
      photos_hotplug: true          # Photos app opens automatically when iPhone is plugged in
      power_button_sleep: true      # true = power button induces sleep, false = prompt what to do
      print_panel_expanded: false   # default state of print panel
      printqueue_autoquit: false    # automatically quit print app when all jobs are finished
      resume_app: true              # by default, recreate previously open windows
      save_panel_expanded: false    # default state of save panel
      spaces_rearrange_recent: true # rearrange spaces based on recent usage
      spaces_span_displays: false
      spaces_switch_running: true   # when clicking a running app in the Dock, switch to space with it
      tab_preference: fullscreen    # generally prefer tabs to windows: manual, fullscreen or always
    display:
      antialias_subpixel: false     # false = disabled (default), true = enabled
      antialias_threshold: 4        # font size in pixels
      font_smoothing: medium        # disabled(0) / light(1) /medium(2) / heavy(3)
      nightshift:
        enabled: true
        temperature: 4100           # 2700-6000
        schedule:
          # 'HH:mm' or HH
          # make sure to quote the former to stop yaml from doing weird stuff
          # why is 22:15 = 1335?
          start: 3
          end: '13:37'              # 'HH:mm' or HH
      truetone: true
    dock:
      autohide:
        enabled: false
        time: 0.5
        delay: 0.5
      hint_hidden: false
      hint_running: true
      magnification:
        enabled: false
        size: 128
      minimize_to_icon: true
      persistent_tiles: true        # false for only running apps
      position: bottom              # bottom, left, right
      recently_opened: true
      scroll_to_open: false
      single_app: false             # single-app mode: launch from dock, hide all others
      size:
        tiles: 48
        immutable: false
      spring_loading: false
      stack_hover: false
      tiles:
        sync: true # don't append, make it exactly like specified. currently forced to true
        apps:
          - /Applications/TextEdit.app  # paths can be specified, type will be autodetected
          -                             # empty items are small-spacer[s]
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
    files:
      default_handlers:
        # extensions will be automatically resolved to all associated UTI
        extensions:
          csv: Sublime Text             # handler can be specified by name, bundle ID or path
          html: Firefox
        schemes:
          http: org.mozilla.Firefox     # this will set https as well, user prompt is shown
          ipfs: /Applications/Brave Browser.app
          torrent: Transmission
        utis:
          public.plain-text: TextEdit
      dsstore_avoid: all                # usb / network / all [= both types] / none
      save_icloud: true                 # default location of "Save as...". iCloud vs local
      screenshots:
        basename: custom_prefix
        format: png                     # png / bmp / gif / jp(e)g / pdf / tiff
        include_date: true              # whether to include date in filename
        include_cursor: false           # whether to show cursor in screenshots
        location: /Users/h4xx0r/screenshots # default: $HOME/Desktop (absolute path)
        shadow: true                    # actually called dropshadow
        thumbnail: true                 # show floating thumbnail
    finder:
      airdrop_extended: false           # enable AirDrop on Ethernet and unsupported Macs
      desktop_icons:
        show: true
        arrange: grid # none, grid, name, kind, last_opened, added, modified, created, size, tags
        size: 64
        spacing: 54
        info: false
        info_bottom: true
        text_size: 12
      dmg_verify: true
      fileinfo_popup:
        comments: false
        metadata: true
        name: false
        openwith: true
        privileges: true
      folders_on_top: false
      home: recent # computer / volume / home / desktop / documents / </my/custom/path>
      new_window_on_mount: # finder opens a new window on volume mount. empty to disable all
        - ro
        - rw
        - disk
      pathbar_home_is_root: false
      prefer_tabs: true
      quittable: false                  # Finder can be quit
      search_scope_default: mac         # mac, current, previous
      show_ext_hdd: true                # show external HDD on desktop
      show_extensions: false
      show_hidden: false                # show hidden files
      show_int_hdd: false               # show internal HDD on desktop
      show_library: false
      show_nas: true                    # show mounted NAS drives on desktop
      show_pathbar: false
      spring_loading:                   # open folder when dragging file on top
        enabled: true
        delay: 0.5
      title_hover_delay: 0.5            # delay on hover for proxy icons to show up
      title_path: false                 # show full POSIX path in window title
      trash_old_auto: true     # remove items older than 30 days automatically from trash
      view:
        preferred:
          groupby: none # name, app, kind, last_opened, added, modified, created, size, tags
          style: icon                   # icon / list / gallery / column [coverflow deprecated]

        column:
          arrange: name # none, kind, last_opened, added, modified, created, size, tags
          col_width: 245
          folder_arrow: true
          icons: true
          preview: true
          preview_disclosure: true
          shared_arrange: kind
          text_size: 13
          thumbnails: true

        gallery:
          arrange: name # none, kind, last_opened, added, modified, created, size, tags
          icon_size: 48
          preview: true
          preview_pane: true
          titles: false

        icon:
          arrange: grid # none, name, kind, last_opened, added, modified, created, size, tags
          size: 64
          spacing: 54
          info: false
          info_bottom: true
          text_size: 12

        list:
          calc_all_sizes: false
          icon_size: 16
          preview: true
          sort_col: name  # name, kind, last_opened, added, modified, created, size, tags
          text_size: 13
          relative_dates: true
      warn_on_extchange: true           # warn when changing a file extension
      warn_on_icloud_remove: true       # warn when removing files from iCloud drive
      warn_on_trash: true               # warn when emptying trash
    keyboard:
      fn_action: none                   # none, dictation, emoji, input_source
      function_keys_standard: false     # use function keys as standard function keys by default
    localization:
      force_124h: 24h                   # 12h or 24h. possibility to force format.
      languages:                        # name-country separated with dash
        - en-US
        - en-NZ
      measurements: metric              # metric, US, UK
    # customize Mail.app. note that your terminal application needs Full Disk Access for this to work
    mail:
      accounts:                         # those accounts will be installed interactively (profile)
        - address: elliotalderson@protonmail.ch
          description: dox              # default: address
          name: Elliot                  # default: <username portion of address>
          type: imap                    # imap, pop
          server_in:
            auth: password              # none, password, crammd5, ntlm, httpmd5
            username: elliotalderson@protonmail.ch    # default: address
            domain: 127.0.0.1
            port: 1143                  # default: 993
            ssl: true
          server_out:
            auth: password              # none, password, crammd5, ntlm, httpmd5
            username: elliotalderson@protonmail.ch    # default: address
            domain: 127.0.0.1
            port: 1025                  # default: 465
            ssl: true
            password_sameas_in: true
      animation_reply: true             # whether to animate sending replies
      animation_sent: true              # whether to animate sending messages
      attachments_inline: true          # whether to show attachments inline
      auto_resend_later: true           # suppress warning on fail, silently try later again
      conv_mark_all_read: true          # whether to mark all messages as read when viewing conversation
      conv_most_recent_top: true        # whether to display the latest message on top (sort asc/desc)
      dock_unread_count: inbox          # inbox or all
      downloads_remove: when_deleted    # delete unedited attachments: never, app_quit, message_deleted
      format_match_reply: true          # automatically match format when replying
      format_preferred: rich            # rich / plain. prefer sending messages in that format
      highlight_related: true           # highlight conversations with color when not grouped
      include_related: true             # Include related messages
      include_names_oncopy: true        # whether to include names when copying mail addresses
      new_message_notifications: inbox  # inbox, vips, contacts, all
      new_message_sound: New Mail       # '' to disable, else see audio.sound_effect_alert
      poll: auto                        # auto, manual or int [minutes between polls]
      remote_content: true              # whether to load remote content in mails
      respond_with_quote: true
      shortcut_send: '@\U21a9'          # set custom shortcut to send message. this is Cmd + Enter e.g.
      unread_bold: false                # show unread messages in bold font
      view_conversations_highlight: true  # this is different from highlight_related
      view_date_time: false
      view_fullscreen_split: true       # preview messages in split view when fullscreen
      view_message_size: false          # display message size in overview
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
        format: 'EEE HH:mm'
      display: when_active
      focus: when_active
      keyboard_brightness: false
      now_playing: when_active
      screen_mirroring: when_active
      siri: true
      sound: when_active                # true, false, when_active
      spotlight: false
      timemachine: false
      userswitcher:
        control: false
        menu: false
        menu_show: icon                 # icon, username, fullname
      wifi: true
    performance:
      app_nap: true
      auto_termination: true
      screensaver:
        after: 300            # seconds. 0 to disable
        clock: false          # show clock with screensaver
    privacy:
      allow_targeted_ads: true
      siri_share_recordings: false
    security:
      airdrop: true
      # password_after_sleep:           # this is sadly deprecated and would need a
      #   require: true                 # profile to be supported still
      #   delay: 0
      password_hint_after: 3  # 0 to disable
      quarantine_logs:                  # MacOS keeps a log of all downloaded files
        clear: false                    # enable this to clear logs
        enabled: true                   # disable this to prevent keeping logs
      user_hidden: false                # allows to hide this user from login window,
                                        # and public share points as well as his home dir
      user_no_filevault: false          # remove this user from FileVault. cannot add back in
                                        # automatically
    siri:
      enabled: false                    # mind that toggling this setting via sys prefs does much more
      keyboard_shortcut: default        # (=off/hold microphone key), cmd_space, opt_space, fn_space
      language: en-US                   # locale as shown
      voice_feedback: true
      voice_variety:                    # customize variety
        language: en-AU                 # accent
        speaker: gordon                 # the speaker's name
    textinput:
      autocapitalization: true
      autocorrection: true
      dictation: false
      press_and_hold: true              # disable this for faster key repeats
      repeat:
        rate: 10
        delay: 1
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
      app_expose: true                  # enable/disable App Exposé gesture
      app_expose_mission_control: three # three [fingers], four or false for both gestures
      drag: false                       # three finger drag
      force_click: true
      haptic_feedback_click: true
      haptic_resistance_click: medium   # low (=light) / medium / high (=firm)
      launchpad: true                   # enable/disable Launchpad pinch gesture
      lookup: true                      # true [force click] / three [finger tap] / false
      mission_control: true             # enable/disable Mission Control gesture
      natural_scrolling: true
      notification_center: true
      rotate: true
      secondary_click: two              # false, two [fingers], corner-right [bottom], corner-left [bottom]
      show_desktop: true                # enable/disable Show Desktop pinch gesture
      smart_zoom: true
      swipe_fullscreen: three           # three [fingers] / four / false
      swipe_pages: two                  # two [finger scroll], three, both or false
      tap_to_click: false
      tracking_speed: 1                 # 0-3, is float
      zoom: true
    uix: # UI / UX with user input. default behaviors in behavior
      colors:
        accent: multi # blue, purple, pink, red, orange, yellow, green, graphite
        highlight: accent_color # blue, purple, pink, red, orange, yellow, green, graphite
      doubleclick_title: maximize       # or 'none', minimize. action when doubleclicking a window's title
      hot_corners:                      # hot corner configuration. if no modifier, can be just str per corner
        # action can be 'none', mission-control, app-windows, desktop, screensaver, stop-screensaver,
        # displaysleep, launchpad, notification-center, lock-screen, quick-note
        top_left: 'none' # mind the '' - yaml things
        top_right: notification-center
        bottom_left:
          action: screensaver
          # modifier can be 'none', shift, ctrl, opt, cmd
          modifier: 'none' # mind the '' - yaml things
        bottom_right:
          action: stop-screensaver
          modifier: shift
      live_text: true
      locate_pointer: false             # locate the pointer by shaking it
      scrollbar_jump_click: false       # true: jump to spot that was clicked. false: next page
      scrollbars_visibility: automatic  # always, automatic, when_scrolling
      sidebar_iconsize: medium          # small, medium, large
      spotlight_index:                  # list of items to enable in spotlight index. rest is disabled
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
      tab_ui_elements: false            # use tab to cycle through UI elements (~ full keyboard access)
      theme: light                      # auto, dark, light
      transparency_reduced: false
      toolbar_button_shapes: false      # outlines around toolbar buttons (Accessibility)
      wallpaper_tinting: true           # windows are tinted in the wallpaper median color
      zoom_scroll_ui:                   # if you want to leave defaults, can be boolean instead of mapping
        enabled: false                  # enable/disable zoom UI by scrolling with modifier feature
        modifier: ctrl                  # ctrl, opt, cmd
        zoom_mode: full                 # full, split, in_picture
        follow_keyboard_focus: never    # never, always, when_typing
```

#### Formula-specific
These are macOS system-wide preferences that need to run as root.
```yaml
tool:
  macos:
    audio:
      boot_sound: false
      devices:
        "device.AppleUSBAudioEngine:Native Instruments:Komplete Audio 6 MK2:ABCD1EF2:1,2":
          output.stereo.left: 5
          output.stereo.right: 6
    bluetooth:
      enabled: true
      enabled_airplane: true
      ignored:
        sync: false
        devices:
          - <MAC 1>
          - <MAC 2>
    finder:
      show_volumes: false               # show/hide /Volumes folder
    keyboard:
      brightness_adjustment:
        low_light: true                 # adjust keyboard brightness in low light
        after: 0                        # dim keyboard brightness after x seconds of inactivity (0=disable)
    localization:
      hostname: localmac                # this will be set as computer name, hostname, NetBIOS name
      timezone: GMT
    power: # power settings for pmset per scope. valid scopes: all, ac, battery, ups
      all:
        hibernatemode: 3 # 0 / 3 / 25 sleep / safe sleep / true hibernation for standby
        acwake: 0  # wake when plugging ac in
        autopoweroff: 0  # enable automatic poweroff (mostly the same as standby)
        autopoweroffdelay: 0 # [in seconds]
        disksleep: 10
        displaysleep: 2
        halfdim: 1  # displaysleep means less bright instead of fully off
        highpowermode: 0 # ?
        highstandbythreshold: 50  # threshold in percent for toggling standbydelayhigh/low
        lessbright: 0 # whether display max brightness is lowered
        lidwake: 1  # whether to wake when opening lid
        lowpowermode: 0 # ?
        powermode: 0 # ?
        powernap: 1
        proximitywake: 0
        sleep: 1
        standby: 1  # enable automatic sleep -> standby
        standbydelayhigh: 86400
        standbydelaylow: 10800
        tcpkeepalive: 0 # ?
        ttyskeepawake: 0  # prevent sleep when active tty connection, even remote
        womp: 0  # wake on ethernet magic packet
      battery: # different scope
        lessbright: 1
    privacy:
      crashreporter_allow: apple        # none, apple, third_party
    security:
      autologin: false                  # false to disable, otherwise username
      autoupdate:
        check: true                     # enable automatic updates
        download: true                  # automatically download updates
        install_app: true               # App Store app updates
        install_config: true            # System Preferences combines this with critical
        install_critical: true          # System Preferences combines this with config
        install_system: true            # MacOS updates
        schedule: 1                     # check every i day(s)
      captive_portal_detection: true
      cupsd: true                       # load/unload cupsd
      filevault_autologin: true         # automatically log in user when filevault is enabled
      filevault_evict_keys_standby: false
      firewall:
        # automatically allow incoming connections for Apple-signed binaries
        apple_signed_ok: true
        # automatically allow incoming connections for downloaded signed binaries
        download_signed_ok: false
        enabled: true
        incoming_block: false           # block all incoming connections
        logging: true
        stealth: false                  # ignore incoming ICMP + TCP/UDP to closed ports
      gatekeeper: true
      guest_account: false
      internet_sharing: false
      ipv6: true    # sets ipv6 automatic/off on all network interfaces. debatable if sensible
      mdns: true                        # send multicast DNS advertisements
      ntp:
        enabled: true                   # sync time using ntp
        server: time.apple.com          # specify ntp server
      printer_sharing: false
      remote_apple_events: false
      require_admin_for_system_settings: true
      remote_desktop_disabled: true     # this setting only works to disable
      remote_login: false               # state of SSH server
      root_disabled_check: false        # disable/enable check if root user account is disabled
      # allow sudo auth with Touch ID
      sudo_touchid:
        enabled: false
        # pam_reattach might be required to make this work with tmux and iTerm saved sessions
        pam_reattach: false
#     wake_on_lan: false                # enabled by default for ac actually. fine-grained
                                        # settings in macos.power. this is mostly for disabling
    # Time Machine configuration needs Full Disk Access for your terminal emulator.
    timemachine:
      backup_on_battery: false
      offer_new_disks: true             # disable this to suppress TimeMachine popup
                                        # offering an unknown disk as backup target
    uix:
      login_window_input_menu: true     # show language selection menu in login window

    defaults: {}                        # default formula user configurations for all users
```

## Remarks
If you want to see for yourself which incantation results in your preferred changes, consider using [prefsniff](https://github.com/zcutlip/prefsniff). It can run on a whole directory to see which files are changed (not recursive) and run on a specific file to generate the corresponding `defaults write` command. The usual suspect directories are:
  - `~/Library/Preferences`
  - `~/Library/Preferences/ByHost`
  - `/Library/Preferences`
  - `/var/root/Library/Preferences`

If you can't find the file, you might be dealing with a sandboxed application (look in `~/Library/Containers`), it might persist the settings in another way (KMB) or use a Saved Application State (?). Running `sudo fs_usage -f filesys <pid>` might give another clue.

## Todo
- finish macsettings execution module to change difficult settings on the fly (esp. changing scrolling direction)
- incorporate some important settings, maybe in the form of a profile (screensaver config!)
- install arbitrary profiles
- finish adding all options from previous iteration
- add following system preferences settins:
  + Notifications & Focus (file: `~/Library/Preferences/com.apple.ncprefs.plist`), example:
  ```yaml
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
  ```
  + Login Items for users?
  + more from Accessibility (eg doubleclick speed)
  + Screen Time? probably not possible with plists at least
  + Share Menu (file: `~/Library/Preferences/com.apple.preferences.extensions.ShareMenu.plist` for displayOrder, a bunch of `com.apple.preferences.extensions.*.plist` for active/inactive)
  + Finder Extensions (file: `~/Library/Preferences/pbs.plist` FinderActive / FinderOrdering)
  + Keyboard shortcuts

## References
- https://shadowfile.inode.link/blog/2018/06/advanced-defaults1-usage/
- https://shadowfile.inode.link/blog/2018/08/defaults-non-obvious-locations/
- https://shadowfile.inode.link/blog/2018/08/autogenerating-defaults1-commands/
- https://github.com/joeyhoer/starter
- https://github.com/mathiasbynens/dotfiles/
- https://git.herrbischoff.com/awesome-macos-command-line/about/
- https://github.com/zcutlip/prefsniff
- https://github.com/mosen/salt-osx
- specific ones found in some of the state files

## Interesting Links
https://managingosx.wordpress.com/2015/02/05/accessing-more-frameworks-with-python-2/
https://gist.github.com/pudquick/1362a8908be01e23041d
https://github.com/robperc/FinderSidebarEditor
https://michaellynn.github.io/2015/08/08/learn-you-a-better-pyobjc-bridgesupport-signature/
https://github.com/colin-stubbs/salt-formula-macos
