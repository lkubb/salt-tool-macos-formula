Safari updates extensions automatically:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: InstallExtensionUpdatesAutomatically
    - value: True
    - vtype: bool
    - user: {{ user.name }}
