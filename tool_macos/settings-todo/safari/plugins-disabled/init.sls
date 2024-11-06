# vim: ft=sls

Safari plug-ins are disabled:
  macdefaults.write:
    - domain: com.apple.Safari
    - names:
      - WebKitPluginsEnabled # legacy
      - com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled
    - value: False
    - vtype: bool
    - user: {{ user.name }}
