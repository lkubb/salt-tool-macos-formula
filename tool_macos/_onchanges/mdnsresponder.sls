mDNSResponder was reloaded:
  cmd.wait:  # noqa: 213
    - name: killall mDNSResponder
    - watch: []
    - onlyif:
        - pgrep mDNSResponder
