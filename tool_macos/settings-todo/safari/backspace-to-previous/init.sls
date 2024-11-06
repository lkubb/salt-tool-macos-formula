# vim: ft=sls

Hitting backspace in Safari will take you to previous page:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled
    - value: True
    - vtype: bool
    - user: {{ user.name }}
