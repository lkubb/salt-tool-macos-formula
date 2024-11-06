# vim: ft=sls

Safari does not update extensions automatically:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: InstallExtensionUpdatesAutomatically
    - value: False
    - vtype: bool
    - user: {{ user.name }}
