Hitting backspace in Safari will not take you to previous page:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled
    - value: False
    - vtype: bool
    - user: {{ user.name }}
