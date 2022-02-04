{#- This was intended to be accomplished with an empty onchanges dict, but
    that will only work if there is at least one item in there. Thus, I
    had to switch to cmd.wait and watch_in.

    See: https://github.com/saltstack/salt/issues/44831
 -#}

include:
  - .adprivacyd
  - .bluetoothd
  - .cfprefsd
  - .controlcenter
  - .coreaudiod
  - .corebrightnessd
  - .dock
  - .finder
  - .mdnsresponder
  - .notificationcenter
  - .quicklook
  - .socketfilterfw
  - .systemuiserver
