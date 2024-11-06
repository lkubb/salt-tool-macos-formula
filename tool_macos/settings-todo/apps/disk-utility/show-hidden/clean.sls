# vim: ft=sls

Disk Utility shows hidden partitions:
  macdefaults.write:
    - domain: com.apple.DiskUtility
    - name: DUShowEveryPartition
    - value: False
    - vtype: bool
    - user: {{ user.name }}
