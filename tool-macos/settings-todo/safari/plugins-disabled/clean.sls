Safari plug-ins are enabled:
  macdefaults.write:
    - domain: com.apple.Safari
    - names:
      - WebKitPluginsEnabled
      - com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled
    - value: True
    - vtype: bool
    - user: {{ user.name }}
