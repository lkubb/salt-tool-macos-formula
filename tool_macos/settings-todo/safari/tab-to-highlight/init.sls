# vim: ft=sls

Press Tab to highlight each item on a web page:
  macdefaults.write:
    - domain: com.apple.Safari
    - names:
      - WebKitTabToLinksPreferenceKey
      - com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks
    - value: True
    - vtype: bool
    - user: {{ user.name }}
