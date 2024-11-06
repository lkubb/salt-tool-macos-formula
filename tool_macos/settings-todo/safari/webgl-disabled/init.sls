# vim: ft=sls

WebGL in Safari is disabled:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: com.apple.Safari.ContentPageGroupIdentifier.WebKit2WebGLEnabled
    - value: False
    - vtype: bool
    - user: {{ user.name }}
