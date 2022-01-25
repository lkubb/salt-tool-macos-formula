mDNSResponder was reloaded:
  cmd.wait:
    - name: killall mDNSResponder
    - watch: []
    - onlyif:
        - pgrep mDNSResponder
