# vim: ft=sls

Safari does not automatically stop plugins to save power:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: com.apple.Safari.ContentPageGroupIdentifier.WebKit2PlugInSnapshottingEnabled
    - value: False
    - vtype: bool
    - user: {{ user.name }}

# https://github.com/joeyhoer/starter/blob/master/apps/safari.sh
