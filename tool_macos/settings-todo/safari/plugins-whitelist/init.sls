# vim: ft=sls

Safari plug-ins need to be whitelisted manually before running:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: PlugInFirstVisitPolicy
    - value: PlugInPolicyBlock
    - vtype: string
    - user: {{ user.name }}
