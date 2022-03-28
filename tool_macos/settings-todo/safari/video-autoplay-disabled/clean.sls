Videos autoplay in Safari part 1:
  macdefaults.write:
    - domain: com.apple.Safari
    - names:
      - WebKitMediaPlaybackAllowsInline
      - com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback
    - value: True
    - vtype: bool
    - user: {{ user.name }}

Videos autoplay in Safari part 2:
  macdefaults.write:
    - domain: com.apple.SafariTechnologyPreview
    - names:
      - WebKitMediaPlaybackAllowsInline
      - com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback
    - value: True
    - vtype: bool
    - user: {{ user.name }}
