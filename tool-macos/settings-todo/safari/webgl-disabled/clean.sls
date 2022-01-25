WebGL in Safari is enabled:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: com.apple.Safari.ContentPageGroupIdentifier.WebKit2WebGLEnabled
    - value: True
    - vtype: bool
    - user: {{ user.name }}
