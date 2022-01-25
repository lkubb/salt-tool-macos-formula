Safari defaults to UTF-8 encoding:
  macdefaults.write:
    - domain: com.apple.Safari
    - names:
      - WebKitDefaultTextEncodingName
      - com.apple.Safari.ContentPageGroupIdentifier.WebKit2DefaultTextEncodingName
    - value: utf-8
    - vtype: string
    - user: {{ user.name }}

# https://github.com/joeyhoer/starter/blob/master/apps/safari.sh
