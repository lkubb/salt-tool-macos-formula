Safari does not send Do Not Track header:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: SendDoNotTrackHTTPHeader
    - value: True
    - vtype: bool
    - user: {{ user.name }}
